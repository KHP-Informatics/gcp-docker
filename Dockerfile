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
RUN curl -L 'http://downloads.sourceforge.net/project/gate/gcp/gcp-dist-2.5.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fgate%2Ffiles%2Fgcp%2F&ts=1434706552&use_mirror=heanet' > gcp-dist-2.5.zip && unzip gcp-dist-2.5.zip
ENV GCP_HOME '/opt/gcp/gcp-2.5'

#RUN svn co http://svn.code.sf.net/p/gate/code/gcp/trunk gcp-src
## there's an issue with one of the maven central checksums. Temporarily turn off checking. 
## Remove this when issue is resolved...
#RUN sed -i '/<ivysettings>/a \ \ <property name="ivy.checksums" value="" \/>' gcp-src/build/ivysettings.xml
#RUN cd gcp-src && ant distro
#
#ENV GCP_HOME '/opt/gcp/gcp-src'

# Looks like we're going to have to try gate 8. 8.1 causes problems for Format_FastInfoSet plugin.
#RUN curl -L 'http://downloads.sourceforge.net/project/gate/gate/8.1/gate-8.1-build5169-ALL.zip?r=&ts=1433933712&use_mirror=kent' >  gate-8.1-build5169-ALL.zip && unzip gate-8.1-build5169-ALL.zip && mv gate-8.1-build5169-ALL gate && rm gate-8.1-build5169-ALL.zip
RUN curl -L 'http://downloads.sourceforge.net/project/gate/gate/8.0/gate-8.0-build4825-ALL.zip?r=&ts=1434579935&use_mirror=heanet' > gate-8.0-build4825-ALL.zip && unzip gate-8.0-build4825-ALL.zip && mv gate-8.0-build4825-ALL gate && rm gate-8.0-build4825-ALL.zip

ENV GATE_HOME '/opt/gcp/gate'

# Expect the data to be in /gcpdata
# default heap size is 12G change with -m option
# -t number of threads to use. 

ENV PATH "$PATH:/opt/gcp/gcp-src:/opt/gcp/gate/bin"

ENTRYPOINT ["gcp-direct.sh"]


