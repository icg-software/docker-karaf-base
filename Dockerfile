FROM almalinux:minimal

LABEL maintainer="icgsoftware <j_liepe@icg-software.de>"

ENV KARAF_HOME=/opt/karaf
ENV KARAF_BASE=/opt/karaf
ENV HOME=/opt/karaf
ENV JAVA_HOME=/etc/alternatives/jre_11_openjdk
ENV JRE_HOME=/etc/alternatives/jre_11_openjdk
ENV JAVA_OPTS=
ENV FETCH_CUSTOM_URL=NONE
ENV KARAF_INIT_COMMANDS=NONE
ENV LANG=de_DE.UTF-8
ENV LANGUAGE=de_DE:de
ENV LC_ALL=de_DE.UTF-8
ENV CLEAN_CACHE=false
ENV LINK_VOL_DEPLOY=true
ENV LINK_VOL_LOG=true
ENV LINK_VOL_MSG_BROKER=true
ENV LINK_VOL_TMP=true
ENV INIT_SCRIPT_USER=karaf
ENV INIT_SCRIPT_PWD=karaf

ADD ./entrypoint.sh /entrypoint.sh
ADD ./initkaraf /opt/karaf/bin/initkaraf
ADD ./varinitrunner /opt/karaf/bin/varinitrunner
ADD ./fileinitrunner /opt/karaf/bin/fileinitrunner
ADD ./checkvoletc /opt/karaf/bin/checkvoletc
ADD ./touchvoletc /opt/karaf/bin/touchvoletc
ADD ./volumelinker /opt/karaf/bin/volumelinker
ADD ./build.commands /tmp/build.commands
ADD ./installer.sh /tmp/installer.sh


RUN microdnf upgrade -y && \
    microdnf install -y wget curl zip unzip vim sudo && \
    microdnf install -y java-11-openjdk && \
    groupadd -r karaf -g 1777 && \
    useradd -u 1777 -r -g karaf -m -d /opt/karaf -s /sbin/nologin -c "Karaf user" karaf && \
    mkdir /opt/karaf/vol && \
    chmod 755 /opt/karaf && \
    chown -R karaf.karaf /opt/karaf && \
    chmod u+x /opt/karaf/bin/* && \
    chown karaf.karaf /tmp/installer.sh && \
    chown karaf.karaf /tmp/build.commands && \
    chmod u+x /tmp/installer.sh && \
    chmod u+x /entrypoint.sh && \
    microdnf clean all && \
    rm -rf /var/cache/dnf
    

VOLUME ["/opt/karaf/vol"]
ENTRYPOINT ["/entrypoint.sh"]

# Define default command.
CMD ["/opt/karaf/bin/karaf", "run"]


