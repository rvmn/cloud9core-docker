#!/bin/bash
rm -rf docker-dev-cloud9 && apt-get install -y git && git clone https://raw.githubusercontent.com/rvmn/cloud9core-docker && cd cloud9core-docker
echo "Use a MongoDB url [Y/n]:"
read conf
if [ "$conf" == "Y" ]; then
  echo "Enter the MongoDB url:"
  read mongo
  echo "ENV $mongo" >> Dockerfile
fi
echo "Use a username & pass for Cloud9 [Y/n]:"
read conf
if [ "$conf" == "Y" ]; then
  echo "Enter username:"
  read user
  echo "Enter password:"
  read pass
  echo "
[program:cloud9]
command = node /cloud9/server.js --listen 0.0.0.0 --port 8181 -w /workspace --auth $user:$pass
directory = /cloud9
user = root
autostart = true
autorestart = true
stdout_logfile = /var/log/supervisor/cloud9.log
stderr_logfile = /var/log/supervisor/cloud9_errors.log
environment = NODE_ENV='production'" >> supervisord.conf
else
  echo "
[program:cloud9]
command = node /cloud9/server.js --listen 0.0.0.0 --port 8181 -w /workspace 
directory = /cloud9
user = root
autostart = true
autorestart = true
stdout_logfile = /var/log/supervisor/cloud9.log
stderr_logfile = /var/log/supervisor/cloud9_errors.log
environment = NODE_ENV='production'" >> supervisord.conf
fi
echo "View Dockerfile now? [Y/n]"
read conf
if [ "$conf" == "Y" ]; then
cat <<EOF  
---------------------------------------------------------------------------------------------
					Dockerfile
---------------------------------------------------------------------------------------------
EOF
cat Dockerfile
cat <<EOF  
---------------------------------------------------------------------------------------------
      			 Check Dockerfile ^^^ and press ENTER
---------------------------------------------------------------------------------------------
EOF
read -t 15
fi

# add aliases to bashrc of host system
[ -z $( grep '# docker aliases' ~/.bashrc) ] && curl -fsSL https://raw.githubusercontent.com/rvmn/docker-dev-cloud9/master/docker-alias.sh >> ~/.bashrc && source ~/.bashrc
dalias dcset 'dalias dcrun "docker run --privileged -d -v $(pwd):/workspace -p 3000:3000 -p 4000:4000 -p 5000:5000 -p 8181:8181 -p 5901:5901 $1 cloud9"'
# build
docker build -t cloud9 .
# postinstall clean
cd .. && rm -rf cloud9core-docker
echo "Done!! Hopefully all went good, on init run `dcset [-p portnum:portnum]` to pass a run command with open ports into .bashrc, then start the server with 'dcrun'"
exit
