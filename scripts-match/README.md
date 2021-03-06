**Generate position files**
> cd proteins/CPG2

Make staples across chain A and chain B
> python ../../scripts-match/generate_position_files.py CPG2_relaxed.pdb -chains A B -wl 1000 // -wl is 1000 by default

or make staples within chain A
> python ../../scripts-match/generate_position_files.py CPG2_relaxed.pdb -chain A -wl 1000 // -wl is 1000 by default

> ls

CPG2-AB (or CPG2-A)
> ls CPG2-AB

CPG2-AB_1 CPG2-AB_2 CPG2-AB_3
> ls CPG2-A

CPG2-A_1 CPG2-A_2 CPG2-A_3
> cd ../..

**Match**
> cd designs

> mkdir CPG2_pAaF

> cd CPG2_pAaF

Make staples across chain A and chain B
> ../../scripts-match/match.sh -pos ../../proteins/CPG2/CPG2-AB -lig ../../ligands/pAaF/pAaF-intermediate -mem 8000 // memory is 8000 by default

> ../../scripts-match/match.sh -pos ../../proteins/CPG2/CPG2-AB -lig ../../ligands/pAaF/pAaF-product -mem 8000

or make staples within chain A
> ../../scripts-match/match.sh -pos ../../proteins/CPG2/CPG2-A -lig ../../ligands/pAaF/pAaF-intermediate -mem 8000

> ../../scripts-match/match.sh -pos ../../proteins/CPG2/CPG2-A -lig ../../ligands/pAaF/pAaF-product -mem 8000

**Convert output CloudPDB files into FastDesign input files**

Install Anaconda3 in the /home/NetID/anaconda3 folder and then install the PyMOL module. If you have installed Anaconda3 on Amarel, skip this step.
Go to https://repo.anaconda.com/archive/. Choose the newest Linux-x86_64 version and put it in the /home/NetID directory.
> bash Anaconda3-2020.07-Linux-x86_64.sh

Make sure that the Anaconda3 has initialized each time you login your Amarel account.
> source ~/anaconda3/bin/activate

> conda create -n pymol python=3.7

> conda activate pymol

> conda install -c schrodinger pymol

Make staples across chain A and chain B
> ../../scripts-match/generate_fast_design_input.sh -pos ../../proteins/CPG2/CPG2-AB -dup true -symm true

or make staples within chain A
> ../../scripts-match/generate_fast_design_input.sh -pos ../../proteins/CPG2/CPG2-A -symm true

Unload Anaconda
> conda deactivate
