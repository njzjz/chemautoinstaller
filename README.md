# ChemAutoInstaller
Scripts to install chemical softwares on Linux automatically.

**Author**: Jinzhe Zeng

**Email**: njzjz@qq.com 10154601140@stu.ecnu.edu.cn

## Supporting Softwares
* [LAMMPS](https://github.com/lammps/lammps)
* [VMD](http://www.ks.uiuc.edu/Research/vmd/)
* [OpenBabel](https://github.com/openbabel/openbabel)
* [RDkit](https://github.com/rdkit/rdkit)
* [Anaconda 3](https://conda.io)
* [OpenMPI](https://github.com/open-mpi/ompi)
* [ReacNetGenerator](https://github.com/njzjz/ReacNetGenerator)

## Usage
Only run the following script to install all of softwares:

```bash
$ wget https://raw.githubusercontent.com/njzjz/ChemAutoInstaller/master/ChemAutoInstaller.sh && bash ChemAutoInstaller.sh -A
```

Or you can install them one by one:
```bash
$ bash ChemAutoInstaller.sh --anaconda --openbabel --rdkit --lammps --vmd --reacnetfenerator
```
