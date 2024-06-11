#!/bin/bash
export PATH=/usr/local/bin/:$PATH
cp /etc/resolv.conf /
sed -i s/"nameserver ".*/"nameserver 1.1.1.1"/g /resolv.conf
cp /resolv.conf /etc/resolv.conf

#Manage Box86/64 version
if [ "$BOX86" != "default" ];
then	installed="$(apt-cache policy box86-rpi4arm64 | grep Installed | awk '{print $2}')"
		wanted="$(apt-cache policy box86-rpi4arm64 | grep 500 | grep "$BOX86" | awk 'NR==1 {print $2}')"
		latest="$(apt-cache policy box86-rpi4arm64 | grep Candidate | awk '{print $2}')"

	if [ "$BOX86" = "latest" ] && [ "$installed" != "$latest" ];
			then apt-get purge box86-rpi4arm64 -y && apt-get install box86-rpi4arm64=$latest;
	elif [ "$BOX86" = "wanted" ] && [ "$installed" != "$wanted" ];
			then apt-get purge box86-rpi4arm64 -y && apt-get install box86-rpi4arm64=$wanted;
	fi;
fi;

if [ "$BOX64" != "default" ];
then	installed="$(apt-cache policy box64-rpi4arm64 | grep Installed | awk '{print $2}')"
		wanted="$(apt-cache policy box64-rpi4arm64 | grep 500 | grep "$BOX64" | awk 'NR==1 {print $2}')"
		latest="$(apt-cache policy box64-rpi4arm64 | grep Candidate | awk '{print $2}')"

	if [ "$BOX64" = "latest" ] && [ "$installed" != "$latest" ];
			then apt-get purge box64-rpi4arm64 -y && apt-get install box64-rpi4arm64=$latest;
	elif [ "$BOX64" = "wanted" ] && [ "$installed" != "$wanted" ];
			then apt-get purge box64-rpi4arm64 -y && apt-get install box64-rpi4arm64=$wanted;
	fi;
fi;

# Upgrade Valheim to latest Version
if [ ! -f /valheim/start_server.sh ] || [ $UPDATE = enabled ] || [ $UPDATE = 1 ]; then
cd /steamcmd
echo "Updating the server..."
export LD_LIBRARY_PATH="/steamcmd/linux32:$LD_LIBRARY_PATH" && \
box86 ./linux32/steamcmd +login anonymous +quit >/dev/null;
export LD_LIBRARY_PATH="/steamcmd/linux32:$LD_LIBRARY_PATH" && \
box86 ./linux32/steamcmd +login anonymous +quit >/dev/null;
export LD_LIBRARY_PATH="/steamcmd/linux32:$LD_LIBRARY_PATH" && \
box86 ./linux32/steamcmd +@sSteamCmdForcePlatformType linux +force_install_dir /valheim +login anonymous +app_update 896660 validate +quit;
fi;

# Manage Persistency
cp -f /scripts/start_server.sh.tpl	/valheim/start_server.sh

cd /valheim

#Pause Option
if [ $PAUSE = enabled ] || [ $PAUSE = 1 ]; then
mkdir -p /data/logs
cp /scripts/knockd.conf /etc/knockd.conf
sed -i s.START_KNOCKD=0.START_KNOCKD=1.g /etc/default/knockd
service knockd restart
chmod +x /scripts/pause.sh
(/scripts/pause.sh)&
fi

# Start Server
chmod +x ./start_server.sh
export LOG_FILE="/data/logs/valheim-$(date '+%d.%m.%y - %H:%M:%S').log"
touch $LOG_FILE
echo "$LOG_FILE" > /data/logs/log-link.txt
./start_server.sh 2>/dev/null | tee -a "$LOG_FILE"
sleep 600
