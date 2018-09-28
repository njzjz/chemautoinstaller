echo ChemAutoInstaller
echo Author:Jinzhe Zeng
echo Email:jzzeng@stu.ecnu.edu.cn

function init(){
	if [ ! -n "${CAI_SOFT_DIR}" ];then	
		CAI_SOFT_DIR=$HOME/ChemAutoInstaller
	fi
	CAI_PACKAGE_DIR=${CAI_SOFT_DIR}/packages
	CAI_BASHRC_FILE=${CAI_SOFT_DIR}/.bashrc

	if [ ! -d "${CAI_SOFT_DIR}" ]; then
		mkdir "${CAI_SOFT_DIR}"
	fi
	if [ ! -d "${CAI_PACKAGE_DIR}" ];then
		mkdir "${CAI_PACKAGE_DIR}"
	fi
	setbashrc
	checkNetwork
}

function setbashrc(){
	if [ ! -f "${CAI_BASHRC_FILE}" ]; then
		touch ${CAI_BASHRC_FILE}
		echo 'source '${CAI_BASHRC_FILE}>>$HOME/.bashrc
	fi
	source $CAI_BASHRC_FILE
	source $HOME/.bashrc
}

function checkNetwork(){
	ping -c 1 114.114.114.114 
	if [ $? -eq 0 ];then
		echo Internet is unblocked.
	else
		#ECNU Internet Login
		echo ChemAutoInstaller needs to connect the Internet.
		CAI_INTERNET_FILE=${CAI_SOFT_DIR}/.internetlogin
		if [ -f "${CAI_INTERNET_FILE}" ];then
			source ${CAI_INTERNET_FILE}
		fi
		if [ ! -n "${ECNUUSERNAME}" ];then
			read -p "Input your ECNU username:" ECNUUSERNAME
			echo 'ECNUUSERNAME='${ECNUUSERNAME}>>${CAI_INTERNET_FILE}
		fi
		if [ ! -n "${ECNUPASSWORD}" ];then
			read -p "Input your ECNU password:" ECNUPASSWORD
			echo 'ECNUPASSWORD='${ECNUPASSWORD}>>${CAI_INTERNET_FILE}
		fi
		curl -d "action=login&username=${ECNUUSERNAME}&password=${ECNUPASSWORD}&ac_id=1&ajax=1" https://login.ecnu.edu.cn/include/auth_action.php
	fi
}

#Anaconda3
function installAnaconda(){
	if ! [ -x "$(command -v conda)" ];then
		echo Installing Anaconda 3...
		CAI_ANACONDA_DIR=${CAI_SOFT_DIR}/anaconda3
		wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-5.2.0-Linux-x86_64.sh -O ${CAI_PACKAGE_DIR}/anaconda3.sh
		bash ${CAI_PACKAGE_DIR}/anaconda3.sh -b -p ${CAI_ANACONDA_DIR}
		echo 'export PATH='${CAI_ANACONDA_DIR}'/bin:$PATH'>>${CAI_BASHRC_FILE}
	    setbashrc
		setMirror
		echo Anaconda 3 is installed.
	fi
}

function setMirror(){
	wget https://tuna.moe/oh-my-tuna/oh-my-tuna.py -O ${CAI_PACKAGE_DIR}/oh-my-tuna.py
	conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
	conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/bioconda/
	python ${CAI_PACKAGE_DIR}/oh-my-tuna.py
}

#OpenBabel
function installOpenBabel(){
	echo Installing OpenBabel...
	installAnaconda
	checkNetwork
	conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/bioconda/
	conda install -y openbabel
}

#RDkit
function installRDkit(){
	echo Installing RDkit...
	installAnaconda
	checkNetwork
	conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/bioconda/
	conda install -y rdkit
}

#ReacNetGenerator
function installReacNetGenerator(){
	echo Installing ReacNetGenerator...
	installAnaconda
	checkNetwork
	conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/bioconda/
	conda install -y reacnetgenerator -c njzjz
}

