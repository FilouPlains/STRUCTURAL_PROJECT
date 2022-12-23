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
ml gromacs/2022

date;pwd

for path in MD_1 MD_2 MD_3
do
    # Move to a replicat directory.
    cd $path/
    abs_path="/dsimb/glaciere/rouaud/$path"
    
    ### Steepest descent.
    
    # Generate a file to do the minimization.
    gmx grompp \
        -f $abs_path/minim_steep.mdp \
        -c $abs_path/ions.gro \
        -p $abs_path/topol.top \
        -o $abs_path/steep.tpr
    # Run the minimization.
    gmx mdrun -v -deffnm $abs_path/steep > $abs_path/steep.log
    
    ### Conjugated gradient.
    
    # Generate a file to do the minimization.
    gmx grompp \
        -f $abs_path/minim_cg.mdp \
        -c $abs_path/steep.gro \
        -p $abs_path/topol.top \
        -o $abs_path/cg.tpr
    # Run the minimization.
    gmx mdrun -v -deffnm $abs_path/cg > $abs_path/cg.log
    
    ### Equilibration to NVT.
    
    # Generate a file to do the NVT equilibration.
    gmx grompp \
        -f $abs_path/nvt.mdp \
        -c $abs_path/em.gro \
        -r $abs_path/em.gro \
        -p $abs_path/topol.top \
        -o $abs_path/nvt.tpr
    # Run the NVT equilibration.
    gmx mdrun -deffnm $abs_path/nvt > $abs_path/nvt.log
    
    ### Equilibration to NPT.
    
    # Generate a file to do the NPT equilibration.
    gmx grompp \
        -f $abs_path/npt.mdp \
        -c $abs_path/nvt.gro \
        -r $abs_path/nvt.gro \
        -t $abs_path/nvt.cpt \
        -p $abs_path/topol.top \
        -o npt.tpr
    # Run the NPT equilibration.
    gmx mdrun -deffnm $abs_path/npt > $abs_path/npt.log
    
    ### Production.
    
    # Generate a file to do the production.
    gmx grompp \
        -f $abs_path/md.mdp \
        -c $abs_path/npt.gro \
        -t $abs_path/npt.cpt \
        -p $abs_path/topol.top \
        -o $abs_path/md.tpr
    # Run the production.
    gmx mdrun -deffnm $abs_path/md > $abs_path/md.log
    
    # Move to a main directory.
    cd ../
done

date
