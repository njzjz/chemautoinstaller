FROM ubuntu:18.10@sha256:50c1dc36867d3caf13f3c07456b40c57b3e6a4dcda20d05feac2c15e357353d4
RUN apt update && apt install wget bzip2 -y && apt clean -y
COPY "ChemAutoInstaller.sh" "/ChemAutoInstaller.sh"
RUN bash ChemAutoInstaller.sh -A
