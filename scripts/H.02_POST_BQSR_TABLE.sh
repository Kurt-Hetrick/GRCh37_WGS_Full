# ---qsub parameter settings---
# --these can be overrode at qsub invocation--

# tell sge to execute in bash
#$ -S /bin/bash


# tell sge to submit any of these queue when available
#$ -q rnd.q,prod.q,test.q,bigdata.q

# tell sge that you are in the users current working directory
#$ -cwd

# tell sge to export the users environment variables
#$ -V

# tell sge to submit at this priority setting
#$ -p -1020

# tell sge to output both stderr and stdout to the same file
#$ -j y

# export all variables, useful to find out what compute node the program was executed on
# redirecting stderr/stdout to file as a log.

set

echo

JAVA_1_7=$1
GATK_DIR=$2
CORE_PATH=$3

PROJECT=$4
SM_TAG=$5
REF_GENOME=$6
KNOWN_INDEL_1=$7
KNOWN_INDEL_2=$8
DBSNP=$9

## --Generate post BQSR table--

START_AFTER_BQSR=`date '+%s'`

$JAVA_1_7/java -jar $GATK_DIR/GenomeAnalysisTK.jar \
-T BaseRecalibrator \
-I $CORE_PATH/$PROJECT/BAM/$SM_TAG".bam" \
-R $REF_GENOME \
-knownSites $KNOWN_INDEL_1 \
-knownSites $KNOWN_INDEL_2 \
-knownSites $DBSNP \
-BQSR $CORE_PATH/$PROJECT/REPORTS/COUNT_COVARIATES/GATK_REPORT/$SM_TAG"_PERFORM_BQSR.bqsr" \
--downsample_to_fraction .1 \
-o $CORE_PATH/$PROJECT/REPORTS/COUNT_COVARIATES/GATK_REPORT/$SM_TAG"_AFTER_BQSR.bqsr" \
-nct 8

END_AFTER_BQSR=`date '+%s'`

HOSTNAME=`hostname`

echo $SM_TAG"_"$PROJECT"_BAM_REPORTS,Z.01,AFTER_BQSR,"$HOSTNAME","$START_AFTER_BQSR","$END_AFTER_BQSR \
>> $CORE_PATH/$PROJECT/REPORTS/$PROJECT".WALL.CLOCK.TIMES.csv"

echo $JAVA_1_7/java -jar $GATK_DIR/GenomeAnalysisTK.jar \
-T BaseRecalibrator \
-I $CORE_PATH/$PROJECT/BAM/$SM_TAG".bam" \
-R $REF_GENOME \
-knownSites $KNOWN_INDEL_1 \
-knownSites $KNOWN_INDEL_2 \
-knownSites $DBSNP \
-BQSR $CORE_PATH/$PROJECT/REPORTS/COUNT_COVARIATES/GATK_REPORT/$SM_TAG"_PERFORM_BQSR.bqsr" \
-o $CORE_PATH/$PROJECT/REPORTS/COUNT_COVARIATES/GATK_REPORT/$SM_TAG"_AFTER_BQSR.bqsr" \
-nct 8 \
--downsample_to_fraction .1 \
>> $CORE_PATH/$PROJECT/$SM_TAG".COMMAND.LINES.txt"

echo >> $CORE_PATH/$PROJECT/$SM_TAG".COMMAND.LINES.txt"

md5sum $CORE_PATH/$PROJECT/REPORTS/COUNT_COVARIATES/GATK_REPORT/$SM_TAG"_AFTER_BQSR.bqsr" \
>> $CORE_PATH/$PROJECT/REPORTS/$PROJECT".CIDR.Analysis.MD5.txt"
