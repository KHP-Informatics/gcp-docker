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
RUN svn co http://svn.code.sf.net/p/gate/code/gcp/trunk gcp-src

# there's an issue with one of the maven central checksums. Temporarily turn off checking. 
# Remove this when issue is resolved...
RUN sed -i '/<ivysettings>/a \ \ <property name="ivy.checksums" value="" \/>' gcp-src/build/ivysettings.xml
RUN cd gcp-src && ant distro

ENV GCP_HOME '/opt/gcp/gcp-src'

RUN curl -L 'http://downloads.sourceforge.net/project/gate/gate/8.1/gate-8.1-build5169-ALL.zip?r=&ts=1433933712&use_mirror=kent' >  gate-8.1-build5169-ALL.zip && unzip gate-8.1-build5169-ALL.zip && mv gate-8.1-build5169-ALL gate && rm gate-8.1-build5169-ALL.zip

ENV GATE_HOME '/opt/gcp/gate'

# Expect the data to be in /gcpdata
# default heap size is 12G change with -m option
# -t number of threads to use. 

ENV PATH "$PATH:/opt/gcp/gcp-src:/opt/gcp/gate/bin"

ENTRYPOINT ["gcp-direct.sh"]


