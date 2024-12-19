Author: Kane Collins
Email: kanecollins20@rcsi.com 
Last modified: 12/9/24

This folder contains instructions on running polygenic risk scores (PRSs). A test dataset is also included. 
There are multiple different software tools that can run PRSs including PRSice2, lassosum, and LDpred. However, they all have similar performance (https://doi.org/10.1038/s42003-022-03812-z). PRSice is probably the easiest to use, so this is the one that I will go through in this turorial. (I may also upload scripts for other PRS software in time)
There is a nice general PRS tutorial available here: https://www.nature.com/articles/s41596-020-0353-1
There is a specific PRSice tutorial available here, which is actually pretty nice: https://choishingwan.github.io/PRSice/step_by_step/ 

Not that prior to running this PRS script, you will have to make sure that your genotype data has been appropriately imputed and QC'd. All genotype files ned to be in PLINK (bed/bim/fam) format. 
This analysis PRSice and R installed on your system. 

The first step is always picking a p-value threshold. If there is evidence from previous studies in the area of a p-value threshold that can work well, then you are probably fine to just use that threshold. Otherwise you will need to split your dataset into a cohort (~20%) for selecting that p-value threshold, and another cohort (~80%) for acutally testing the efficacy of PRS. You can also experiment with changing your clumping thresholds, but this is less important I think. 
