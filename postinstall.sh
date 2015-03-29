#!/usr/bin/env bash
echo "Installing Ruby and Rails"
sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable --ruby=2.2.0 --rails
export PATH=/usr/local/rvm/rubies/ruby-2.2.0/bin:${PATH}
export PATH=/usr/local/rvm/bin:${PATH}
export GEM_PATH=~/./usr/local/rvm/rubies/ruby-2.2.0/bin:${PATH}
export GEM_HOME=~/./usr/local/rvm/rubies/ruby-2.2.0/lib/ruby/gems:${PATH}                      
echo "Installed Ruby and Rails"
echo "Installing Autoparts"
ruby -e "$(curl -fsSL https://raw.github.com/nitrous-io/autoparts/master/setup.rb)"
export PATH=~/.parts:${PATH}
echo "Installed Autoparts; usage with:\ 
parts list # list al packages \
parts install meteor # install meteor"
