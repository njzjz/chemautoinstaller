FROM ubuntu:20.04@sha256:b4aa552dd3f2ed84f3214b0e8add3648aee0205ef58295c92fe0899f96ad8755
RUN apt update && apt install wget bzip2 -y && apt clean -y
COPY "ChemAutoInstaller.sh" "/ChemAutoInstaller.sh"
RUN bash ChemAutoInstaller.sh -A
