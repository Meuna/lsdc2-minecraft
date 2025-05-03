FROM docker.io/eclipse-temurin:21-jre

ENV LSDC2_USER=lsdc2 \
    LSDC2_HOME=/lsdc2 \
    LSDC2_UID=2000 \
    LSDC2_GID=2000

WORKDIR $LSDC2_HOME

RUN apt-get update && apt-get install -y jq tmux \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -g $LSDC2_GID -o $LSDC2_USER \
    && useradd -g $LSDC2_GID -u $LSDC2_UID -d $LSDC2_HOME -o --no-create-home $LSDC2_USER \
    && chown -R $LSDC2_USER:$LSDC2_USER $LSDC2_HOME \
    && echo "eula=true" > eula.txt

ADD https://github.com/Meuna/lsdc2-pilot/releases/download/v0.5.2/lsdc2-pilot /usr/local/bin
COPY start-server.sh server.properties $LSDC2_HOME
RUN chown $LSDC2_USER:$LSDC2_USER start-server.sh server.properties \
    && chmod +x /usr/local/bin/lsdc2-pilot start-server.sh

ENV GAME_SAVENAME=lsdc2 \
    GAME_PORT=25565

ENV LSDC2_SNIFF_FILTER="tcp dst port $GAME_PORT" \
    LSDC2_PERSIST_FILES="$GAME_SAVENAME;server.properties" \
    LSDC2_ZIPFROM=$LSDC2_HOME

ENTRYPOINT ["lsdc2-pilot"]
CMD ["./start-server.sh"]
