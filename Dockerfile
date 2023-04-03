# debian bullseye slim
FROM debian@sha256:37096792055ed86f0fc67a80bd67295a475557ad1136a76be04213b6b672d442 as builder

#Install Prerequisits
RUN dpkg --add-architecture armhf \
&&  apt-get update -y \
&&  apt-get upgrade -y \
&&  apt-get install --no-install-recommends -y git build-essential cmake python3 curl gcc-arm-linux-gnueabihf libc6:armhf libncurses5:armhf libstdc++6:armhf \
&&  rm -rf /var/lib/apt/lists/*

#Install Box86
RUN git clone https://github.com/ptitSeb/box86.git \
&&  mkdir -p ./box86/build /build/box86 \
&&  cd ./box86/build \
&&  cmake .. -DRPI4ARM64=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo \
&&  make -j4 \
&&  make install \
&&  cp  /usr/local/bin/box86 \
        /etc/binfmt.d/box86.conf \
        /usr/lib/i386-linux-gnu/libstdc++.so.6 \
        /usr/lib/i386-linux-gnu/libstdc++.so.5 \
        /usr/lib/i386-linux-gnu/libgcc_s.so.1 \
            /build/box86/

#Install Box64
RUN git clone https://github.com/ptitSeb/box64.git \
&&  mkdir -p ./box64/build /build/box64 \
&&  cd ./box64/build \
&&  cmake .. -DRPI4ARM64=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo \
&&  make -j4 \
&&  make install \
&&  cp  /usr/local/bin/box64 \
        /etc/binfmt.d/box64.conf \
        /usr/lib/x86_64-linux-gnu/libstdc++.so.6 \
        /usr/lib/x86_64-linux-gnu/libgcc_s.so.1 \
            /build/box64/

# Install Steamcmd
RUN mkdir -p /build/steamcmd \
&&  cd /build/steamcmd \
&&  curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

#Install BepInEx
#RUN mkdir -p /build/BepInEx \
#&&  cd /build/BepInEx \
#&&  curl -sqL "https://valheim.plus/cdn/0.9.9/UnixServer.tar.gz" | tar zxvf - \
#&&  rm ./BepInEx/plugins/ValheimPlus.dll



FROM debian@sha256:37096792055ed86f0fc67a80bd67295a475557ad1136a76be04213b6b672d442

RUN  dpkg --add-architecture armhf \
&&   apt-get update -y \
&&   apt-get upgrade -y \
&&   apt-get --no-install-recommends install libc6:armhf ca-certificates knockd bc -y \
&&   rm -rf /var/lib/apt/lists/*

COPY --from=builder /build/ /

RUN mkdir -p    /scripts \
				/usr/local/bin \
                /etc/binfmt.d \
                /usr/lib/i386-linux-gnu \
&&  mv          /box86/box86 \
                /usr/local/bin/box86 \
&&  mv          /box86/box86.conf \
                /etc/binfmt.d/box86.conf \
&&  mv          /box86/lib* \
                /usr/lib/i386-linux-gnu/ \
&&  mkdir -p    /usr/local/bin \
                /etc/binfmt.d \
                /usr/lib/x86_64-linux-gnu \
&&  mv          /box64/box64 \
                /usr/local/bin/box64 \
&&  mv          /box64/box64.conf \
                /etc/binfmt.d/box64.conf \
&&  mv          /box64/lib* \
                /usr/lib/x86_64-linux-gnu/ \
&&  rm -r       /box86 /box64


# Install BepInEx, required library and scripts
COPY ./add /scripts/
RUN chmod +x /scripts/valheim.sh

# Setting Environmental Variables
ENV SERVER_NAME=Raspiheim \
    WORLD_NAME=Raspiworld \
    SERVER_PASS=Raspipass \
    SAVE_DIR=/data \
    PUBLIC=0 \
    UPDATE=false \
    MODS_ENABLED=false \
    PAUSE=false

EXPOSE 2456/udp 2457/udp

ENTRYPOINT ["/scripts/valheim.sh"]
