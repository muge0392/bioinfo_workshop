conda config --show channels
conda create -y -n deneme seqkit
conda activate deneme
which seqkit
seqkit version
conda deactivate
which seqkit
conda activate deneme
which seqkit
conda deactivate
which seqkit
conda list -n variants-ready | grep -E "^(# Name|bcftools|samtools|bwa|htslib) "
conda install -y -n deneme seqtk
conda env export -n deneme --from-history > envs/deneme.yml
cat envs/deneme.yml
conda env remove -y -n deneme
conda env list
conda env list
conda env create -f envs/rnaseq.yml
#Commiting the first day, morning
git add envs/ scripts/
git commit -m "Day 1: environment files"
git push
#Data downlaod
curl -L -o data/airway_samples.csv https://github.com/onedimkurt/bioinfo-workshop/releases/download/data-v1/airway_samples.csv
head -3 data/airway_samples.csv
curl -L -o data/airway_samples.csv https://github.com/onedimkurt/bioinfo-workshop/releases/download/data-v1/airway_samples.csv
head -3 data/airway_samples.csv
curl -L -o data/airway_samples.csv https://github.com/onedimkurt/bioinfo-workshop/releases/download/data-v1/airway_samples.csv
head -3 data/airway_samples.csv
zcat data/SRR1039508_1.sub.fastq.gz | head -8
for f in data/SRR10395*.sub.fastq.gz; do
  echo "$f $(( $(zcat "$f" | wc -l) / 4 )) reads" 
done

mkdir -p result/fastqc
mkdir -p results/fastqc

fastqc -t 2 --extract -o results/fastqc data/SRR1039508_1.sub.fastq.gz data/SRR1039508_2.sub.fastq.gz data/SRR1039509_1.sub.fastq.gz data/SRR1039509_2.sub.fastq.gz

mkdir -p results/fastp
for s in SRR1039508 SRR1039509; do fastp -i data/${s}_1.sub.fastq.gz -I data/${s}_2.sub.fastq.gz \ -o results/fastp/${s}_1.trim.fastq.gz -O results/fastp/${s}_2.trim.fastq.gz \ --detect_adapter_for_pe -w 2 \ -j results/fastp/${s}.fastp.json -h results/fastp/${s}.fastp.html done
for s in SRR1039508 SRR1039509; do 
  fastp -i data/${s}_1.sub.fastq.gz -I data/${s}_2.sub.fastq.gz \ -o results/fastp/${s}_1.trim.fastq.gz -O results/fastp/${s}_2.trim.fastq.gz \ --detect_adapter_for_pe -w 2 \ -j results/fastp/${s}.fastp.json -h results/fastp/${s}.fastp.html 
  done
for s in SRR1039508 SRR1039509; do 
  fastp -i data/${s}_1.sub.fastq.gz -I data/${s}_2.sub.fastq.gz \ -o results/fastp/${s}_1.trim.fastq.gz -O results/fastp/${s}_2.trim.fastq.gz \ --detect_adapter_for_pe -w 2 \ -j results/fastp/${s}.fastp.json -h results/fastp/${s}.fastp.html 
done
for s in SRR1039508 SRR1039509; do
  fastp -i data/${s}_1.sub.fastq.gz -I data/${s}_2.sub.fastq.gz \
        -o results/fastp/${s}_1.trim.fastq.gz -O results/fastp/${s}_2.trim.fastq.gz \
        --detect_adapter_for_pe -w 2 \
        -j results/fastp/${s}.fastp.json -h results/fastp/${s}.fastp.html
done
mkdir -p results/fastqc_trimmed
fastqc -t 2 --extract -o results/fastqc_trimmed results/fastp/*.trim.fastq.gz
cat results/fastqc_trimmed/*_fastqc/summary.txt | sort -k2,2 -t$'\t' | cut -f1,2,3
salmon index -t data/gencode.v50.transcripts.chr.fa.gz -i results/salmon_index --gencode -p 2

rm -rf results/salmon_index
curl -L -o data/salmon_index.gencode.v50.tar.gz https://github.com/onedimkurt/bioinfo-workshop/releases/download/data-v1/salmon_index.gencode.v50.tar.gz
tar -xzf data/salmon_index.gencode.v50.tar.gz -C results/


for s in SRR1039508 SRR1039509; do
  salmon quant -i results/salmon_index -l A \
    -1 results/fastp/${s}_1.trim.fastq.gz -2 results/fastp/${s}_2.trim.fastq.gz \
    -p 2 -o results/salmon/${s}
done

grep -o '"percent_mapped": [0-9.]*' results/salmon/*/aux_info/meta_info.json
grep -h '"expected_format"\|"strand_mapping_bias"' results/salmon/*/lib_format_counts.json
head -5 results/salmon/SRR1039508/quant.sf
for d in data/quant/SRR*; do
  echo "$(basename $d) $(grep -o '"percent_mapped": [0-9.]*' $d/aux_info/meta_info.json)"
done

multiqc -q -o results/multiqc results/fastqc results/fastqc_trimmed results/fastp results/salmon
awk -F'\t' 'NR == 1 || $2 != ""' results/multiqc/multiqc_data/multiqc_general_stats.txt | cut -f1-4

git add scripts/
git commit -m "Day 1: reads to counts"
git push
