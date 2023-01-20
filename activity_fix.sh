#!/bin/bash

docker_name=$(docker ps -a|grep miner|awk -F" " '{print $NF}')
miner_name=$(docker exec $docker_name miner print_keys|awk '/pubkey/ {split($1,a,"\""); print a[2]}')
height=$(curl -s https://api.helium.io/v1/blocks/height | grep -Po '"height":[^}]+' | sed -e 's/^"height"://')
last_poc_challenge=$(curl -s https://api.helium.io/v1/hotspots/$miner_name |grep -Po '"last_poc_challenge":[^\,]+' | sed -e 's/^"last_poc_challenge"://')
gap=$(($height - $last_poc_challenge))

if [ "$gap" -gt 40 ];
then
    # echo "No activity for at least 60 blocks\nRestarting miner service...";
	
	# docker stop miner && docker rm miner && 
	# docker pull quay.io/team-helium/miner:miner-arm64_2022.10.28.0_GA && docker rmi -f quay.io/team-helium/miner:miner-amd64_2022.10.28.0_GA && docker rmi -f quay.io/team-helium/miner:miner-arm64_2022.08.17.1_GA &&
	# sudo docker run -d --init --ulimit nofile=64000:64000 --restart always --net host -e OTP_VERSION=23.3.4.7 -e REBAR3_VERSION=3.16.1 --name miner --mount type=bind,source=/home/pi/hnt/miner,target=/var/data --mount type=bind,source=/home/pi/hnt/miner/log,target=/var/log/miner --device /dev/i2c-0  --privileged -v /var/run/dbus:/var/run/dbus --mount type=bind,source=/home/pi/hnt/miner/configs/sys.config,target=/config/sys.config quay.io/team-helium/miner:miner-arm64_2022.10.28.0_GA
	
    docker restart $docker_name
else
    echo "Miner activity: Normal";
fi;
