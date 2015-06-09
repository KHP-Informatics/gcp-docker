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

WORKDIR '/home/gcp'

ENV JAVA_TOOL_OPTIONS '-Dfile.encoding=UTF8'
RUN svn co http://svn.code.sf.net/p/gate/code/gcp/trunk gcp-src

# bugfix hack
RUN sed -i '/<\/dependencies>/i\ \ \ \ <dependency org="poi" name="poi" rev="2.5.1-final-20040804"\/>\n' gcp-src/build/ivy.xml
RUN cd gcp-src && ant distro

# Expect the data to be in /gcpdata
# default heap size is 12G change with -m option
# -t number of threads to use. 

#java -jar gcp-cli.jar  -d /gcpdata


#ENTRYPOINT ["grails", "prod", "run-app"]









