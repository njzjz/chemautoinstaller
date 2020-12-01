FROM ubuntu:20.10@sha256:c41e8d2a4ca9cddb4398bf08c99548b9c20d238f575870ae4d3216bc55ef3ca7
RUN apt update && apt install wget bzip2 -y && apt clean -y
COPY "ChemAutoInstaller.sh" "/ChemAutoInstaller.sh"
RUN bash ChemAutoInstaller.sh -A
