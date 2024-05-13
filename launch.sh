#!/bin/sh
echo $0 $*
cd $(dirname "$0")

touch /tmp/timeout

grep '"hibernate"' /config/system.json | awk -F ':' '{print $2}' | tr -d ' ,' > /tmp/timeout
sed -i 's/"hibernate":.*/"hibernate": 0,/' /config/system.json

cpuclock performance 2 1200 300

HOME=/mnt/SDCARD/App/gmu
export LD_LIBRARY_PATH=./lib:$LD_LIBRARY_PATH

SDL_NOMOUSE=1 SDL_VIDEODRIVER=a30  ./gmu.bin -c gmu.miyoo.conf &> ./log.txt
sync

if [ -f /tmp/timeout ]; then
    hibernate=$(cat /tmp/timeout)
    sed -i "s/\"hibernate\":.*/\"hibernate\": $hibernate,/" /config/system.json
    rm /tmp/timeout
fi
