FROM petrzak79/docker-java

ENV STI_SCRIPTS_PATH=/usr/libexec/s2i \
	STI_SCRIPTS_URL=image:///usr/libexec/s2i

EXPOSE 8080

LABEL io.k8s.description="Platform for running executable JARs" \
      io.k8s.display-name="Java 8" \
	  io.openshift.s2i.scripts-url="/usr/libexec/s2i" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="java,java8"


RUN mkdir -p /opt/app-root && \
	chown -R 1001:0 /opt/app-root && \
	chmod +rx /opt/app-root && \

	mkdir -p ${STI_SCRIPTS_PATH} && \
	chown -R 1001:0 ${STI_SCRIPTS_PATH} && \
	chmod +rx ${STI_SCRIPTS_PATH} && \
	# Fake commands to do nothing
	echo "#!/bin/sh" > /sbin/apk && \
	echo "#!/bin/sh" > /usr/bin/curl && \
	echo "#!/bin/sh" > /usr/bin/rm && \
	chmod +rx /usr/bin/curl && \
	echo "fake apk" > /tmp/fake.apk && \
	chown 1001:0 /tmp/fake.apk && \
	chmod u+wrx,g+wrx,o+wrx /tmp/fake.apk 

COPY ./s2i/bin/ ${STI_SCRIPTS_PATH}
RUN chmod +rx ${STI_SCRIPTS_PATH}/*

USER 1001
