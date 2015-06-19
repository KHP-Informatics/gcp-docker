# start from a base ubuntu image
FROM ubuntu
MAINTAINER Cass Johnston <cassjohnston@gmail.com>

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

RUN mkdir /gcpdata 
VOLUME /gcpdata

RUN mkdir /opt/gcp
WORKDIR '/opt/gcp'

ENV JAVA_TOOL_OPTIONS '-Dfile.encoding=UTF8'

# having problems with the svn trunk and gate 8. Requires 8.1, with which the khresmoi pipeline doesn't work. 
ADD gcp-dist-2.5-SNAPSHOT.zip /opt/gcp/
RUN cd /opt/gcp && unzip gcp-dist-2.5-SNAPSHOT.zip
ENV GCP_HOME '/opt/gcp/gcp-2.5-SNAPSHOT'

# Looks like we're going to have to try gate 8. 8.1 causes problems for Format_FastInfoSet plugin.
RUN curl -L 'http://downloads.sourceforge.net/project/gate/gate/8.0/gate-8.0-build4825-ALL.zip?r=&ts=1434579935&use_mirror=heanet' > gate-8.0-build4825-ALL.zip && unzip gate-8.0-build4825-ALL.zip && mv gate-8.0-build4825-ALL gate && rm gate-8.0-build4825-ALL.zip

ENV GATE_HOME '/opt/gcp/gate'

# Expect the data to be in /gcpdata
# default heap size is 12G change with -m option
# -t number of threads to use. 

ENV PATH "$PATH:$GCP_HOME:$GATE_HOME/bin"

# bit of a fudge so we can add extra jars to /gcpdata/lib if necessary (eg. I need the jdbc sqlserver driver)
ENV CLASSPATH /gcpdata/lib/*
RUN perl -i -pe 's/-cp\ \./-cp\ "\$CLASSPATH":\./' /opt/gcp/gcp-2.5-SNAPSHOT/gcp-direct.sh 

ENTRYPOINT ["gcp-direct.sh"]


