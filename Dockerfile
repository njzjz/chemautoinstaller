FROM ubuntu:18.10@sha256:99620cf8975764d3189177ff85d355a51abf902d14d2185ec987880c80d05ff3
RUN apt update && apt install wget bzip2 -y && apt clean -y
COPY "ChemAutoInstaller.sh" "/ChemAutoInstaller.sh"
RUN bash ChemAutoInstaller.sh -A
