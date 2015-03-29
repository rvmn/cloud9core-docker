#c9/core cloud9 SDK dockerfile
=============
## Get and build

    docker build -t="cloud9core-docker" github.com/rvmn/cloud9core-docker
    
## Run

    docker run -it -d -p 8181:8181 cloud9core-docker

## Run with Acccessible Workspace

    mkdir ~/workspace
    docker run -it -d -p 8181:8181 -v ${PWD}/workspace:/workspace/ cloud9core-docker
    

=======
# c9core-docker
Cloud9/core SDK dockerfile
