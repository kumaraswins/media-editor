#!/bin/bash
# ------------------------------------------------------------------------ #
#    Downloads the Audio Video and Converts the video files to mp4 format  #
# ------------------------------------------------------------------------ #
# ======================================================================== #
# ------------------------------------------------------------------------ #
#                   Downloads the Audio Video                              #
# ------------------------------------------------------------------------ #
download_files(){
    while IFS= read -r line; do
        echo "Downloads: $line"
        echo "Command "${DOWNLOAD_URL}""${line}""
        $DOWNLOAD_URL$line
    done < read
}
# ======================================================================== #
# Selects the operation type
# 1 audio - given the video url it will convert the video into mp3 file
# 2 video - download the mp4 format by default which has high video and audio quality
# 3 if the above format is not available then it lists the format type, then you can choose custom
# 4 to download in the desired format, execute the above command and select the number, when it prompts `enter your type`, type 18 by default
# 5 Convert - "mkv" "mov" "MOV" "webm" to mp4 format
# ======================================================================== #
echo '*********** Select Type ***********'
options=("audio" "video" "types" "custom" "convert")
select opt in "${options[@]}"
do
    case $opt in
        "audio")
            echo "you chose  $opt "
            type=$opt
            echo "Enter the folder name where the files to be saved"
            read audioFolder
            mkdir $audioFolder
            echo "SELECTED AUDIO"
            DOWNLOAD_URL="youtube-dl -o "${audioFolder}"/%(title)s.%(ext)s --extract-audio --audio-format mp3 "
            download_files
            break
            ;;
        "video")
            echo "you chose  $opt"
            type=$opt
            echo "Enter the folder name where the files to be saved"
            read videoFolder
            mkdir $videoFolder
            echo "SELECTED VIDEO, dowloads the mp4 format"
            DOWNLOAD_URL="youtube-dl -o "${videoFolder}"/%(title)s.%(ext)s -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4' "
            download_files
            break
            ;;
        "types")
            echo "you chose  $opt"
            type=$opt
            DOWNLOAD_URL="youtube-dl -F "
            download_files
            break
            ;;
        "custom")
            echo "you chose  $opt"
            echo "enter your type"
            type=$opt
            read type
            echo "Enter the folder name where the files to be saved"
            read videoFolder
            mkdir $videoFolder
            DOWNLOAD_URL="youtube-dl  -o "${videoFolder}"/%(title)s.%(ext)s  -f  "${type}" "
            download_files
            break
            ;;
        "convert")
            echo "you chose  $opt"
            type=$opt
            break
            ;;

        *) echo "invalid option $REPLY";;
    esac
done
# ======================================================================== #
# If conversion is selected then it asks for media types
# All the media types are converted to mp4
# ======================================================================== #
if [ "$type" == "convert" ]; then
    echo "SELECTED AUDIO"
    echo "Enter the folder name where the files to be saved"
    read folderName
    mkdir $folderName
    echo '*********** Select Media type ***********'
    options=("mkv" "mov" "MOV" "webm")
    select opt in "${options[@]}"
    do
        case $opt in
            "mkv")
                echo "SELECTED mkv, converting all the mkv format to mp4"
                 for i in *.mkv; do
                    ffmpeg -i "$i" -codec copy ""${folderName}"/${i%.*}.mp4"
                done   
                break
                ;;
            "mov")
                echo "you chose  $opt"
                echo "SELECTED mov, converting all the mov format to mp4"
                 for i in *.mov; do
                    ffmpeg -i "$i" -codec copy ""${folderName}"/${i%.*}.mp4"
                done   
                break
                ;;
            "webm")
                echo "you chose  $opt"
                echo "SELECTED webm, converting all the mov format to mp4"
                 for i in *.webm; do
                    ffmpeg -i "$i" -codec copy ""${folderName}"/${i%.*}.mp4"
                done   
                break
                ;;
            "MOV")
                echo "you chose  $opt"
                
                echo "SELECTED MOV, converting all the MOV format to mp4"
                 for i in *.MOV; do
                    ffmpeg -i "$i" -codec copy ""${folderName}"/${i%.*}.mp4"
                done  
                break
                ;;

            *) echo "invalid option $REPLY";;

        esac
    done
fi
# ======================================================================== #
echo ---------------------------------------------------------------
echo end