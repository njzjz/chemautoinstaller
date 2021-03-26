FROM ubuntu:20.04@sha256:64255397e256fd33d6c6ddbc371027093315f9822089a32b8eeb045d83bb91c4
RUN apt update && apt install wget bzip2 -y && apt clean -y
COPY "ChemAutoInstaller.sh" "/ChemAutoInstaller.sh"
RUN bash ChemAutoInstaller.sh -A
