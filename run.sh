#!/bin/sh

NAME=emacs-eclim
VER=0.4
INSTANCE=${NAME}:${VER}

get_abs_filename() {
	# $1 : relative filename
	if [ -d "$(dirname "$1")"  ]; then
		echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
	fi
}
SCR_ABSPATH=$(get_abs_filename "$0")
SCR_DIRPATH=$(dirname "$SCR_ABSPATH")

echo ""
ALIVE=$(docker ps | grep ${INSTANCE} | awk '{print $1}')
if [ "$ALIVE" != "" ];then
	echo "=== docker connect to old instances"
	docker attach $ALIVE
	exit 0;
fi

echo "=== docker rm old instances"
docker rm $(docker ps -a | grep ${NAME} | awk '{print $1}')

echo ""
echo "=== docker run ${INSTANCE}"
docker run -dit --name=${NAME} \
	-v ~/eclim-wks:/home/docker/workspace \
	-v ~/.gitconfig:/home/docker/.gitconfig \
	-v ~/.m2:/home/docker/.m2 \
	-v ${SCR_DIRPATH}/emacs.d:/home/docker/.emacs.d \
	${INSTANCE} \
	/sbin/my_init -- su - docker 

