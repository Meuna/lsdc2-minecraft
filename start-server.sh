#!/bin/bash
export HOME=$LSDC2_HOME

version_manifest_url=https://launchermeta.mojang.com/mc/game/version_manifest.json
version=$(curl -s $version_manifest_url | jq --raw-output '.latest.release')
release_manifest=$(curl -s $version_manifest_url | jq --raw-output --arg VER $version '[.versions[] | select(.id == $VER)][0].url')
version_url=$(curl -s $release_manifest | jq --raw-output '.downloads.server.url')
curl -s $version_url -o minecraft-server.jar

# The trap send the "exit" command to the server to trigger a world save
mkfifo /tmp/trapfifo

shutdown() {
    echo "/stop" > /tmp/trapfifo
}

trap shutdown SIGINT SIGTERM

java -Xmx4G -jar minecraft-server.jar --port $GAME_PORT --nogui --world $GAME_SAVENAME < /tmp/trapfifo &
minecraft_pid=$!

# This open the fifo and keep it open
exec 3>/tmp/trapfifo

wait $minecraft_pid
