# start from a base ubuntu image
FROM ubuntu
MAINTAINER Cass Johnston <cassjohnston@gmail.com>

#######
# Setup a user for this process
#######
RUN groupadd -r gcp 
RUN useradd -ms /bin/bash -g gcp gcp

########
# Pre-reqs
########

RUN apt-get update \ 
    && apt-get install -y \
    ant \
    curl \
    openjdk-7-jdk \
    subversion \
    unzip \
    vim 


ENV JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk-amd64


#######
# GCP
#######

USER gcp
ENV HOME /home/gcp

RUN cd /home/gcp && svn ck http://svn.code.sf.net/p/gate/code/gcp/trunk
#RUN ant distro


WORKDIR '/home/gcp'
#ENTRYPOINT ["grails", "prod", "run-app"]
