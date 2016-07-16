FROM ubuntu:14.04

# geometry => resolution
ENV GEOMETRY 1300x800

ENV USER logic
ENV DISPLAY :1
RUN apt-get update -y

RUN apt-get install -y --no-install-recommends \
  xfonts-75dpi \
  xfonts-100dpi \
  autocutsel \
  ubuntu-wallpapers \
  xli \
  xfonts-base \
  blackbox \
  xterm

RUN apt-get install -y tightvncserver

# logic dependencies
RUN apt-get -y install libglib2.0-0 pciutils unzip

WORKDIR /packages


# install logic
COPY "packages/Logic_1.2.10_(64-bit).zip" ./
RUN unzip "Logic_1.2.10_(64-bit).zip" && \
  mkdir /home/logic && \
  cp -R "Logic 1.2.10 (64-bit)" /home/logic/Logic

WORKDIR /home/logic

# cleaing up
RUN rm -rf /packages
RUN apt-get autoclean -y

RUN adduser logic
RUN chown -R logic:logic /home/logic

# configure vnc and blackbox wm
COPY password.txt /home/logic/
COPY config/blackboxrc /home/logic/.blackboxrc
COPY config/startWM.sh /home/logic/
COPY config/start.sh /home/logic/
COPY config/blackbox-menu /etc/X11/blackbox/

USER logic
RUN mkdir -p ~/.vnc
RUN cat /home/logic/password.txt | vncpasswd -f > ~/.vnc/passwd
RUN chmod 700 ~/.vnc ~/.vnc/passwd

USER root
RUN rm /home/logic/password.txt

VOLUME /home/logic
EXPOSE 5901

USER root
CMD /home/logic/start.sh
