#!/bin/sh

NAME=emacs-eclim
VER=0.3
INSTANCE=${NAME}:${VER}

echo ""
ALIVE=$(docker ps | grep ${NAME} | awk '{print $1}')
if [ "$ALIVE" != "" ];then
	echo "=== docker connect to old instances"
	docker attach $ALIVE
	exit 0;
fi

echo "=== docker rm old instances"
docker rm $(docker ps -a | grep ${NAME} | awk '{print $1}')

echo ""
echo "=== docker run ${INSTANCE}"
docker run -it --name=${NAME} \
	-v ~/eclim-wks:/home/docker/workspace \
	-v ~/.gitconfig:/home/docker/.gitconfig \
	-v ~/.m2:/home/docker/.m2 \
	${INSTANCE} \
	/sbin/my_init -- su - docker 

