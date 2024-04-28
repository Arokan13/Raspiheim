#!/bin/bash
export templdpath=$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH
export SteamAppId=892970

#Managing Variables
if	[ "$PUBLIC" = "enabled" ] || [ "$PUBLIC" = "1" ];
	then	PUBLIC=1 && PUBLIC_STATUS=enabled;
	else	PUBLIC=0 && PUBLIC_STATUS=disabled;
	fi

if [ "$CROSSPLAY" = "enabled" ] || [ "$CROSSPLAY" = "1" ];
	then	CROSSPLAY="-crossplay" &&
			CROSSPLAY_STATUS=enabled;
	else	CROSSPLAY= &&
			CROSSPLAY_STATUS=disabled;
	fi

if [ -n "$MODIFIER_COMBAT" ]; then MODIFIER_COMBAT="-modifier combat $MODIFIER_COMBAT"; fi
if [ -n "$MODIFIER_DEATHPENATLY" ]; then MODIFIER_DEATHPENATLY="-modifier deathpenalty $MODIFIER_DEATHPENATLY"; fi
if [ -n "$MODIFIER_RESOURCES" ]; then MODIFIER_RESOURCES="-modifier resources $MODIFIER_RESOURCES"; fi
if [ -n "$MODIFIER_RAIDS" ]; then MODIFIER_RAIDS="-modifier raids $MODIFIER_RAIDS"; fi
if [ -n "$MODIFIER_PORTALS" ]; then MODIFIER_PORTALS="-modifier portals $MODIFIER_PORTALS"; fi

if [ "$NO_BUILD_COST" = "enabled" ]; then NO_BUILD_COST="-setkey nobuildcost"; else NO_BUILD_COST=""; fi
if [ "$PLAYER_EVENTS" = "enabled" ]; then PLAYER_EVENTS="-setkey playerevents"; else PLAYER_EVENTS=""; fi
if [ "$PASSIVE_MOBS" = "enabled" ]; then PASSIVE_MOBS="-setkey passivemobs"; else PASSIVE_MOBS=""; fi
if [ "$NO_MAP" = "enabled" ]; then NO_MAP="-setkey nomap"; else NO_MAP=""; fi

echo "Starting server PRESS CTRL-C to exit"

# Tip: Make a local copy of this script to avoid it being overwritten by steam.
# NOTE: Minimum password length is 5 characters & Password cant be in the server name.
# NOTE: You need to make sure the ports 2456-2458 is being forwarded to your server through your local router & firewall.

echo "Servername: $SERVER_NAME"
echo "Serverpass: $SERVER_PASS"
echo "World: $WORLD_NAME"
echo "Public: $PUBLIC_STATUS"
echo "Crossplay: $CROSSPLAY_STATUS"
sleep 1

box64 ./valheim_server.x86_64 \
-nographics \
-batchmode \
-name "$SERVER_NAME" \
-port 2456 \
-public $PUBLIC \
-world "$WORLD_NAME" \
-password "$SERVER_PASS" \
-savedir "$SAVE_DIR" \
-saveinterval "$SAVE_INTERVAL" \
-preset $PRESET \
$MODIFIER_COMBAT \
$MODIFIER_DEATHPENATLY \
$MODIFIER_RESOURCES \
$MODIFIER_RAIDS \
$MODIFIER_PORTALS \
$NO_BUILD_COST \
$PLAYER_EVENTS \
$PASSIVE_MOBS \
$NO_MAP \
$CROSSPLAY

export LD_LIBRARY_PATH=$templdpath
