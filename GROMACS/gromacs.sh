#!/bin/bash

#SBATCH -p LUNGO                # Partition: [LUNGO].
#SBATCH --time=7-00:00:00       # Walltime: max depends on the partition chosen.
#SBATCH --cpus-per-task=16      # Nombre de coeurs.
#SBATCH --mem=20000             # 20000 Mb = 20 Gb by default.
#SBATCH --gres=gpu:1            # Nombre de GPU (aucune par défaut).
#SBATCH --nodes=1               # Number of nodes.
#SBATCH --output=%x.%j.out      # Standard output + error.
#SBATCH -J "MD_RUN"             # Job name.

# Move to the directory where the job was submitted.
cd $SLURM_SUBMIT_DIR

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

ml purge
ml gromacs/gpu/2022

date;pwd

for path in MD_1 MD_2 MD_3
do
    # Move to a replicat directory.
    cd $path/
    
    ### Steepest descent.
    
    # Generate a file to do the minimization.
    gmx grompp -f minim_steep.mdp -c ions.gro -p topol.top -o steep.tpr
    # Run the minimization.
    gmx mdrun -v -deffnm steep > steep.log
    
    ### Conjugated gradient.
    
    # Generate a file to do the minimization.
    gmx grompp -f minim_cg.mdp -c steep.gro -p topol.top -o cg.tpr
    # Run the minimization.
    gmx mdrun -v -deffnm cg > cg.log
    
    ### Equilibration to NVT.
    
    # Generate a file to do the NVT equilibration.
    gmx grompp -f nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr
    # Run the NVT equilibration.
    gmx mdrun -deffnm nvt > nvt.log
    
    ### Equilibration to NPT.
    
    # Generate a file to do the NPT equilibration.
    gmx grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top \
    -o npt.tpr
    # Run the NPT equilibration.
    gmx mdrun -deffnm npt > npt.log
    
    ### Production.
    
    # Generate a file to do the production.
    gmx grompp -f md.mdp -c npt.gro -t npt.cpt -p topol.top -o md.tpr
    # Run the production.
    gmx mdrun -deffnm md > md.log

    # Move to a main directory.
    cd ../
done

date
