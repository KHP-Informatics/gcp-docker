# gcp-docker

Build the gcp container

docker build -t cassj/gcp .


When you run the container, mount a directory on the host that contains your config & data. You may wish to increase available java memory etc.

docker run --rm -it -v /tmp/gcpdata:/gcpdata  -e 'JAVA_OPTS=-Xmx8G' cassj/gcp 



#java -jar gcp-cli.jar [optionalArguments] -d workingDir

