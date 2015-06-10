# gcp-docker

Build the gcp container

docker build -t cassj/gcp .


When you run the container, mount a directory on the host that contains your config & data. You may wish to increase available java memory etc.

#run from teh cmdline to test
docker run --rm -it -v /path/to/gcpdata:/gcpdata  -e 'JAVA_OPTS=-Xmx8G' --entrypoint=/bin/bash cassj/gcp 



#java -jar gcp-cli.jar [optionalArguments] -d workingDir

