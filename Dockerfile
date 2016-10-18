FROM ubuntu:15.04

RUN apt-get update && apt-get install -y git samtools python curl

WORKDIR /opt
RUN git clone https://github.com/mskcc/vcf2maf.git