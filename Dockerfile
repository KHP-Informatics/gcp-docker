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

# Create a user and roup with a specified U/GID. 
# You should also create this group on the host and add any users who will be using this container.
RUN groupadd -g67890 khresmoi 
RUN useradd -u67890 -g khresmoi -ms /bin/bash gcp

# Create a mountpoint for the host volume
RUN mkdir /gcpdata 
RUN chown gcp:khresmoi /gcpdata
VOLUME /gcpdata
RUN chmod g+ws /gcpdata

# Install GCP&GATE to /opt/gcp
RUN mkdir /opt/gcp
WORKDIR '/opt/gcp'

ENV JAVA_TOOL_OPTIONS '-Dfile.encoding=UTF8'

# having problems with the svn trunk and gate 8. Requires 8.1, with which the khresmoi pipeline doesn't work. 
ADD gcp-dist-2.5-SNAPSHOT.zip /opt/gcp/
RUN cd /opt/gcp && unzip gcp-dist-2.5-SNAPSHOT.zip
ENV GCP_HOME '/opt/gcp/gcp-2.5-SNAPSHOT'

# Looks like we're going to have to try gate 8. 8.1 causes problems for Format_FastInfoSet plugin.
RUN curl -L 'http://ufpr.dl.sourceforge.net/project/gate/gate/8.0/gate-8.0-build4825-ALL.zip' > gate-8.0-build4825-ALL.zip && unzip gate-8.0-build4825-ALL.zip && mv gate-8.0-build4825-ALL gate && rm gate-8.0-build4825-ALL.zip

ENV GATE_HOME '/opt/gcp/gate'

ENV PATH "$PATH:$GCP_HOME:$GATE_HOME/bin"

# bit of a fudge so we can add extra jars to /gcpdata/lib if necessary (eg. I need the jdbc sqlserver driver)
ENV CLASSPATH /gcpdata/lib/*
RUN perl -i -pe 's/-cp\ \./-cp\ "\$CLASSPATH":\./' /opt/gcp/gcp-2.5-SNAPSHOT/gcp-direct.sh 

# Set the user so we don't run as root
USER gcp
ENV HOME /home/gcp
WORKDIR /home/gcp

ENTRYPOINT ["gcp-direct.sh"]


