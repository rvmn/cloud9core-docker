# Cloud9/core IDE container for Docker (with preinstalled NodeJS/Ruby/Python/Java)
# WIP:  NOT WORKING ATM!!! 
# PLS USE https://github.com/rvmn/docker-dev-cloud9
This is an attempt at an integration of a cleaning system that removes (absolutely) all install files, for optimizing used image size, but not working yet
=============
## Get and install

    wget https://raw.githubusercontent.com/rvmn/cloud9core-docker/master/install.sh && chmod +x install.sh && ./install.sh

## Run

    dcrun

## 
## Open Cloud9 IDE (assuming local, else IP)

    localhost:8181
    
## Using Docker shortcuts (BASH aliases)

    dhelp # 'dhelp' shows list of all aliases
    dalias # 'dalias' adds an alias, first-arg=name second-arg="commandstring".
    ralias # rename an alias, can also rename itself ;)
    
## Install Rails (from within Cloud9 IDE)
    
    gem install rails

=======
# cloud9core-docker
Cloud9/core IDE for Docker (with Docker-in-Docker)
