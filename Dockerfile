FROM ubuntu:19.10@sha256:1f89ef5186c9da8ce0d878b039ed925c2c807ecc3aa16e7d4a4b55650faff5db
RUN apt update && apt install wget bzip2 -y && apt clean -y
COPY "ChemAutoInstaller.sh" "/ChemAutoInstaller.sh"
RUN bash ChemAutoInstaller.sh -A
