#################################################################
# Dockerfile
#
# Software:         vcf2maf
# Software Version: 1.6.10
# Description:      Convert a VCF into a MAF, where each variant is annotated 
#                   to only one of all possible gene isoforms
# Website:          https://github.com/mskcc/vcf2maf
# Base Image:       opengenomics/variant-effect-predictor
# Run Cmd:          docker run vcf2maf perl vcf2maf.pl --man
#################################################################
FROM opengenomics/variant-effect-predictor

MAINTAINER Adam Struck <strucka@ohsu.edu>

USER root
ENV VEP_PATH /root/vep
ENV PATH $VEP_PATH/htslib:$VEP_PATH/samtools/bin:$PATH
ENV PERL5LIB $VEP_PATH:/opt/lib/perl5:$PERL5LIB

# install htslib, samtools, and bcftools
WORKDIR $VEP_PATH

RUN mkdir $VEP_PATH/samtools && cd $VEP_PATH/samtools && \
    curl -LOOO https://github.com/samtools/{samtools/releases/download/1.3.1/samtools-1.3.1,bcftools/releases/download/1.3.1/bcftools-1.3.1}.tar.bz2 && \
    cat *tar.bz2 | tar -ijxf - &&\
    cd samtools-1.3.1 && make && make prefix=$VEP_PATH/samtools install && cd .. && \
    cd bcftools-1.3.1 && make && make prefix=$VEP_PATH/samtools install && cd .. && \
    cd ..

# install liftOver
RUN curl -L http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/liftOver > $VEP_PATH/samtools/bin/liftOver && \
    chmod a+x $VEP_PATH/samtools/bin/liftOver

# install vcf2maf
WORKDIR /home/

RUN curl -ksSL -o tmp.tar.gz https://github.com/mskcc/vcf2maf/archive/v1.6.10.tar.gz && \
    tar --strip-components 1 -zxf tmp.tar.gz && \
    rm tmp.tar.gz

CMD ["perl", "vcf2maf.pl", "--man"]
