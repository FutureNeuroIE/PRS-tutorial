#!/bin/bash 
#BATCH --job-name=PRS
#SBATCH --output=%j.prs.out
#SBATCH --partition=ProdQ
#SBATCH --time=1-00:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=15G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=youremail@rcsi.com
#### 
#### Kane Collins <kanecollins20@rcsi.ie> - September 2024
#### Script for running PRSs
#### 

#Note that before you run this script, you must make sure that your data has been adeqeutly QC'd (see instructions in the word document)

####################USER INPUTS###############
#You will need to change the file names to the names of your files
#You can also load the modules required here. This step will depend on your system, the example given will probably be different on your system. 
#We require plink1.9 and R to be loaded. 

#The location of this folder
workdir=/location/here

#Name of the genotype file prefix
genotypefilename=toy_data/TOY_TARGET_DATA

#First define individuals to be in the train dataset (400) and test dataset (1600)
sort -R $genotypefilename.fam | head -n400 | awk '{print $1, $2}' > toy_data/train_indivs.txt

#Load PLINK
module load PLINK

#Load R
module load R

#########Split data into train and test
plink2 --bfile $workdir/$genotypefilename \
	--keep $workdir/toy_data/train_indivs.txt \
	--make-bed \
	--out $workdir/toy_data/train

plink2 --bfile $workdir/$genotypefilename \
	--remove $workdir/toy_data/train_indivs.txt \
	--make-bed \
	--out $workdir/toy_data/test


##PRSice inputs, you can change these if you want, and have lots of data of train with, but I think these ones generally work pretty well. 
clump_kb=250
clump_r2=0.1
quantile=20

#Just make sure that your PRSice.R and your PRSice_linux files are in the correct directory
#Depending on your phenotype of interest, you will need to specify whether you are looking at a 
#continious or binary variable and will need to adjust the --stat and -binary-target variables accordingly
#It is also good to normalize the PRSs, particularly for any meta-analyses that you might run where you are 
#likely to be using slightly different SNPs, and will thus get somewhat different raw PRSs
#You may also wish to control for covariates such as sex, or principal components of ancestry using --cov or --cov-factor. In this simple example, I don't do so. 
#I have also specified that the output images are made as pdfs rather than pngs, this is just as the png option does not work on many servers
Rscript PRSice.R --dir . \
    --prsice ./PRSice_linux \
    --base toy_data/TOY_BASE_GWAS.assoc \
    --target toy_data/train \
    --clump-kb $clump_kb \
	--clump-r2 $clump_r2 \
    --thread 1 \
    --score std \
    --stat OR \
    --quantile $quantile \
    --binary-target T \
    --device pdf \
	--out train_output

#In this toy example, the optimal p-value threshold is 0.4755, therefore that is what we will use
bar_level=0.4755

#This is very similar to what we have above, but with the addition of the --bar-levels option, which is our p-vlaue threshold, 
#and the --fastscore option to only calculate this, and not waste time caluclating at other thresholds
#Obviously we are also now using our test data rather than the train data
Rscript PRSice.R --dir . \
    --prsice ./PRSice_linux \
    --base toy_data/TOY_BASE_GWAS.assoc \
    --target toy_data/test \
    --clump-kb $clump_kb \
	--clump-r2 $clump_r2 \
	--bar-levels $bar_level \
	--fastscore \
	--no-full \
    --thread 1 \
    --score std \
    --stat OR \
    --quantile $quantile \
    --binary-target T \
    --device pdf \
	--out test_output

###################################################
#Once you have done this, you can carry out whatever analysis you are interested in using your .best file
#In the future, I may also upload some scripts to do this, though this will likely differ substantially from whatever you want to do. 

#tidy up
rm toy_data/test.*
rm toy_data/train.*
echo "Finished"