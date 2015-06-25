# This file intended to be sourced first
# . /build/config.sh

# Prevent initramfs updates from trying to run grub and lilo.
export INITRD=no
export DEBIAN_FRONTEND=noninteractive

minimal_apt_get_args='-y --no-install-recommends'

ADD_REPO="ppa:webupd8team/java"

PRE_RUN="echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections &&\
sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade"
  
POST_RUN="curl https://install.meteor.com/ | sh &&\
gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3 &&\
curl -L get.rvm.io | bash -s stable &&\
source /etc/profile.d/rvm.sh &&\
rvm requirements &&\
rvm install ruby &&\
rvm use ruby --default &&\
rvm rubygems current &&\
echo 'gem: --no-ri --no-rdoc' > ~/.gemrc &&\
gem install bundler --no-ri --no-rdoc  &&\
ruby -e '$(curl -fsSL https://raw.github.com/nitrous-io/autoparts/master/setup.rb)' &&\
curl -sSL https://get.docker.com/ubuntu/ | sh &&\
sed -i -e 's_127.0.0.1_0.0.0.0_g' /cloud9/configs/standalone.js &&\
chmod +x /root/dockeraliases && cat /root/dockeraliases >> ~/.bashrc &&\
source ~/.bashrc"

## Build time dependencies ##
BUILD_PACKAGES="build-essential g++ curl libssl-dev apache2-utils git libxml2-dev sshfs wget nano patch gawk gcc make libc6-dev patch libreadline6-dev zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake libtool bison pkg-config libffi-dev"

## Run time dependencies ##
RUN_PACKAGES="ruby ruby-dev ruby-bundler nodejs oracle-java8-installer maven lxde-core lxterminal tightvncserver"
