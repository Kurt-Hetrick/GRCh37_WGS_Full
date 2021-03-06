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

START_APPLY_VQSR_SNP=`date '+%s'`

$JAVA_1_7/java -jar $GATK_DIR/GenomeAnalysisTK.jar \
-T ApplyRecalibration \
-R $REF_GENOME \
--input:VCF $CORE_PATH/$PROJECT/TEMP/$SM_TAG".raw.vcf.gz" \
--ts_filter_level 99.5 \
-recalFile $CORE_PATH/$PROJECT/SNV/SINGLE/WHOLE_GENOME/$SM_TAG".HC.SNV.recal" \
-tranchesFile $CORE_PATH/$PROJECT/SNV/SINGLE/WHOLE_GENOME/$SM_TAG".HC.SNV.tranches" \
-mode SNP \
-o $CORE_PATH/$PROJECT/TEMP/$SM_TAG".SNV.VQSR.vcf.gz"

END_APPLY_VQSR_SNP=`date '+%s'`

HOSTNAME=`hostname`

echo $SM_TAG"_"$PROJECT",O.01,APPLY_VQSR_SNV,"$HOSTNAME","$START_APPLY_VQSR_SNP","$END_APPLY_VQSR_SNP \
>> $CORE_PATH/$PROJECT/REPORTS/$PROJECT".WALL.CLOCK.TIMES.csv"

echo $JAVA_1_7/java -jar $GATK_DIR/GenomeAnalysisTK.jar \
-T ApplyRecalibration \
-R $REF_GENOME \
--input:VCF $CORE_PATH/$PROJECT/TEMP/$SM_TAG".raw.vcf.gz" \
--ts_filter_level 99.5 \
-recalFile $CORE_PATH/$PROJECT/SNV/SINGLE/WHOLE_GENOME/$SM_TAG".HC.SNV.recal" \
-tranchesFile $CORE_PATH/$PROJECT/SNV/SINGLE/WHOLE_GENOME/$SM_TAG".HC.SNV.tranches" \
-mode SNP \
-o $CORE_PATH/$PROJECT/TEMP/$SM_TAG".SNV.VQSR.vcf.gz" \
>> $CORE_PATH/$PROJECT/$SM_TAG".COMMAND.LINES.txt"

echo >> $CORE_PATH/$PROJECT/$SM_TAG".COMMAND.LINES.txt"
