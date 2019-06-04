#!/bin/bash

param=$1

install(){
	echo "hydro is ready to start"
	java -jar -Dfile.encoding=utf-8 -Dloader.path=.,"hydro-config.yaml" hydro.jar
}

shutdown(){
	curl -X POST 127.0.0.1:12138/HydroSys/shutdown
}

update(){
	hydroRoot=$(dirname $(readlink -f $0))
	if [ ! -d ${hydroRoot}/update/hydro ]; then
		echo "cannot find the update package - ${hydroRoot}/update/hydro"
	else
		shutdown
		sleep 3s
		echo "starting copy files"
		cp -a ${hydroRoot}/update/hydro/* ${hydroRoot}
		rm -rf ${hydroRoot}/update
		install
	fi
}

if [ "-i" == "$param" ]; then
	install
elif [ "-u" == "$param" ]; then
	update
elif [ "-s" == "$param" ]; then
	shutdown
fi
