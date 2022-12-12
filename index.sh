#!/bin/bash

downloadPath="https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar"
echo Downloading app.asar from $downloadPath
curl -L $downloadPath > openasar.asar
echo

asarPaths=(
    # Stable
    "/opt/discord/resources/app.asar"
    "/usr/lib/discord/resources/app.asar"
    "/usr/lib64/discord/resources/app.asar"
    "/usr/share/discord/resources/app.asar"
    "/var/lib/flatpak/app/com.discordapp.Discord/current/active/files/discord/resources/app.asar"

    # PTB
    "/opt/discord-ptb/resources/app.asar"
    "/usr/lib/discord-ptb/resources/app.asar"
    "/usr/lib64/discord-ptb/resources/app.asar"
    "/usr/share/discord-ptb/resources/app.asar"
    # "/var/lib/flatpak/app/com.discordapp.DiscordPTB/current/active/files/discord-ptb/resources/app.asar" # not sure if that's the path for DiscordPTB on flatpak

    # Canary
    "/opt/discord-canary/resources/app.asar"
    "/usr/lib/discord-canary/resources/app.asar"
    "/usr/lib64/discord-canary/resources/app.asar"
    "/usr/share/discord-canary/resources/app.asar"
    # "/var/lib/flatpak/app/com.discordapp.DiscordCanary/current/active/files/discord-canary/resources/app.asar" # not sure if that's the path for DiscordCanary on flatpak
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

customPath() {
    while true; do
        read -p "Set a custom path: " discordAsar
        if [[ -f $discordAsar ]]; then
            break
        else
            echo File does not exist.
        fi
    done
}

if [ -z "$discordAsar" ]; then
    echo Could not find a discord path.
    customPath
fi

while true; do
    read -p "Found $discordAsar as the app.asar file of your discord installation. Do you wanna change? (Y/N) " yn
    case $yn in
        [Yy]* ) customPath; break;;
        [Nn]* ) break;;
        * ) ;;
    esac
done

echo Using $discordAsar
echo

echo Renaming old app.asar file
sudo mv $discordAsar $discordAsar.og
echo Renamed to $(basename $discordAsar.og)
echo

echo Copying openasar.asar to discord folder
sudo cp openasar.asar $discordAsar
echo Copied successfully. You can now start Discord with OpenAsar