#LAMMPS
function installLAMMPS(){
	echo Installing LAMMPS...
	CAI_LAMMPS_DIR=${CAI_SOFT_DIR}/lammps
    wget http://lammps.sandia.gov/tars/lammps-stable.tar.gz -O ${CAI_PACKAGE_DIR}/lammps.tar.gz
	tar -vxf ${CAI_PACKAGE_DIR}/lammps.tar.gz -C ${CAI_PACKAGE_DIR}
	mv ${CAI_PACKAGE_DIR}/lammps-22Aug18 ${CAI_LAMMPS_DIR}	
	cd ${CAI_LAMMPS_DIR}/src && make yes-user-reaxc && make yes-user-intel
	if checkIntel ;then
		cd ${CAI_LAMMPS_DIR}/src && make intel_cpu_intelmpi
	else
		installOpenMPI
		cd ${CAI_LAMMPS_DIR}/src && make mpi
	fi
	echo 'export PATH=$PATH:'${CAI_LAMMPS_DIR}/src>>${CAI_BASHRC_FILE}
	setbashrc
}

function installOpenMPI(){
	echo Installing OPENMPI...
	if ! [ -x "$(command -v mpirun)" ];then
		CAI_OPENMPI_DIR=${CAI_SOFT_DIR}/openmpi
		checkNetwork	
		wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.0.tar.bz2 -O ${CAI_PACKAGE_DIR}/openmpi.tar.bz2
		tar -vxf ${CAI_PACKAGE_DIR}/openmpi.tar.bz2 -C ${CAI_PACKAGE_DIR}
		mkdir $CAI_OPENMPI_DIR
		installgcc
		installgfortran
		cd ${CAI_PACKAGE_DIR}/openmpi-3.1.0 && ./configure --prefix=${CAI_OPENMPI_DIR}
		cd ${CAI_PACKAGE_DIR}/openmpi-3.1.0/ &&	make all install
        rm -rf ${CAI_PACKAGE_DIR}/openmpi-3.1.0/
		echo 'export PATH=$PATH:'${CAI_OPENMPI_DIR}/bin>>${CAI_BASHRC_FILE}
		echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:'${CAI_OPENMPI_DIR}/lib>>${CAI_BASHRC_FILE}
		setbashrc
	fi
}

function checkIntel(){
	CAI_INTEL_SH=/share/apps/intel/compilers_and_libraries/linux/bin/compilervars.sh
	if [ -f "${CAI_INTEL_SH}" ];then
		source ${CAI_INTEL_SH} intel64
	fi
	if [ -x "$(command -v mpiicpc)" ];then
		return 0
	else
		return 1
	fi
}

function installgcc(){
	if ! [ -x "$(command -v g++)" ];then
		installAnaconda
		conda install -y gcc
	fi
}

function installgfortran(){
	if ! [ -x "$(command -v gfortran)" ];then
		installAnaconda
		conda install -y gfortran_linux-64
	fi
}

#VMD
function installVMD(){
	echo Installing VMD...
	if ! [ -x "$(command -v vmd)" ];then
		CAI_VMD_DIR=${CAI_SOFT_DIR}/vmd
		checkNetwork
		wget http://www.ks.uiuc.edu/Research/vmd/vmd-1.9.3/files/final/vmd-1.9.3.bin.LINUXAMD64-CUDA8-OptiX4-OSPRay111p1.opengl.tar.gz -O ${CAI_PACKAGE_DIR}/vmd.tar.gz
		tar -vxzf ${CAI_PACKAGE_DIR}/vmd.tar.gz -C ${CAI_PACKAGE_DIR}
		cat ${CAI_PACKAGE_DIR}/vmd-1.9.3/configure|sed '16c $install_bin_dir="'${CAI_VMD_DIR}'/bin";'|sed '19c $install_library_dir="'${CAI_VMD_DIR}'/lib/$install_name";'>${CAI_PACKAGE_DIR}/vmd-1.9.3/configure_CAI
		mv ${CAI_PACKAGE_DIR}/vmd-1.9.3/configure_CAI ${CAI_PACKAGE_DIR}/vmd-1.9.3/configure
		chmod +x ${CAI_PACKAGE_DIR}/vmd-1.9.3/configure
		cd ${CAI_PACKAGE_DIR}/vmd-1.9.3/ && ./configure LINUXAMD64
		cd ${CAI_PACKAGE_DIR}/vmd-1.9.3/ && ./configure
		cd ${CAI_PACKAGE_DIR}/vmd-1.9.3/src && make install
		rm -rf ${CAI_PACKAGE_DIR}/vmd-1.9.3/
		echo 'export PATH=$PATH:'${CAI_VMD_DIR}/bin>>${CAI_BASHRC_FILE}
		setbashrc
	fi
}

