# ------------------------------------------------------------------------------
# Based on a work at https://github.com/docker/docker.
# ------------------------------------------------------------------------------
# Pull base image.
FROM dockerfile/supervisor
MAINTAINER rvmn <di_blabla@hotmail.com>

# ------------------------------------------------------------------------------
# Necessary settings
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN chsh -s /bin/bash root
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# ------------------------------------------------------------------------------
# Install base
RUN apt-get update
RUN apt-get install -y build-essential g++ curl libssl-dev apache2-utils git libxml2-dev default-jdk python-pip python-dev gcc make zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev
    
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
# Install Python (pyenv)
RUN curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
ENV PATH $HOME/.pyenv/bin:${PATH}
RUN eval "$(~/.pyenv/bin/pyenv init -)"
RUN eval "$(~/.pyenv/bin/pyenv virtualenv-init -)"
RUN pip install virtualenv

# ------------------------------------------------------------------------------
# Install Ruby (RVM)
RUN sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN ls -al /
RUN ls -al ~/
RUN ls -al ~/.scripts
RUN echo 'source ~/.rvm/scripts/rvm' | bash -l
#RUN curl -sSL https://get.rvm.io | sudo bash -s stable
#RUN /usr/local/rvm/bin/rvm install 2.2.1
#RUN /usr/local/rvm/bin/rvm use 2.2.1
RUN ruby -v
RUN echo "gem: --no-ri --no-rdoc" >> ~/.gemrc
RUN gem install bundler
ENV GEM_PATH /lib/ruby/gems

# ------------------------------------------------------------------------------
# Install Meteor (autoparts)
RUN ruby -e "$(curl -fsSL https://raw.github.com/nitrous-io/autoparts/master/setup.rb)"
RUN echo "alias parts='~/.parts/autoparts/bin/parts'" >> ~/.bashrc
RUN echo 'source ~/.bashrc' | bash -l
RUN ~/.parts/autoparts/bin/parts install meteor

# ------------------------------------------------------------------------------
# Install Cloud9SDK
RUN git clone https://github.com/c9/core/ /c9sdk
WORKDIR /c9sdk
RUN scripts/install-sdk.sh

# ------------------------------------------------------------------------------
# Install Docker in Docker (dind)
ADD dind /usr/local/bin/

# ------------------------------------------------------------------------------
# Install Docker aliases
ADD docker-aliases ~/
RUN ~/docker-aliases >> ~/.bashrc && source ~/.bashrc

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
