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
for f in data/SRR10395*.sub.fastq.gz; do echo "$f $(( $(zcat "$f" | wc -l) / 4 )) reads" done