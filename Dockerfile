FROM continuumio/anaconda3@sha256:70e2ebd9c12fabc0089d4c0c6e963231c9a533bf9462681c30447302a7dab4e1
RUN wget -O - https://raw.githubusercontent.com/njzjz/ChemAutoInstaller/master/ChemAutoInstaller.sh | bash -s -- -A
