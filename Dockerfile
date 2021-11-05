FROM ubuntu:22.04@sha256:9e2424d0755c1261102df7b2603f5f88146b5be2ee20fed99003ff2181971e12
RUN apt update && apt install wget bzip2 -y && apt clean -y
COPY "ChemAutoInstaller.sh" "/ChemAutoInstaller.sh"
RUN bash ChemAutoInstaller.sh -A
