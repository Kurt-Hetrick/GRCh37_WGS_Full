# ---qsub parameter settings---
# --these can be overrode at qsub invocation--

# tell sge to execute in bash
#$ -S /bin/bash 

# tell sge to submit any of these queue when available
#$ -q prod.q,rnd.q,test.q,bigdata.q

# tell sge that you are in the users current working directory
#$ -cwd

# tell sge to export the users environment variables
#$ -V

# tell sge to submit at this priority setting
#$ -p -450

# tell sge to output both stderr and stdout to the same file
#$ -j y

# export all variables, useful to find out what compute node the program was executed on
# redirecting stderr/stdout to file as a log.

set

echo

PYTHON_EXE=`which python`

echo PYTHON BEING USED IS $PYTHON_EXE

echo

echo LD_LIBRARY_PATH IS $LD_LIBRARY_PATH

echo

echo PATH is $PATH

echo

LUMPY_DIR=$1

CORE_PATH=$2
PROJECT=$3
SM_TAG=$4

# run lumpy's coverage script to generate output files needed for creating the exclusion bed of high depth regions.

START_LUMPY_COVERGE=`date '+%s'`

python $LUMPY_DIR/../scripts/get_coverages.py \
$CORE_PATH/$PROJECT/LUMPY/BAM/$SM_TAG".lumpy.discordant.pe.sort.bam" \
$CORE_PATH/$PROJECT/LUMPY/BAM/$SM_TAG".lumpy.discordant.split.reads.sort.bam"

END_LUMPY_COVERGE=`date '+%s'`

echo $SM_TAG"_"$PROJECT",I.01_LUMPY_COVERAGE,"$HOSTNAME","$START_EXCLUSION_LIST","$END_EXCLUSION_LIST\
>> $CORE_PATH/$PROJECT/$PROJECT".WALL.CLOCK.TIMES.csv"

echo python $LUMPY_DIR/../scripts/get_coverages.py \
$CORE_PATH/$PROJECT/LUMPY/BAM/$SM_TAG".lumpy.discordant.pe.sort.bam" \
$CORE_PATH/$PROJECT/LUMPY/BAM/$SM_TAG".lumpy.discordant.split.reads.sort.bam" \
>> $CORE_PATH/$PROJECT/COMMAND_LINES/$SM_TAG".COMMAND_LINES.txt"
