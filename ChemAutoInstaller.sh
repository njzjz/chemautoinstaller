#!/bin/bash

cat <<EOF
ChemAutoInstaller
Use Anaconda to install common Chemistry packages.

Author:Jinzhe Zeng
Email:jzzeng@stu.ecnu.edu.cn
EOF

function usage() {
	cat <<EOF
Available command-line options:
--all, -A                           Install all of softwares
--anaconda --openbabel --rdkit      Install softwares one by one
--lammps --vmd --openmpi
--prefix                            Directory of Anaconda, default is $HOME/anaconda3
--help, -h                          See help
EOF
}

ARGS=$(getopt -a -o Ah -l prefix:,all,anaconda,openbabel,rdkit,lammps,vmd,openmpi,cn,help -- "$@")
[ $? -ne 0 ] && usage && exit
[ $# -eq 0 ] && usage && exit
eval set -- "${ARGS}"

CAI_ANACONDA_DIR=$HOME/anaconda3
CAI_ANACONDA_URL="https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh"
CAI_CONDA_FORGE=conda-forge

while true; do
	case "$1" in
	--prefix)
		CAI_ANACONDA_DIR=$2
		;;
	--anaconda)
		CAI_ANACONDA=42
		;;
	--openbabel)
		CAI_PACKAGE="$CAI_PACKAGE openbabel"
		;;
	--rdkit)
		CAI_PACKAGE="$CAI_PACKAGE rdkit"
		;;
	--lammps)
		CAI_PACKAGE="$CAI_PACKAGE lammps"
		;;
	--vmd)
		CAI_PACKAGE="$CAI_PACKAGE vmd"
		;;
	--openmpi)
		CAI_PACKAGE="$CAI_PACKAGE openmpi"
		;;
	-A | --all)
		CAI_PACKAGE="openbabel rdkit lammps vmd openmpi"
		;;
	-h | --help)
		usage
		exit
		;;
	--)
		break
		;;
	esac
	shift
done

test "$CAI_ANACONDA" || test "$CAI_PACKAGE" || exit

# check whether conda is installed
if ! [ -x "$(command -v conda)" ]; then
	echo Installing Anaconda 3...
	CAI_ANACONDA_BASH=$(mktemp)
	curl -# -o "$CAI_ANACONDA_BASH" "$CAI_ANACONDA_URL"
	bash "$CAI_ANACONDA_BASH" -b -p "$CAI_ANACONDA_DIR"
	rm -rf "$CAI_ANACONDA_BASH"
	export PATH=$CAI_ANACONDA_DIR/bin:$PATH
	conda init
fi
# use tsinghua mirror in China
test "$CAI_PACKAGE" && conda install $CAI_PACKAGE -c "$CAI_CONDA_FORGE" -y
conda clean --all -y
