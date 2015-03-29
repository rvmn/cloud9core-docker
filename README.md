# Cloud9/core SDK for Docker (with Docker-in-Docker and preinstalled NodeJS/Ruby/Python/Java)
=============
## Get and build

    docker build -t="cloud9" github.com/rvmn/cloud9core-docker
        OR BETTER (using caching for building the image):
    git clone https://github.com/rvmn/cloud9core-docker cloud9 && cd cloud9 && docker build -t cloud9 .
    
## Run

    docker run -it -d -p 8181:8181 cloud9

## Run with Acccessible Workspace

    mkdir ~/workspace
    docker run -it -d -p 8181:8181 -v ${PWD}/workspace:/workspace/ cloud9

## Open Cloud9 IDE (assuming local, else IP)

    localhost:8181
    
## Install Docker shortcuts (BASH aliases)

    curl -fsSL https://raw.githubusercontent.com/rvmn/cloud9core-docker/master/docker-aliases >> ~/.bashrc && source ~/.bashrc
    dhelp # 'dhelp' shows list of all aliases, learn to use dprm (remove unused containers) and drmi (same for images)
    dalias hello 'echo "world"' # 'dalias' adds an alias, first-arg=name second-arg="commandstring". type 'hello' :D
    ralias dhelp help # rename an alias, can also rename itself ;)
    
## Install Rails (from within Cloud9 IDE)
    
    gem install rails

=======
# c9core-docker
Cloud9/core SDK for Docker (with Docker-in-Docker)
