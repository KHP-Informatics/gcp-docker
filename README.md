# gcp-docker

Build the gcp container

docker build -t cassj/gcp .

I can't quite work out how docker expects you to handle permissions on host directories shared as volumes
on your container. As far as I can tell, either the container process has to run as root or the data directory
has to be writeable by everyone (assuming your container wants to write to it). I've gone with the latter option, so something like:

   mkdir /tmp/gcpdata

put your config files etc in /tmp/gcpdata

run something like:
 
  docker run --rm -it -v /tmp/gcpdata:/gcpdata  -e 'JAVA_OPTS=-Xmx8G' cassj/gcp 



#java -jar gcp-cli.jar [optionalArguments] -d workingDir

