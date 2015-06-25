
# Pull base image.
FROM kdelfour/supervisor-docker
MAINTAINER Roberto van Maanen <roberto.vanmaanen@gmail.com>

# Copy + Add files
COPY *.sh /build/
ADD ./wrapdocker /usr/local/bin/wrapdocker
ADD supervisord.conf /etc/supervisor/conf.d/
ADD dockeraliases /root/
ADD https://get.docker.io/builds/Linux/x86_64/docker-latest /usr/local/bin/docker

# Run installations
RUN chmod +x /build/build.sh && \
    chmod +x /build/run.sh && \
    chmod +x /build/cleanup.sh
RUN /build/build.sh && \
    /build/run.sh && \
    /build/cleanup.sh && rm -rf /build
# Set shared directories
RUN mkdir /workspace
VOLUME /workspace

# Open ports
 # Cloud9
EXPOSE 8181
 # VNC
EXPOSE 5901
 # extra ports
EXPOSE 3000
EXPOSE 4000
EXPOSE 5000

# Start supervisor, define default command.
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]

