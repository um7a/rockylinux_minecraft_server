FROM rockylinux/rockylinux:9.3

RUN \
dnf update -y; \
dnf install -y java-21-openjdk

RUN \
mkdir -p /opt/minecraft/

COPY files/opt/minecraft/minecraft_server.1.21.jar /opt/minecraft/
COPY files/opt/minecraft/run/eula.txt              /opt/minecraft/run/
COPY files/opt/minecraft/run/server.properties     /opt/minecraft/run/

WORKDIR /opt/minecraft/run/
CMD ["java", "-Xmx1024M", "-Xms1024M", "-jar", "../minecraft_server.1.21.jar", "nogui"]