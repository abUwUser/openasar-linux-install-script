#!/bin/bash

downloadPath="https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar"
echo Downloading app.asar from $downloadPath
curl -L $downloadPath > openasar.asar
echo

asarPaths=(
    "/opt/discord/resources/app.asar"
    "/usr/lib/discord/resources/app.asar"
    "/usr/lib64/discord/resources/app.asar"
    "/usr/share/discord/resources/app.asar"
    "/var/lib/flatpak/app/com.discordapp.Discord/current/active/files/discord/resources/app.asar"
)

for f in ${asarPaths[@]}; do
    if [[ -f $f ]]; then
        if [ -z "$discordAsar" ]; then
            discordAsar=$f
        else
            while true; do
                read -p "Multiple discord paths found. Do you want to install to $f instead of $discordAsar? (Y/N) " yn
                case $yn in
                    [Yy]* ) discordAsar=$f; break;;
                    [Nn]* ) break;;
                    * ) ;;
                esac
            done
        fi
    fi
done
if [ -z "$discordAsar" ]; then
    echo "No discord installation found. Please install discord and try again."
    exit 1
fi

echo Using $discordAsar
echo

echo Renaming old app.asar file
sudo mv $discordAsar $discordAsar.og
echo Renamed to $(basename $discordAsar.og)
echo

echo Copying openasar.asar to discord folder
sudo cp openasar.asar $discordAsar
echo Copied successfully. You can now start Discord with OpenAsar