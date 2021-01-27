FROM ubuntu:20.04@sha256:703218c0465075f4425e58fac086e09e1de5c340b12976ab9eb8ad26615c3715
RUN apt update && apt install wget bzip2 -y && apt clean -y
COPY "ChemAutoInstaller.sh" "/ChemAutoInstaller.sh"
RUN bash ChemAutoInstaller.sh -A
