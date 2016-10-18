
cwlVersion: v1.0
class: CommandLineTool

requirements:
    DockerRequirement:
        dockerPull: opengenomics/vcf1maf
        
baseCommand: [ perl, /opt/vcf2maf/maf2vcf.pl, --output-dir, ./ ]

inputs:
    maf:
      type: File
      inputBinding:
          prefix: "--input-maf"
    reference:
      type: File
      inputBinding:
          prefix: "--ref-fasta"

outputs:
    outvcf:
       type: File
       outputBinding:
          glob: "*.vcf"
