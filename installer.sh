#!/bin/bash

tar --strip-components=1 -C ${1}
touch /opt/karaf/firstboot
if [ ! -d "/opt/karaf/vol" ]
then
   mkdir /opt/karaf/vol
fi


env JAVA_OPTS="-Xmx2g" /opt/karaf/bin/karaf run &
sleep 108
/opt/karaf/bin/client -r 93  "shell:sleep 1;"
sleep 33
/opt/karaf/bin/client -r 3  -l 2 -b < /tmp/build.commands
/opt/karaf/bin/client -r 3  -l 2 -u karaf -p karaf "shutdown -f;"
sleep 33

rm /tmp/build.commands
rm /opt/karaf/etc/host.key
rm /opt/karaf/etc/host.key.pub
tar --directory /opt/karaf/etc -czvf /opt/karaf/etc_original.tgz .

rm ${0}
rm ${1}
