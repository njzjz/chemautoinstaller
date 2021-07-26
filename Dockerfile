FROM ubuntu:21.10@sha256:37d35c41322732a32d22af39cdc2e8b481c7c1cf432accfd1d28f4c852e9250e
RUN apt update && apt install wget bzip2 -y && apt clean -y
COPY "ChemAutoInstaller.sh" "/ChemAutoInstaller.sh"
RUN bash ChemAutoInstaller.sh -A
