FROM ubuntu:20.04@sha256:a15789d24a386e7487a407274b80095c329f89b1f830e8ac6a9323aa61803964
RUN apt update && apt install wget bzip2 -y && apt clean -y
COPY "ChemAutoInstaller.sh" "/ChemAutoInstaller.sh"
RUN bash ChemAutoInstaller.sh -A
