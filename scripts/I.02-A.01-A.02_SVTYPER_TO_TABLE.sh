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

CORE_PATH=$4
PROJECT=$5
SM_TAG=$6

# convert lumpy/svtyper all vcf into a table.

START_SVTYPER_TO_TABLE=`date '+%s'`

# filter non-karyotype, non-human contigs and resort by chr/position keys

(grep "^#" $CORE_PATH/$PROJECT/LUMPY/VCF/$SM_TAG".LUMPY.ALL.GT.vcf" ; \
grep -v "^#" $CORE_PATH/$PROJECT/LUMPY/VCF/$SM_TAG".LUMPY.ALL.GT.vcf" | awk '$1~/^[0-9]/' | sort -k 1,1n -k 2,2n ; \
grep -v "^#" $CORE_PATH/$PROJECT/LUMPY/VCF/$SM_TAG".LUMPY.ALL.GT.vcf" | awk '$1=="X"' | sort -k 2,2n ; \
grep -v "^#" $CORE_PATH/$PROJECT/LUMPY/VCF/$SM_TAG".LUMPY.ALL.GT.vcf" | awk '$1=="Y"' | sort -k 2,2n ; \
grep -v "^#" $CORE_PATH/$PROJECT/LUMPY/VCF/$SM_TAG".LUMPY.ALL.GT.vcf" | awk '$1=="MT"' | sort -k 2,2n) \
>| $CORE_PATH/$PROJECT/TEMP/$SM_TAG".sorted.lumpy.all.2.vcf"

$JAVA_1_7/java -jar $GATK_DIR/GenomeAnalysisTK.jar \
-T VariantsToTable \
--disable_auto_index_creation_and_locking_when_reading_rods \
-R $REF_GENOME \
--variant $CORE_PATH/$PROJECT/TEMP/$SM_TAG".sorted.lumpy.all.2.vcf" \
-o $CORE_PATH/$PROJECT/TEMP/$SM_TAG.LUMPY.ALL.GT.txt \
--fields CHROM \
--fields POS \
--fields END \
--fields SVTYPE \
--fields SVLEN \
--fields MATEID \
--fields EVENT \
--fields SECONDARY \
--fields ALT \
--fields HOM-REF \
--fields HET \
--fields HOM-VAR \
--fields NO-CALL \
--fields QUAL \
--fields ID \
--fields FILTER \
--fields IMPRECISE \
--fields STRANDS \
--fields CIPOS \
--fields CIEND \
--fields CIPOS95 \
--fields CIEND95 \
--fields SU \
--fields PE \
--fields SR \
--genotypeFields SAC \
--genotypeFields GT \
--genotypeFields SU \
--genotypeFields PE \
--genotypeFields SR \
--genotypeFields GQ \
--genotypeFields SQ \
--genotypeFields GL \
--genotypeFields DP \
--genotypeFields RO \
--genotypeFields AO \
--genotypeFields QR \
--genotypeFields QA \
--genotypeFields RS \
--genotypeFields AS \
--genotypeFields ASC \
--genotypeFields RP \
--genotypeFields AP \
--genotypeFields AB \
--allowMissingData \
--showFiltered

# concatenate the header of the vcf table to the table

(grep "^##" $CORE_PATH/$PROJECT/LUMPY/VCF/$SM_TAG.LUMPY.ALL.GT.vcf | grep -v "##fileformat=VCFv4.2" ; \
head -n 1 $CORE_PATH/$PROJECT/TEMP/$SM_TAG.LUMPY.ALL.GT.txt | awk '{print "#"$0}' ;
awk 'NR>1' $CORE_PATH/$PROJECT/TEMP/$SM_TAG.LUMPY.ALL.GT.txt) \
>| $CORE_PATH/$PROJECT/LUMPY/VCF/$SM_TAG.LUMPY.ALL.GT.txt

END_SVTYPER_TO_TABLE=`date '+%s'`

echo $SM_TAG"_"$PROJECT",K.01,SVTYPER_TO_TABLE,"$HOSTNAME","$START_SVTYPER_TO_TABLE","$END_SVTYPER_TO_TABLE\
>> $CORE_PATH/$PROJECT/$PROJECT".WALL.CLOCK.TIMES.csv"

echo $JAVA_1_7/java -jar $GATK_DIR/GenomeAnalysisTK.jar \
-T VariantsToTable \
--disable_auto_index_creation_and_locking_when_reading_rods \
-R $REF_GENOME \
--variant $CORE_PATH/$PROJECT/TEMP/$SM_TAG".sorted.lumpy.all.2.vcf" \
-o $CORE_PATH/$PROJECT/TEMP/$SM_TAG.LUMPY.ALL.GT.txt \
--fields CHROM \
--fields POS \
--fields END \
--fields SVTYPE \
--fields SVLEN \
--fields MATEID \
--fields EVENT \
--fields SECONDARY \
--fields ALT \
--fields HOM-REF \
--fields HET \
--fields HOM-VAR \
--fields NO-CALL \
--fields QUAL \
--fields ID \
--fields FILTER \
--fields IMPRECISE \
--fields STRANDS \
--fields CIPOS \
--fields CIEND \
--fields CIPOS95 \
--fields CIEND95 \
--fields SU \
--fields PE \
--fields SR \
--genotypeFields SAC \
--genotypeFields GT \
--genotypeFields SU \
--genotypeFields PE \
--genotypeFields SR \
--genotypeFields GQ \
--genotypeFields SQ \
--genotypeFields GL \
--genotypeFields DP \
--genotypeFields RO \
--genotypeFields AO \
--genotypeFields QR \
--genotypeFields QA \
--genotypeFields RS \
--genotypeFields AS \
--genotypeFields ASC \
--genotypeFields RP \
--genotypeFields AP \
--genotypeFields AB \
--allowMissingData \
--showFiltered \
>> $CORE_PATH/$PROJECT/COMMAND_LINES/$SM_TAG".COMMAND_LINES.txt"