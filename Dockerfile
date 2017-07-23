FROM phusion/baseimage:0.9.22
MAINTAINER Tatsuya Kawano

ENV HOME /root

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y language-pack-en
ENV LANG en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8
RUN (mv /etc/localtime /etc/localtime.org && \
     ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime)

RUN (apt-get update && \
     DEBIAN_FRONTEND=noninteractive \
     apt-get install -y build-essential software-properties-common \
                        zlib1g-dev libssl-dev libreadline-dev libyaml-dev \
                        libxml2-dev libxslt-dev sqlite3 libsqlite3-dev \
                        git byobu wget curl unzip tree \
                        python)

# Add a non-root user
RUN (useradd -m -d /home/docker -s /bin/bash docker && \
     echo "docker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers)

# Install eclim requirements
RUN (apt-get install -y openjdk-7-jdk ant maven \
                        xvfb xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic)

ADD emacs.d /home/docker/.emacs.d
RUN chown -R docker:docker /home/docker/.emacs.d

# Install Emacs 2.5
RUN (apt-add-repository -y ppa:adrozdoff/emacs && apt-get update -y && \
     DEBIAN_FRONTEND=noninteractive \
     apt-get install -y emacs25)

USER docker
ENV HOME /home/docker
WORKDIR /home/docker

# Install Cask
#RUN curl -fsSkL https://raw.githubusercontent.com/cask/cask/master/go | python
#RUN (/bin/bash -c 'echo export PATH="/home/docker/.cask/bin:$PATH" >> /home/docker/.profile' && \
#     /bin/bash -c 'source /home/docker/.profile && cd /home/docker/.emacs.d && cask install')

# Setup Emacs
#RUN (/bin/bash -c 'source /home/docker/.profile && cd /home/docker/.emacs.d')


# Download Eclipse and eclim
RUN (wget -P /home/docker http://ftp.yz.yamagata-u.ac.jp/pub/eclipse/technology/epp/downloads/release/mars/R/eclipse-java-mars-R-linux-gtk-x86_64.tar.gz && \
     tar xzvf eclipse-java-mars-R-linux-gtk-x86_64.tar.gz -C /home/docker && \
     rm eclipse-java-mars-R-linux-gtk-x86_64.tar.gz && \
     mkdir /home/docker/workspace && \
     cd /home/docker && \
     git clone git://github.com/ervandew/eclim.git)

ENV ECLIM_VERSION 2.6.0
# Build eclim
RUN (cd /home/docker/eclim && git checkout tags/${ECLIM_VERSION} && \
     ant -Declipse.home=/home/docker/eclipse)

USER root
ADD service /etc/service
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
