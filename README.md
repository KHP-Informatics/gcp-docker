# mimir-docker

Build the data container:

docker build -t cassj/mimir-data --file=Dockerfile.dataContainer  .

Build the mimir server container

docker build -t cassj/mimir .

Start the data container (this will then exit, but that's fine, because the volume will persist)

MIMIRDATA=$(docker run -d cassj/mimir-data)

Start the mimir container

MIMIR=$(docker run -d --volumes-from $MIMIRDATA -p 8080:8080 cassj/mimir)

For anything more than a test instance, you probably want to increase the amount of 
memory available to Java, so you can run with

MIMIR=$(docker run -d -e JAVA_OPTS='-Xmx20G' --volumes-from $MIMIRDATA -p 8080:8080 cassj/mimir)

Make sure you configure mimir to put its indices in the volume from the container, which is 
mounted at: /home/mimir/data

You should now be able to access your mimir instance at <dockerhost>:8080/mimir-cloud

If you want to look at your index data, you can just run another container mounting the same volume:

docker run --rm -it --volumes-from $MIMIRDATA ubuntu /bin/bash
ls /home/mimir/data

If you want to see the output from the grails app:

docker logs $MIMIR

