cat <<EOF
ChemAutoInstaller
Use Anaconda to install common Chemistry packages.

Author:Jinzhe Zeng
Email:jzzeng@stu.ecnu.edu.cn
EOF

function usage(){
	cat << EOF
Available command-line options:
--all, -A                           Install all of softwares
--anaconda --openbabel --rdkit      Install softwares one by one
--lammps --vmd --openmpi
--reacnetgenerator 
--prefix                            Directory of Anaconda, default is $HOME/anaconda3
--cn                                If you are in China
--help, -h                          See help
EOF
}

ARGS=$(getopt -a -o Ah -l prefix:,all,anaconda,openbabel,rdkit,lammps,vmd,openmpi,reacnetgenerator,cn,help -- "$@")
[ $? -ne 0 ] && usage && exit
[ $# -eq 0 ] && usage && exit
eval set -- "${ARGS}"

CAI_ANACONDA_DIR=$HOME/anaconda3
CAI_ANACONDA_URL="https://repo.anaconda.com/archive/Anaconda3-2018.12-Linux-x86_64.sh"
CAI_CONDA_FORGE=conda-forge

while true;do
	case "$1" in
		--prefix)
			CAI_ANACONDA_DIR=$2
			;;
		--cn)
			CAI_CN=42
			CAI_ANACONDA_URL="https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda2-2018.12-Linux-x86_64.sh"
			CAI_CONDA_FORGE="https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/"
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
		--reacnetgenerator)
			CAI_PACKAGE="$CAI_PACKAGE reacnetgenerator"
			;;
		-A|--all)
			CAI_PACKAGE="openbabel rdkit lammps vmd openmpi reacnetgenerator"
			;;
		-h|--help)
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
if ! [ -x "$(command -v conda)" ];then
	echo Installing Anaconda 3...
	CAI_ANACONDA_BASH=$(mktemp)
	wget -O $(CAI_ANACONDA_BASH) "$CAI_ANACONDA_URL" --progress=dot:giga
	bash $(CAI_ANACONDA_BASH) -b -p "$CAI_ANACONDA_DIR"
	export PATH=$CAI_ANACONDA_DIR/bin:$PATH && conda init
fi
# use tsinghua mirror in China
test "$CAI_CN" && wget -O - https://tuna.moe/oh-my-tuna/oh-my-tuna.py | python
test "$CAI_PACKAGE" && conda install "$CAI_PACKAGE" -c "$CAI_CONDA_FORGE" -c openbabel -c njzjz