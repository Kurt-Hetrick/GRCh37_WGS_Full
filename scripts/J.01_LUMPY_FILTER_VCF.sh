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

JAVA_1_7=$1
GATK_DIR=$2
REF_GENOME=$3
LCR=$4
GATK_KEY=$5

CORE_PATH=$6
PROJECT=$7
SM_TAG=$8

# replace with gatk select variants

END_LUMPY_FILTERED_VCF=`date '+%s'`

(grep "^#" $CORE_PATH/$PROJECT/LUMPY/VCF/$SM_TAG".LUMPY.ALL.vcf" ; \
grep -v "^#" $CORE_PATH/$PROJECT/LUMPY/VCF/$SM_TAG".LUMPY.ALL.vcf" | awk '$1~/^[0-9]/' | sort -k 1,1n -k 2,2n ; \
grep -v "^#" $CORE_PATH/$PROJECT/LUMPY/VCF/$SM_TAG".LUMPY.ALL.vcf" | awk '$1=="X"' | sort -k 2,2n ; \
grep -v "^#" $CORE_PATH/$PROJECT/LUMPY/VCF/$SM_TAG".LUMPY.ALL.vcf" | awk '$1=="Y"' | sort -k 2,2n ; \
grep -v "^#" $CORE_PATH/$PROJECT/LUMPY/VCF/$SM_TAG".LUMPY.ALL.vcf" | awk '$1=="MT"' | sort -k 2,2n) \
>| $CORE_PATH/$PROJECT/TEMP/$SM_TAG".sorted.lumpy.all.vcf"


$JAVA_1_7/java -jar $GATK_DIR/GenomeAnalysisTK.jar \
-T SelectVariants \
-R $REF_GENOME \
-sn $SM_TAG \
--excludeIntervals $LCR \
--excludeIntervals $CORE_PATH/$PROJECT/LUMPY/BAM/$SM_TAG".exclude.bed" \
-et NO_ET \
-K $GATK_KEY \
--variant $CORE_PATH/$PROJECT/TEMP/$SM_TAG".sorted.lumpy.all.vcf" \
-o $CORE_PATH/$PROJECT/LUMPY/VCF/$SM_TAG".LUMPY.FILTERED.vcf"

END_LUMPY_FILTERED_VCF=`date '+%s'`

echo $SM_TAG"_"$PROJECT",K.01,LUMPY_FILTERED_VCF,"$HOSTNAME","$START_LUMPY_FILTERED_VCF","$END_LUMPY_FILTERED_VCF\
>> $CORE_PATH/$PROJECT/$PROJECT".WALL.CLOCK.TIMES.csv"

echo $JAVA_1_7/java -jar $GATK_DIR/GenomeAnalysisTK.jar \
-T SelectVariants \
-R $REF_GENOME \
-sn $SM_TAG \
--excludeIntervals $LCR \
--excludeIntervals $CORE_PATH/$PROJECT/LUMPY/BAM/$SM_TAG".exclude.bed" \
--excludeIntervals GL000207.1 \
--excludeIntervals GL000226.1 \
--excludeIntervals GL000229.1 \
--excludeIntervals GL000231.1 \
--excludeIntervals GL000210.1 \
--excludeIntervals GL000239.1 \
--excludeIntervals GL000235.1 \
--excludeIntervals GL000201.1 \
--excludeIntervals GL000247.1 \
--excludeIntervals GL000245.1 \
--excludeIntervals GL000197.1 \
--excludeIntervals GL000203.1 \
--excludeIntervals GL000246.1 \
--excludeIntervals GL000249.1 \
--excludeIntervals GL000196.1 \
--excludeIntervals GL000248.1 \
--excludeIntervals GL000244.1 \
--excludeIntervals GL000238.1 \
--excludeIntervals GL000202.1 \
--excludeIntervals GL000234.1 \
--excludeIntervals GL000232.1 \
--excludeIntervals GL000206.1 \
--excludeIntervals GL000240.1 \
--excludeIntervals GL000236.1 \
--excludeIntervals GL000241.1 \
--excludeIntervals GL000243.1 \
--excludeIntervals GL000242.1 \
--excludeIntervals GL000230.1 \
--excludeIntervals GL000237.1 \
--excludeIntervals GL000233.1 \
--excludeIntervals GL000204.1 \
--excludeIntervals GL000198.1 \
--excludeIntervals GL000208.1 \
--excludeIntervals GL000191.1 \
--excludeIntervals GL000227.1 \
--excludeIntervals GL000228.1 \
--excludeIntervals GL000214.1 \
--excludeIntervals GL000221.1 \
--excludeIntervals GL000209.1 \
--excludeIntervals GL000218.1 \
--excludeIntervals GL000220.1 \
--excludeIntervals GL000213.1 \
--excludeIntervals GL000211.1 \
--excludeIntervals GL000199.1 \
--excludeIntervals GL000217.1 \
--excludeIntervals GL000216.1 \
--excludeIntervals GL000215.1 \
--excludeIntervals GL000205.1 \
--excludeIntervals GL000219.1 \
--excludeIntervals GL000224.1 \
--excludeIntervals GL000223.1 \
--excludeIntervals GL000195.1 \
--excludeIntervals GL000212.1 \
--excludeIntervals GL000222.1 \
--excludeIntervals GL000200.1 \
--excludeIntervals GL000193.1 \
--excludeIntervals GL000194.1 \
--excludeIntervals GL000225.1 \
--excludeIntervals GL000192.1 \
--excludeIntervals NC_007605 \
--excludeIntervals hs37d5 \
-et NO_ET \
-K $GATK_KEY \
--variant $CORE_PATH/$PROJECT/LUMPY/VCF/$SM_TAG".LUMPY.ALL.vcf" \
-o $CORE_PATH/$PROJECT/LUMPY/VCF/$SM_TAG".LUMPY.FILTERED.vcf" \
>> $CORE_PATH/$PROJECT/COMMAND_LINES/$SM_TAG".COMMAND_LINES.txt"
