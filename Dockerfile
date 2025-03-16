FROM docker.io/eclipse-temurin:21-jre

ENV MINECRAFT_HOME=/minecraft/ \
    VERSION=latest

ENV VERSION_MANIFEST=https://launchermeta.mojang.com/mc/game/version_manifest.json \
    XMX=-Xmx4G \
    WORLD_NAME=lsdc2 \
    SERVER_PORT=25565

ENV LSDC2_SNIFF_IFACE="eth0" \
    LSDC2_SNIFF_FILTER="port $SERVER_PORT" \
    LSDC2_CWD=$MINECRAFT_HOME \
    LSDC2_UID=2000 \
    LSDC2_GID=2000 \
    LSDC2_PERSIST_FILES="$WORLD_NAME;server.properties" \
    LSDC2_ZIP=0 \
    LSDC2_ZIPFROM=$MINECRAFT_HOME

WORKDIR $MINECRAFT_HOME

ADD https://github.com/Meuna/lsdc2-serverwrap/releases/download/v0.2.0/serverwrap /serverwrap

COPY start-server.sh server.properties $MINECRAFT_HOME

RUN apt-get update && apt-get install -y jq \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -g $LSDC2_GID -o minecraft \
    && useradd -g $LSDC2_GID -u $LSDC2_UID -d $MINECRAFT_HOME -o --no-create-home minecraft \
    && chmod u+x /serverwrap start-server.sh \
    && chown -R minecraft:minecraft $MINECRAFT_HOME \
    && echo "eula=true" > eula.txt

ENTRYPOINT ["/serverwrap"]
CMD ["./start-server.sh"]
