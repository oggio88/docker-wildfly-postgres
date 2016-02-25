FROM base/archlinux
MAINTAINER Oggioni Walter <oggioni.walter@gmail.com>

#RUN pacman -Sy archlinux-keyring --noconfirm
#RUN pacman -Su --noconfirm
#RUN pacman-db-upgrade
# Basic Requirements
RUN pacman -Sy postgresql openssl supervisor --noconfirm
RUN pacman -S --noconfirm ca-certificates-utils  desktop-file-utils  fixesproto  hicolor-icon-theme  inputproto  kbproto  libice  libsm  libtasn1  libx11  libxau  libxcb  libxdmcp  libxext  libxfixes  libxi  libxmu  libxrender  libxslt  libxt  libxtst  p11-kit  recordproto  renderproto  shared-mime-info  xcb-proto  xdg-utils  xextproto  xorg-xset  xproto
COPY pkgs/jdk-8u74-1-x86_64.pkg.tar.xz /root/
COPY pkgs/wildfly-10.0.0.Final-1-any.pkg.tar.xz /root/
COPY pkgs/java-runtime-common-2-2-any.pkg.tar.xz /root/
COPY pkgs/java-environment-common-2-2-any.pkg.tar.xz /root/
RUN pacman -U /root/*.pkg.tar.xz --noconfirm
RUN rm /root/*.pkg.tar.xz
RUN pacman -Scc --noconfirm

COPY standalone.xml /opt/wildfly/standalone/configuration/standalone.xml
RUN chown wildfly:wildfly /opt/wildfly/standalone/configuration/standalone.xml
RUN locale-gen
RUN echo 0 > /root/booted.txt

# private expose
EXPOSE 5432
EXPOSE 8080
EXPOSE 8787
EXPOSE 9990

# volume for postgres database and wordpress install
VOLUME ["/var/lib/postgres/data"]

# Supervisor Config
ADD ./supervisord.conf /etc/supervisord.conf

# Postgres Initialization and Startup Script
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

CMD ["/bin/bash", "/start.sh"]

