FROM adoptopenjdk/openjdk12:alpine-slim

ENV HOME /home/netbeans

RUN adduser -D netbeans && \
    apk update && \
    apk upgrade && \
    apk add libxext libxtst libxrender libxi && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

RUN mkdir -m 700 /data && \
    mkdir -m 700 $HOME/.netbeans && \
    mkdir -m 700 $HOME/NetBeansProjects && \
    chown -R netbeans:netbeans /data $HOME/.netbeans $HOME/NetBeansProjects

VOLUME /data
VOLUME ~/.netbeans
VOLUME ~/NetBeansProjects

ENV NETBEANS_URL=https://synapse.internet-portal.cz/downloads/netbeans-8.2-php-linux-x64.sh
ENV NB_TEMP=/tmp/netbeans-install
RUN wget $NETBEANS_URL -O /tmp/netbeans.sh \
        && echo "Installing NetBeans..." \
        && chmod +x /tmp/netbeans.sh; sleep 1 \
        && /tmp/netbeans.sh --tempdir $NB_TEMP --nospacecheck --silent \
        && rm -rf /tmp/* \
        && ln -s $(ls -d /usr/local/netbeans-*) /usr/local/netbeans

USER netbeans

WORKDIR /data
CMD /usr/local/netbeans/bin/netbeans
