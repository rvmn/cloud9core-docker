# ------------------------------------------------------------------------------
# Based on a work at https://github.com/docker/docker.
# ------------------------------------------------------------------------------
# Pull base image.
FROM dockerfile/supervisor
MAINTAINER Johannes Jaeger <kontakt@johannesjaeger.com>

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
# Install Python
RUN curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
ENV PATH $HOME/.pyenv/bin:${PATH}
RUN eval "$(~/.pyenv/bin/pyenv init -)"
RUN eval "$(~/.pyenv/bin/pyenv virtualenv-init -)"
RUN pip install virtualenv

# ------------------------------------------------------------------------------
# Install Ruby
RUN sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | sudo bash -s stable
#RUN echo 'source ~/.rvm/scripts/rvm' | bash -l
RUN /usr/local/rvm/bin/rvm install 2.2.1
RUN /usr/local/rvm/bin/rvm use 2.2.1 --default
RUN ruby -v
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN gem install bundler
#RUN gem install rails -v 4.2.0
ENV GEM_PATH /lib/ruby/gems

# ------------------------------------------------------------------------------
# Install Cloud9SDK
RUN git clone https://github.com/c9/core/ /c9sdk
WORKDIR /c9sdk
RUN scripts/install-sdk.sh

# ------------------------------------------------------------------------------
# Install Docker in Docker (dind)
RUN curl -L https://rawgit.com/rvmn/cloud9core-docker/master/dind && chmod +x ./dind
RUN mv ./dind /usr/local/bin/

# ------------------------------------------------------------------------------
# Install Docker aliases
RUN curl -fsSL https://rawgit.com/rvmn/cloud9core-docker/master/docker-aliases >> ~/.bashrc && source ~/.bashrc

# ------------------------------------------------------------------------------
# Add supervisord conf
ADD conf/c9.conf /etc/supervisor/conf.d/

# ------------------------------------------------------------------------------
# Add volumes
RUN mkdir /workspace
VOLUME /workspace

# ------------------------------------------------------------------------------
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ------------------------------------------------------------------------------
# Expose ports.
EXPOSE 8181

# ------------------------------------------------------------------------------
# Start supervisor, define default command.
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
