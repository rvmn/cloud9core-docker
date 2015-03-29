# ------------------------------------------------------------------------------
# Based on a work at https://github.com/docker/docker.
# ------------------------------------------------------------------------------
# Pull base image.
FROM dockerfile/supervisor
MAINTAINER rvmn <di_blabla@hotmail.com>

# ------------------------------------------------------------------------------
# Install base
RUN apt-get update
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
# Install Docker in Docker (dind)
#ADD dind /usr/local/bin/
RUN apt-get -y install docker.io
RUN ln -sf /usr/bin/docker.io /usr/local/bin/docker
RUN sed -i '$acomplete -F _docker docker' /etc/bash_completion.d/docker.io
RUN update-rc.d docker.io defaults

# ------------------------------------------------------------------------------
# Install Docker aliases
ADD dockeraliases /root/
RUN chmod +x /root/dockeraliases && cat /root/dockeraliases >> ~/.bashrc && cat ~/.bashrc
RUN /bin/bash -c 'source ~/.bashrc'

# ------------------------------------------------------------------------------
# Add volumes
RUN mkdir ~/workspace
VOLUME /workspace
VOLUME /var/lib/docker

# Add supervisord conf
ADD conf/c9.conf /etc/supervisor/conf.d/

# ------------------------------------------------------------------------------
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ------------------------------------------------------------------------------
# Expose ports.
EXPOSE 8181

# ------------------------------------------------------------------------------
# Start supervisor, define default command.
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
