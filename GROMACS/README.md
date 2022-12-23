# 🎥 GROMACS

**[Main results page is here: ../README.md#-molecular-dynamic-simulations](../README.md#-molecular-dynamic-simulations)**

**🕵️‍♂️ Citation :**


**🔗 Acces link:** [https://www.gromacs.org/](https://www.gromacs.org/)

**Software version, obtain with `gmx --version`:**
```bash
GROMACS version:    2022
Precision:          mixed
Memory model:       64 bit
MPI library:        thread_mpi
OpenMP support:     enabled (GMX_OPENMP_MAX_THREADS = 128)
GPU support:        disabled
SIMD instructions:  SSE4.1
CPU FFT library:    fftw-3.3.8-sse2
GPU FFT library:    none
RDTSCP usage:       enabled
TNG support:        enabled
Hwloc support:      disabled
Tracing support:    disabled
C compiler:         /usr/bin/gcc GNU 9.3.0
C compiler flags:   -msse4.1 -pthread -Wno-missing-field-initializers -fexcess-precision=fast -funroll-all-loops -O3 -DNDEBUG
C++ compiler:       /usr/bin/c++ GNU 9.3.0
C++ compiler flags: -msse4.1 -pthread -Wno-missing-field-initializers -fexcess-precision=fast -funroll-all-loops -fopenmp -O3 -DNDEBUG
```

## 💻 Method

### Topology generation

```bash
gmx pdb2gmx -f ../ALPHAFOLD/BEST_MODEL.pdb -o P0DTC1.gro
```

Select force fild:
- CHARMM27 all-atom force field (CHARM22 plus CMAP for proteins)

Select water model:
- TIP3P   TIP 3-point, recommended

### Defining box

```bash
gmx editconf -f P0DTC1.gro -o box.gro -c -d 1.0 -bt cubic
```

### Solvating the protein

```bash
gmx solvate -cp box.gro -cs spc216.gro -o solvant.gro -p topol.top
```

### Ions addition

```bash
gmx grompp -f ions.mdp -c solvant.gro -p topol.top -o ions.tpr

gmx genion -s ions.tpr -o ions.gro -p topol.top -pname NA -nname CL -neutral
```

### Minimization of the system

**Steepest descent minimization:**

```bash
gmx grompp -f minim_steep.mdp -c ions.gro -p topol.top -o steep.tpr

gmx mdrun -v -deffnm steep

gmx energy -f steep.edr -o steep.xvg

```

**Conjugate gradient minimization:**

```bash
gmx grompp -f minim_cg.mdp -c steep.gro -p topol.top -o cg.tpr

gmx mdrun -v -deffnm cg

gmx energy -f cg.edr -o cg.xvg

```



## 📊 Results

**[Main results page is here: ../README.md#-molecular-dynamic-simulations](../README.md#-molecular-dynamic-simulations)**
