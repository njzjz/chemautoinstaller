FROM continuumio/anaconda3@sha256:2342379103968c3a45c8f49517ab2dff7638dd6a3842cb9cff9792acd92fa928
RUN wget -O - https://raw.githubusercontent.com/njzjz/ChemAutoInstaller/master/ChemAutoInstaller.sh | bash -s -- -A
