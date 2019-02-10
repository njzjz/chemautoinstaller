FROM continuumio/anaconda3
RUN wget -O - https://raw.githubusercontent.com/njzjz/ChemAutoInstaller/master/ChemAutoInstaller.sh | bash -A
