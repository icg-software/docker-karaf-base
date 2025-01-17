FROM almalinux:9.1-minimal

LABEL maintainer="icgsoftware <j_liepe@icg-software.de>"

# LANG


ARG SYSTEM_LANG="de"
ARG SYSTEM_LOCALE="DE"
ARG SYSTEM_CHARSET="UTF-8"

# USER ID

ENV KARAF_USER_ID=1777
ENV KARAF_GROUP_ID=1777

# FOLDERS

ENV KARAF_HOME=/opt/karaf
ENV KARAF_BASE=/opt/karaf
ENV HOME=/opt/karaf

# JAVA

ENV JAVA_HOME=/etc/alternatives/jre_11_openjdk
ENV JRE_HOME=/etc/alternatives/jre_11_openjdk
ENV JAVA_OPTS=
ENV FETCH_CUSTOM_URL=NONE
ENV KARAF_INIT_COMMANDS=NONE

# LANG

ENV LANG=${SYSTEM_LANG}_${SYSTEM_LOCALE}.${SYSTEM_CHARSET}
ENV LANGUAGE=${SYSTEM_LANG}_${SYSTEM_LOCALE}:${SYSTEM_LANG}
ENV LC_ALL=${SYSTEM_LANG}_${SYSTEM_LOCALE}.${SYSTEM_CHARSET}

# LANG

ENV CLEAN_CACHE=false
ENV LINK_VOL_DEPLOY=true
ENV LINK_VOL_LOG=true
ENV LINK_VOL_MSG_BROKER=true
ENV LINK_VOL_TMP=true

# INIT USER

ENV INIT_SCRIPT_USER=karaf
ENV INIT_SCRIPT_PWD=karaf

# COPY SCRIPTS

ADD ./entrypoint.sh /entrypoint.sh
ADD ./initkaraf /opt/karaf/bin/initkaraf
ADD ./varinitrunner /opt/karaf/bin/varinitrunner
ADD ./fileinitrunner /opt/karaf/bin/fileinitrunner
ADD ./checkvoletc /opt/karaf/bin/checkvoletc
ADD ./touchvoletc /opt/karaf/bin/touchvoletc
ADD ./volumelinker /opt/karaf/bin/volumelinker
ADD ./build.commands /tmp/build.commands
ADD ./installer.sh /tmp/installer.sh

# RUN INIT

RUN \
    microdnf install -y langpacks-${SYSTEM_LANG} && \
    microdnf upgrade -y && \
    microdnf install -y wget curl-minimal tar zip unzip vim sudo && \
    microdnf install -y java-11-openjdk && \
    groupadd -r karaf -g ${KARAF_GROUP_ID} && \
    useradd -u ${KARAF_USER_ID} -r -g karaf -m -d /opt/karaf -s /sbin/nologin -c "Karaf user" karaf && \
    mkdir /opt/karaf/vol && \
    chmod 755 /opt/karaf && \
    chown -R karaf.karaf /opt/karaf && \
    chmod u+x /opt/karaf/bin/* && \
    chown karaf.karaf /tmp/build.commands && \
    chown karaf.karaf /tmp/installer.sh && \
    chmod u+x /tmp/installer.sh && \
    chown karaf.karaf /entrypoint.sh && \
    chmod u+x /entrypoint.sh && \
    microdnf clean all && \
    rm -rf /var/cache/dnf
    

# KARAF VOL

VOLUME ["/opt/karaf/vol"]

# USER

USER karaf

# START

ENTRYPOINT ["/entrypoint.sh"]

# Define default command.
CMD ["/opt/karaf/bin/karaf", "run"]


