FROM ubuntu:16.04
RUN apt-get update 
RUN apt-get install apt-utils tar sudo wget unzip curl lsof maven openjdk-8-jdk openjdk-8-jre git make automake autoconf libtool  patch libx11-dev libxt-dev pkg-config texinfo locales-all ant hostname -y
RUN java -version
# RUN unset JAVA_TOOL_OPTIONS
ENV LANG="en_US.UTF-8"
ENV JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF8"
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64      
ENV PATH=$JAVA_HOME/bin:$PATH
ENV _JAVA_OPTIONS="-Xss1g -Xmx10g"                     
ENV ANT_HOME=/usr/share/ant/
ENV PATH=$ANT_HOME/bin:$PATH
RUN echo $PATH
RUN mkdir /opt/gradle
ADD https://github.com/elastic/elasticsearch/archive/v6.0.0.zip /root/
ADD https://services.gradle.org/distributions/gradle-3.3-bin.zip /opt/gradle
RUN unzip -d /root /root/v6.0.0.zip 
RUN unzip -d /opt/gradle /opt/gradle/gradle-3.3-bin 
ENV PATH=$PATH:/opt/gradle/gradle-3.3/bin
RUN gradle -v
RUN cd /root && git clone https://github.com/java-native-access/jna.git && cd jna && ant
RUN cd /root/elasticsearch-6.0.0 && gradle assemble --no-daemon
RUN pwd
RUN tar -C /usr/share/ -xf  /root/elasticsearch-6.0.0/distribution/tar/build/distributions/elasticsearch-6.0.0-SNAPSHOT.tar.gz
RUN mv /usr/share/elasticsearch-6.0.0-SNAPSHOT /usr/share/elasticsearch
RUN useradd -ms /bin/bash mark43
RUN chown mark43:mark43 -R /usr/share/elasticsearch
USER mark43
RUN /usr/share/elasticsearch/bin/elasticsearch --version
#WORKDIR /home/mark43
#RUN ls -al
RUN /usr/share/elasticsearch/bin/elasticsearch
EXPOSE 9200

