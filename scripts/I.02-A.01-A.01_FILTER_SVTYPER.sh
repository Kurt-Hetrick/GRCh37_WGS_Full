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
LUMPY_EXCLUDE=$5
GATK_KEY=$6

CORE_PATH=$7
PROJECT=$8
SM_TAG=$9

# replace with gatk select variants

START_LUMPY_FILTERED_VCF=`date '+%s'`

# filter non-karyotype, non-human contigs and resort by chr/position keys

(grep "^#" $CORE_PATH/$PROJECT/LUMPY/VCF/$SM_TAG".LUMPY.ALL.GT.vcf" ; \
grep -v "^#" $CORE_PATH/$PROJECT/LUMPY/VCF/$SM_TAG".LUMPY.ALL.GT.vcf" | awk '$1~/^[0-9]/' | sort -k 1,1n -k 2,2n ; \
grep -v "^#" $CORE_PATH/$PROJECT/LUMPY/VCF/$SM_TAG".LUMPY.ALL.GT.vcf" | awk '$1=="X"' | sort -k 2,2n ; \
grep -v "^#" $CORE_PATH/$PROJECT/LUMPY/VCF/$SM_TAG".LUMPY.ALL.GT.vcf" | awk '$1=="Y"' | sort -k 2,2n ; \
grep -v "^#" $CORE_PATH/$PROJECT/LUMPY/VCF/$SM_TAG".LUMPY.ALL.GT.vcf" | awk '$1=="MT"' | sort -k 2,2n) \
>| $CORE_PATH/$PROJECT/TEMP/$SM_TAG".sorted.lumpy.all.vcf"

# exclude non-variants
# remove heng li's low copy repeat list
# remove washu blacklist

$JAVA_1_7/java -jar $GATK_DIR/GenomeAnalysisTK.jar \
-T SelectVariants \
-R $REF_GENOME \
--excludeNonVariants \
--variant $CORE_PATH/$PROJECT/TEMP/$SM_TAG".sorted.lumpy.all.vcf" \
-o $CORE_PATH/$PROJECT/LUMPY/VCF/$SM_TAG".LUMPY.GT.FILTERED.vcf" \
-sn $SM_TAG \
--excludeIntervals $LCR \
--excludeIntervals $LUMPY_EXCLUDE \
-et NO_ET \
-K $GATK_KEY

END_LUMPY_FILTERED_VCF=`date '+%s'`

echo $SM_TAG"_"$PROJECT",K.01,LUMPY_FILTERED_VCF,"$HOSTNAME","$START_LUMPY_FILTERED_VCF","$END_LUMPY_FILTERED_VCF\
>> $CORE_PATH/$PROJECT/$PROJECT".WALL.CLOCK.TIMES.csv"

echo $JAVA_1_7/java -jar $GATK_DIR/GenomeAnalysisTK.jar \
-T SelectVariants \
-R $REF_GENOME \
--excludeNonVariants \
--variant $CORE_PATH/$PROJECT/TEMP/$SM_TAG".sorted.lumpy.all.vcf" \
-o $CORE_PATH/$PROJECT/LUMPY/VCF/$SM_TAG".LUMPY.GT.FILTERED.vcf" \
-sn $SM_TAG \
--excludeIntervals $LCR \
--excludeIntervals $LUMPY_EXCLUDE \
-et NO_ET \
-K $GATK_KEY \
>> $CORE_PATH/$PROJECT/COMMAND_LINES/$SM_TAG".COMMAND_LINES.txt"
