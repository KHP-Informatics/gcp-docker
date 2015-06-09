# gcp-docker

Build the gcp container

docker build -t cassj/gcp .


When you run the container, mount a directory on the host that contains your config & data

java -jar gcp-cli.jar [optionalArguments] -d workingDir

