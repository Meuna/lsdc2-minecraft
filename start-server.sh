#!/bin/bash
export HOME=$MINECRAFT_HOME

shutdown() {
    kill -INT $pid
}

if [ "$VERSION" = "latest" ]; then
    VERSION=$(curl -s $VERSION_MANIFEST | jq --raw-output '.latest.release')
fi
RELEASE_MANIFEST=$(curl -s $VERSION_MANIFEST | jq --raw-output --arg VER $VERSION '[.versions[] | select(.id == $VER)][0].url')
SERVER_URL=$(curl -s $RELEASE_MANIFEST | jq --raw-output '.downloads.server.url')
curl -s $SERVER_URL -o minecraft-server.jar

trap shutdown SIGINT SIGTERM

java -Xmx4G -jar minecraft-server.jar --port $SERVER_PORT --nogui --world $WORLD_NAME &
pid=$!
wait $pid
