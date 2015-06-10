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

ENV GCP_HOME '/home/gcp/gcp-src'

RUN curl -L 'http://downloads.sourceforge.net/project/gate/gate/8.1/gate-8.1-build5169-ALL.zip?r=&ts=1433933712&use_mirror=kent' >  gate-8.1-build5169-ALL.zip && unzip gate-8.1-build5169-ALL.zip && mv gate-8.1-build5169-ALL gate && rm gate-8.1-build5169-ALL.zip

ENV GATE_HOME '/home/gcp/gate'

RUN mkdir /gcpdata ; chown -R gcp:gcp /gcpdata
VOLUME /gcpdata

# Expect the data to be in /gcpdata
# default heap size is 12G change with -m option
# -t number of threads to use. 

#java -jar gcp-cli.jar  -d /gcpdata

ENV PATH "$PATH:/home/gcp/gcp-src:/home/gcp/gate/bin"


ENTRYPOINT ["gcp-direct.sh", "-b", "/gcpdata"]
CMD ['']


