#!/bin/bash
# ------------------------------------------------------------------------ #
#    Downloads the Audio Video and Converts the video files to mp4 format  #
# ------------------------------------------------------------------------ #
# ======================================================================== #
# ------------------------------------------------------------------------ #
#                   Downloads the Audio Video                              #
# ------------------------------------------------------------------------ #
# ---------------------------Init----------------------------------------- #
selectedCompressionType=''
selectedResolutionType=''
selectedVideoFormat=''
folderName=''
selectedFolderToModify=''
outputCompressedVideo=''
# ======================================================================== #
list_folders_in_directory(){
    for eachfile in `ls -d */`
    do
        echo $eachfile
        break
    done
}
__='
Selects the folder from where the files to read
right now the file has to be in the present directory
'
select_folder_to_modify(){
    echo '*********** Select the folder name to read the files ***********'
        options=("current path" "your folder name")
        select opt in "${options[@]}"
        do
            case $opt in
                "current path")
                    echo "you chose  $opt"
                    selectedFolderToModify="current"
                    break
                    ;;
                "your folder name")
                    echo "Enter your folder name, make sure it is in the same directory, type the listed folder name"
                    list_folders_in_directory
                    read selectedFolderToModify
                    cd $selectedFolderToModify
                    break
                    ;;
                *) echo "invalid option $REPLY";;

            esac
        done
}

# ======================================================================== #
# Selects the video type
# mkv    
# mov    
# MOV    
# mp4    
# ======================================================================== #
select_video_type(){
    echo '*********** Select video format or extension ***********'
    options=(".mkv" ".mov" ".MOV" ".mp4")
    select opt in "${options[@]}"
    do
        selectedVideoFormat=$opt
        break
    done
}
__='
Downloads the file one by one given the read file
Based on the Format and the type given by the user
'
create_folder(){
    echo "Enter the folder name, where the output saves"
    read folderName
    mkdir $folderName
    echo "folder created sucessfuly, all your media will be stored here."
}
__='
Downloads the file one by one given the read file
Based on the Format and the type given by the user
'
download_files(){
    while IFS= read -r line; do
        echo "Downloads: $line"
        echo "Command "${DOWNLOAD_URL}""${line}""
        $DOWNLOAD_URL$line
    done < read
    if [ "$0" == "no" ]; then
        echo "end"
    else
        open $0    
    fi
    echo "Downloaded all the given files successfuly, please check the folder"
    open $folderName
}
__='
Selected the compression type
low - 1024k
very low - 512k
'
select_compression_type(){
    echo '*********** Select the resolution type type ***********'
    options=("low" "very low")
    select opt in "${options[@]}"
    do
        case $opt in
            "low")
                echo "you chose  $opt"
                selectedCompressionType="1024k"
                break
                ;;
            "very low")
                echo "you chose  $opt"
                selectedCompressionType="512k"
                break
                ;;
            *) echo "invalid option $REPLY";;

        esac
    done
}
__='
Selects the resolution type
Portrait Mode 
Portrait mode compressed
Landscape mode 
Landscape mode compressed
'
select_resolution_type(){
    echo '*********** Select the resolution type type ***********'
    options=("1080x1920 - Portrait Mode" "540x960 - Portrait compressed" "1920x1080 - Landscape" "960x540 - Landscpe compressed")
    select opt in "${options[@]}"
    do
        case $opt in
            "1080x1920 - Portrait Mode")
                echo "you chose  $opt"
                selectedResolutionType="1080x1920"
                break
                ;;
            "540x960 - Portrait compressed")
                echo "you chose  $opt"
                selectedResolutionType="540x960"
                break
                ;;
            "1920x1080 - Landscape")
                echo "you chose  $opt"
                selectedResolutionType="1920x1080"
                break
                ;;
            "960x540 - Landscpe compressed")
                echo "you chose  $opt"
                selectedResolutionType="960x540"
                break
                ;;
            *) echo "invalid option $REPLY";;

        esac
    done
}
# ======================================================================== #
# Compression of video based on the landscape and portrait mode
# ======================================================================== #
compress_video(){
    select_compression_type
    select_resolution_type
    select_video_type
    create_folder # call create folder, to save the out in the file
    select_folder_to_modify
    for i in *"$selectedVideoFormat"; do
        if [ $selectedFolderToModify = "current" ]; then
            ffmpeg -i "$i" -s "$selectedResolutionType" -b:v "$selectedCompressionType" -vcodec mpeg1video -acodec copy ""${folderName}"/out_compressed_""$i"
        else
            ffmpeg -i "$i" -s "$selectedResolutionType" -b:v "$selectedCompressionType" -vcodec mpeg1video -acodec copy "../"${folderName}"/out_compressed_""$i"
        fi
    done       
}
# ======================================================================== #
# If conversion is selected then it asks for media types
# All the media types are converted to mp4
# ======================================================================== #
convert_video(){
    create_folder 
    select_video_type # selects the video extension type
    echo "Selected "$selectedVideoFormat", converting all the  "$selectedVideoFormat" format to mp4 files"
    select_folder_to_modify
    for i in *"$selectedVideoFormat"; do
        if [ $selectedFolderToModify = "current" ]; then
            ffmpeg -i "$i" -codec copy ""${folderName}"/${i%.*}.mp4"
        else
            ffmpeg -i "$i" -codec copy "../"${folderName}"/${i%.*}.mp4"
        fi
    done       
}
# ======================================================================== #
# ======================================================================== #
# Selects the operation type
# 1 audio - given the video url it will convert the video into mp3 file
# 2 video - download the mp4 format by default which has high video and audio quality
# 3 if the above format is not available then it lists the format type, then you can choose custom
# 4 to download in the desired format, execute the above command and select the number, when it prompts `enter your type`, type 18 by default
# 5 Convert - "mkv" "mov" "MOV" "webm" to mp4 format
# ======================================================================== #
echo '*********** Select Type ***********'
options=("convert mp3 from you tube" "download video from youtube" "types" "custom" "convert" "compress")
select opt in "${options[@]}"
do
    case $opt in
        "convert mp3 from you tube")
            echo "you chose  $opt "
            type="audio"
            create_folder
            DOWNLOAD_URL="youtube-dl -o "${folderName}"/%(title)s.%(ext)s --extract-audio --audio-format mp3 "
            download_files $folderName
            break
            ;;
        "download video from youtube")
            echo "you chose  $opt"
            type="video"
            create_folder
            DOWNLOAD_URL="youtube-dl -o "${folderName}"/%(title)s.%(ext)s -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4' "
            download_files $folderName
            break
            ;;
        "types")
            echo "you chose  $opt"
            type=$opt
            DOWNLOAD_URL="youtube-dl -F "
            download_files "no"
            break
            ;;
        "custom")
            echo "you chose  $opt"
            echo "enter your type"
            type=$opt
            read type
            create_folder
            DOWNLOAD_URL="youtube-dl  -o "${folderName}"/%(title)s.%(ext)s  -f  "${type}" "
            download_files $folderName
            break
            ;;
        "compress")
            echo "you chose  $opt"
            type=$opt
            compress_video
            break
            ;;
        "convert")
            echo "you chose  $opt"
            convert_video
            type=$opt
            break
            ;;

        *) echo "invalid option $REPLY";;
    esac
done

echo ---------------------------------------------------------------------
echo end