FROM docker.io/eclipse-temurin:21-jre

ENV LSDC2_USER=lsdc2 \
    LSDC2_HOME=/lsdc2 \
    LSDC2_UID=2000 \
    LSDC2_GID=2000

WORKDIR $LSDC2_HOME

ADD https://github.com/Meuna/lsdc2-serverwrap/releases/download/v0.5.0/serverwrap /usr/local/bin
COPY start-server.sh server.properties $LSDC2_HOME
RUN apt-get update && apt-get install -y jq tmux \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -g $LSDC2_GID -o $LSDC2_USER \
    && useradd -g $LSDC2_GID -u $LSDC2_UID -d $LSDC2_HOME -o --no-create-home $LSDC2_USER \
    && chmod +x /usr/local/bin/serverwrap start-server.sh \
    && chown -R $LSDC2_USER:$LSDC2_USER $LSDC2_HOME \
    && echo "eula=true" > eula.txt

ENV GAME_SAVENAME=lsdc2 \
    GAME_PORT=25565

ENV LSDC2_SNIFF_FILTER="tcp port $GAME_PORT" \
    LSDC2_PERSIST_FILES="$GAME_SAVENAME;server.properties" \
    LSDC2_ZIPFROM=$LSDC2_HOME

ENTRYPOINT ["serverwrap"]
CMD ["./start-server.sh"]
