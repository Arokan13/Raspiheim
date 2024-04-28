Minimum Requirements:
- Raspberry Pi 4
- 4GB RAM
- 64-bit OS


Docker run

    docker run -d \ 
    --name raspiheim \
    --hostname raspiheim \
    -p 2456:2456/udp \
    -p 2457:2457/udp \
    -e SERVER_NAME=Raspiheim \
    -e WORLD_NAME=Raspiworld \
    -e SERVER_PASS=Raspipass \
    -e PUBLIC=disabled \
    -e UPDATE=enabled \
    -e PAUSE=disabled \
    -v /path/to/valheim/data:/data \
    -v /path/to/valheim/server:/valheim \
    --restart=unless-stopped \
    arokan/raspiheim:latest


Docker-Compose

    version: "3"

    services:
      raspiheim:
        image: arokan/raspiheim:latest
        container_name: raspiheim
        environment:
          - SERVER_NAME=Raspiheim
          - SERVER_PASS=Raspipass
          - WORLD_NAME=Raspiworld
          - PUBLIC=disabled
          - CROSSPLAY=disabled
          - UPDATE=enabled
          - SAVE_INTERVAL=1800
          - BOX86=default #default,latest,version-number
          - BOX64=default #default,latest,version-number
          - NO_BUILD_COST=disabled
          - PLAYER_EVENTS=disabled
          - PASSIVE_MOBS=disabled
          - NO_MAP=disabled
          # - PRESET=normal #normal,casual,easy,hard,hardcore,immersive,hammer
          # - MODIFIER_COMBAT= #veryeasy,easy,hard,veryhard
          # - MODIFIER_DEATHPENATLY= #casual,veryeasy,easy,hard,hardcore
          # - MODIFIER_RESOURCES= #muchless,less,more,muchmore,most
          # - MODIFIER_RAIDS= #none,muchless,less,more,muchmore
          # - MODIFIER_PORTALS= #casual,hard,veryhard
        ports:
          - "2456:2456/udp"
          - "2457:2457/udp"
        volumes:
          - "/path/to/valheim/data:/data"
          - "/path/to/valheim/server:/valheim"
        restart: unless-stopped


Variables

- SERVER_NAME= Server name in the lobby
- WORLD_NAME= Name of your save data
- SERVER_PASS= Your server password
- PUBLIC= Determines whether or not your server is shown in the lobby. Set to 0 for private and 1 for public. Remember to forward 2456/udp in your router
- UPDATE= Determines whether the server should look for updates and install them.
- PAUSE= Pauses container while nobody is connected and brings it back up seamlessly. While it is paused, your server will not be displayed in the lobby. Now only recommended on Raspi5


Behaviour

To keep the container slim, Valheim will be downloaded when the container is started and no persistence has been set.
If persistence is set and Valheim is downloaded, it will update when the variable is set to true.

The container may take up to 3GB of RAM, although running a while, 2GB will be written to the SWAP and back to RAM again when required, which is why at least 2GB of SWAP is recommended. I haven't tried it with ZRAM yet so if you're brave, go ahead and send me the result. If it runs well, I'm happy to implement a ZRAM-Solution.
Starting the server takes about 15-30 (Raspi4) minutes each time, so be patient! It takes even a little longer to build a world rather than loading an existing one.

Place your Save-Worlds in /path/to/valheim/data/worlds_local/

Known Issues:
Common:
- If the save-file approaches 100MB and has insufficient RAM/Storage-speed, disconnects may occur when the server tries to handle saving and RAM-organisation. This is, as far as I can tell, something for the valheim-devs to fix.

Rare or allegedly fixed:
- Sometimes the server appears to crash when two or more people are logged in and one logs out. Doesn't appear to be the case if only one is connected. Issue is being looked into.

- Discovering new biomes can lead to them not correctly loading. A simple restart will do the trick.

- Enabling the Pause-Feature can cause the server to shutdown when the CPU-workload is at max. even though somebody is still connected.

Aspirations:
I've been requested to implement BepInEx-Support several times now and tried to do so, but as of now a certain library is causing trouble to BOX64.

Changelog

  - 1.3: Brought back full functionality. - Boot-time seems to be significantly increased while online performance has improved. - Crossplay enabled. - Further server-settings enabled. - 
            removed true/false flags. enabled/disabled and 1/0 will work universally. - As versioning of box86/64 has caused the most trouble throughout the lifetime of this container, I 
            implemented a way to choose the version specifically. This way it's easier for the user to fix the issue by oneself in case I don't have the time to update the container (which will 
            mostly be the case).

  - 1.2: Added feature to pause the server when no player is connected. It is resumed once somebody tries to connect. Logs will be saved in /data/logs.

  - 1.1: Fixed steamcmd not being able to update/download the server software due to an incompatibility between the updated steamcmd-version and the installed box86-version. An update for box86 to v.0.2.5 fixed the issue.


  Acknowledgements

This container uses Box86 to use steamcmd and Box64 to start the server.
Big thanks to PiLabs for this amazing piece of software.
Please consider supporting them by checking out their
YouTube-Channel: https://www.youtube.com/channel/UCgfQjdc5RceRlTGfuthBs7g

Thanks to slipperman1 for encouraging me to build the pause-feature and providing some inspiration and advise on how to implement it!

If you found this container useful, encounter any bugs or find it not to be working at all, feel free to message me! (Discord: arokan13)