function installGrace(){
	checkNetwork
	wget ftp://plasma-gate.weizmann.ac.il/pub/grace/src/grace-latest.tar.gz -O ${CAI_PACKAGE_DIR}/grace.tar.gz
	tar -vxzf ${CAI_PACKAGE_DIR}/grace.tar.gz -C ${CAI_PACKAGE_DIR}
	cd ${CAI_PACKAGE_DIR}/grace-5.1.25 && ./configure --prefix=${CAI_SOFT_DIR}
	cd ${CAI_PACKAGE_DIR}/grace-5.1.25 && make && make install
	rm -rf ${CAI_PACKAGES_DIR}/grace-5.1.25
	echo 'export PATH=$PATH:'${CAI_SOFT_DIR}/grace/bin>>${CAI_BASHRC_FILE}
	setbashrc
}

function usage(){
	echo Usage:
	echo Install softwares one by one:
	echo bash ChemAutoInstaller.sh --anaconda --openbabel --rdkit --lammps --vmd --openmpi --grace --reacnetgenerator
	echo Or install all of them:
	echo bash ChemAutoInstaller.sh --all
}

ARGS=`getopt -a -o Ah -l prefix:,all,anaconda,openbabel,rdkit,lammps,vmd,openmpi,grace,reacnetgenerator,help -- "$@"`
[ $? -ne 0 ] && usage && exit
[ $# -eq 0 ] && usage && exit
eval set -- "${ARGS}"

while true;do
	case "$1" in
		--prefix)
			CAI_SOFT_DIR=$2
			;;
		--anaconda)
			CAI_IF_INSTALL=42
			CAI_IF_ANACONDA=42
			;;
		--openbabel)
			CAI_IF_INSTALL=42
			CAI_IF_OPENBABEL=42
			;;
		--rdkit)
			CAI_IF_INSTALL=42
			CAI_IF_RDKIT=42
			;;
		--lammps)
			CAI_IF_INSTALL=42
			CAI_IF_LAMMPS=42
			;;
		--vmd)
			CAI_IF_INSTALL=42
			CAI_IF_VMD=42
			;;
		--openmpi)
			CAI_IF_INSTALL=42
			CAI_IF_OPENMPI=42
			;;
		--grace)
			CAI_IF_INSTALL=42
			CAI_IF_GRACE=42
			;;
		--reacnetgenerator)
			CAI_IF_INSTALL=42
			CAI_IF_REACNETGENERATOR=42
			;;
		-A|--all)
			CAI_IF_INSTALL=42
			CAI_IF_ANACONDA=42
			CAI_IF_OPENBABEL=42
			CAI_IF_RDKIT=42
			CAI_IF_LAMMPS=42
			CAI_IF_VMD=42
			CAI_IF_OPENMPI=42
			CAI_IF_REACNETGENERATOR=42
			CAI_IF_GRACE=42
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

if [ ! -z "$CAI_IF_INSTALL" ];then
	init
else
	usage && exit
fi
if [ ! -z "$CAI_IF_ANACONDA" ];then
	installAnaconda
fi
if [ ! -z "$CAI_IF_OPENBABEL" ];then
	installOpenBabel
fi
if [ ! -z "$CAI_IF_RDKIT" ];then
	installRDkit
fi
if [ ! -z "$CAI_IF_LAMMPS" ];then
	installLAMMPS
fi
if [ ! -z "$CAI_IF_VMD" ];then
	installVMD
fi
if [ ! -z "$CAI_IF_OPENMPI" ];then
	installOpenMPI
fi
if [ ! -z "$CAI_IF_REACNETGENERATOR" ];then
	installReacNetGenerator
fi
if [ ! -z "$CAI_IF_GRACE" ];then
	installGrace
fi
