#
# Based on:
#
# https://github.com/TAKEALOT/nodervisor            => Nodervisor
# https://github.com/dockerfile/ubuntu-desktop      => Ubuntu Desktop
# https://github.com/jpetazzo/dind/                 => Docker-in-Docker
# https://github.com/soundyogi/cloud9core-docker/   => Cloud9-docker
# Pull base image.
FROM ubuntu:latest

# Maintainer Informaion
MAINTAINER @rvmn

# Update the base image
RUN sed -i.bak 's/main$/main universe/' /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -qq

# Install Supervisord
RUN apt-get install -qq supervisor

# Make the necessary folders for Supervisord
RUN mkdir -p /var/log/supervisor /etc/supervisor/conf.d
# ------------------------------------------------------------------------------
# Install base
RUN apt-get install -y build-essential g++ curl libssl-dev apache2-utils git libxml2-dev
    
# ------------------------------------------------------------------------------
# Install NPM 
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -y nodejs
RUN curl -L https://npmjs.com/install.sh | sh

# ------------------------------------------------------------------------------
# Install NVM
RUN git clone https://github.com/creationix/nvm.git /.nvm
RUN echo ". /.nvm/nvm.sh" >> /etc/bash.bashrc
RUN /bin/bash -c '. /.nvm/nvm.sh && \
    nvm install v0.10.18 && \
    nvm use v0.10.18 && \
    nvm alias default v0.10.18'

# ------------------------------------------------------------------------------
# Install Cloud9SDK
RUN git clone https://github.com/c9/core/ /c9sdk
WORKDIR /c9sdk
RUN scripts/install-sdk.sh

# ------------------------------------------------------------------------------
# Setup LXDE VNC system
# Install LXDE and VNC server.
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y lxde-core lxterminal tightvncserver 
ENV USER=root

# ------------------------------------------------------------------------------
# Install Nodervisor
RUN git clone https://github.com/TAKEALOT/nodervisor ~/nodervisor && cd ~/nodervisor $$ npm install && chmod +x app.js && chmod +x config.js && sed -i s/1234567890ABCDEF/"$(od -vAn -N4 -tu4 < /dev/urandom)"/ config.js && sed -i "s/3000/3200/" config.js

# ------------------------------------------------------------------------------
# Install Docker
RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables
RUN curl -sSL https://get.docker.com/ubuntu/ | sh

# ------------------------------------------------------------------------------
# Install Docker aliases
ADD dockeraliases /root/
RUN chmod +x /root/dockeraliases && cat /root/dockeraliases >> ~/.bashrc && cat ~/.bashrc
RUN /bin/bash -c 'source ~/.bashrc'

# ------------------------------------------------------------------------------
# Add supervisord conf and wrapdocker
# Make the necessary folders for Supervisord
RUN mkdir -p /var/log/supervisor /etc/supervisor/conf.d

# Add the base configuration file for Supervisord
ADD supervisor.conf /etc/supervisor.conf
ADD conf/c9.conf /etc/supervisor/conf.d/

ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# ------------------------------------------------------------------------------
# Add volumes
RUN mkdir /workspace
RUN mkdir /var/lib/docker
VOLUME /workspace
VOLUME /var/lib/docker

# ------------------------------------------------------------------------------
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ------------------------------------------------------------------------------
# Expose ports.
EXPOSE 8181 # Expose cloud9
EXPOSE 5901 # Expose VNC LXDE
EXPOSE 3200 # Expose nodervisor

# ------------------------------------------------------------------------------
# Start supervisor, define default command.
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
