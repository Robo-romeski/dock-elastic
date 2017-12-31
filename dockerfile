FROM ubuntu:16.04 
RUN apt-get update && apt-get install -y \
    apt-utils automake autoconf ant \
    git \ 
    hostname \
    libx11-dev libxt-dev libtool locales-all \
    maven make \
    openjdk-8-jdk openjdk-8-jre \
    pkg-config patch \
    texinfo tar \
    wget \ 
    unzip
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64      
ENV PATH=$JAVA_HOME/bin:$PATH                    
ENV ANT_HOME=/usr/share/ant/
ENV PATH=$ANT_HOME/bin:$PATH
ENV PATH=$PATH:/usr/share/elasticsearch/bin
RUN mkdir /opt/gradle
ADD https://github.com/elastic/elasticsearch/archive/v6.0.0.zip /root/
ADD https://services.gradle.org/distributions/gradle-3.3-bin.zip /opt/gradle
RUN unzip -d /root /root/v6.0.0.zip 
RUN unzip -d /opt/gradle /opt/gradle/gradle-3.3-bin 
ENV PATH=$PATH:/opt/gradle/gradle-3.3/bin
RUN cd /root/elasticsearch-6.0.0 && gradle assemble --no-daemon
RUN tar -C /usr/share/ -xf  /root/elasticsearch-6.0.0/distribution/tar/build/distributions/elasticsearch-6.0.0-SNAPSHOT.tar.gz
RUN mv /usr/share/elasticsearch-6.0.0-SNAPSHOT /usr/share/elasticsearch
COPY logging.yml /usr/share/elasticsearch/config/
COPY elasticsearch.yml /usr/share/elasticsearch/config/
RUN useradd -ms /bin/bash mark43
RUN chown mark43:mark43 -R /usr/share/elasticsearch
USER mark43
CMD [ "elasticsearch" ]
EXPOSE 9300 9200

