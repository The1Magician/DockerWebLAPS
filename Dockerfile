#Based on https://weblaps.readthedocs.io/en/latest/install_unix.html 

FROM alpine:latest

#install openjdk8
RUN apk add --no-cache openjdk8

#install bash for install script
RUN apk add --no-cache --upgrade bash

RUN apk --no-cache add curl

#Create LAPS user
RUN adduser --disabled-password --no-create-home --shell SHELL laps

#Download and extract webLAPS
RUN mkdir temp && \
cd temp && \
curl -O https://weblaps.pro/distr/LAPS_2.1.8.1.zip && \
unzip LAPS_2.1.8.1.zip -d /opt/ && \
mkdir /opt/LAPS/logs && \
mkdir /opt/LAPS/keystore && \
rm -rf temp

#Set Permissions
RUN chown laps:laps /opt/LAPS -R && \
chmod u=rx,g=rx,o-rwx /opt/LAPS -R && \
chmod u+w /opt/LAPS/wrapper/tmp && \
chmod u+w /opt/LAPS/logs && \
chmod u+w /opt/LAPS/conf && \
chmod u+w /opt/LAPS/keystore

#Run install script
RUN /opt/LAPS/wrapper/bin/installDaemon.sh && \
systemctl daemon-reload

RUN service laps start

EXPOSE 8443
