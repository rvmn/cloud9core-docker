#c9/core cloud9 sdk 3.0
=============


Download automated build from public Docker Hub Registry: docker pull kdelfour/cloud9-docker
or:

(alternatively, you can build an image from Dockerfile: docker build -t="jjaeger/c9core-docker" github.com/soundyogi/c9core-docker  )

## Usage

    docker run -it -d -p 8181:8181 jjaeger/c9core-docker
    
You can add a workspace as a volume directory with the argument *-v /your-path/workspace/:/workspace/* like this :

    docker run -it -d -p 8181:8181 -v /your-path/workspace/:/workspace/ jjaeger/c9core-docker
    
## Build and run with custom config directory

Get the latest version from github

    git clone https://github.com/kdelfour/cloud9-docker
    cd cloud9-docker/

Build it

    sudo docker build --force-rm=true --tag="$USER/cloud9-docker:latest" .
    
And run

    sudo docker run -d -p 3131:3131 -v /your-path/workspace/:/workspace/ $USER/cloud9-docker:latest
    
Enjoy !!    
