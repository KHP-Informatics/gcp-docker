# gcp-docker

Build the gcp container

docker build -t cassj/gcp .

My goal with this container was to encapsulate everything you need to run the Kheresmoi pipline (a GCP application), 
so you don't need to worry about installing the right versions of GATE and GCP.

You should be able to point this container at a host directory containing data and configuration and have it process 
your data.

Step one is to identify (or create) the directory on the host you wish to use:

   mkdir /tmp/gcpdata

This location will be bind-mounted into your container as a volume, so if you have selinux enforcing on the host, you need to:

   chcon -Rt svirt_sandbox_file_t /tmp/gcpdata

There doesn't seem to be a particularly satisfactory way of handling permissions between host and container with docker at the moment. 
This may be resolved when docker supports user namespaces, but in the meantime we have a problem: 
Both the user running GCP in the container, and the user on the host with data to be processed, need to be able to read and write to 
the bind mounted volume. Assuming we don't want either the container or the user with data to have root access, then the directory 
has to be world writable or they both have to be in the same group. I don't really want the data directory to be world writable, so 
I've assumed in the container that the user is in a group with GID 67890. 

You will need to create this group on your host and add any users who want to use the container to it.

  sudo groupadd -g67890 khresmoi

And ensure that group owns the data directory:

  chgrp khresmoi /tmp/gcpdata 
  chmod g+s /tmp/gcpdata 
 

You can now put your GCP configuration files and application in that directory and run something like:
 
  docker run --rm -it -v /tmp/gcpdata:/gcpdata  -e 'JAVA_OPTS=-Xmx8G' cassj/gcp 



If you want to use the container to run gate developer to mess with the application, then you need X11. 
The easiest way to get this working is to bind mount your Xauth file and DISPLAY env var to your container, something like:

docker run --rm -it -v /gcpdata:/gcpdata  -v /tmp/.X11-unix:/tmp/.X11-unix   -e DISPLAY=$DISPLAY -v $HOME/.Xauthority:/root/.Xauthority --net=host -e 'JAVA_OPTS=-Xmx8G' --entrypoint=/bin/bash cassj/gcp


#java -jar gcp-cli.jar [optionalArguments] -d workingDir

