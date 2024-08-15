#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.reads = "$baseDir/data/*_{R1,R2}.fastq.gz"
params.resultsPath = "$baseDir/results"

process Trimmer {

    tag "${sample_id}"
    publishDir "${params.resultsPath}/cleaned_reads", mode: 'copy'

    input:
    tuple val(sample_id), path(read1), path(read2)

    output:
    tuple val(sample_id), path("${sample_id}_clean_R1.fastq.gz"), path("${sample_id}_clean_R2.fastq.gz")

    script:
    """
    fastp \\
        -i $read1 \\
        -I $read2 \\
        -o ${sample_id}_clean_R1.fastq.gz \\
        -O ${sample_id}_clean_R2.fastq.gz \\
        --detect_adapter_for_pe \\
        --cut_front \\
        --cut_tail \\
        --cut_right \\
        --cut_window_size 4 \\
        --cut_mean_quality 15
    """
}

process Assembler {

    tag "${sample_id}"
    publishDir "${params.resultsPath}/assembly", mode: 'copy', pattern: "spades_output_*.fasta", saveAs: { filename -> "assembled_${filename}" }

    input:
    tuple val(sample_id), path(clean_r1), path(clean_r2)

    output:
    path("spades_output_*.fasta")

    script:
    """
    spades.py -1 $clean_r1 -2 $clean_r2 -o output_${sample_id} --isolate
    mv output_${sample_id}/contigs.fasta spades_output_${sample_id}.fasta
    """
}

workflow {

    readpairs = Channel.fromFilePairs(params.reads, size: 2, flat: true)

    cleanreads = readpairs
        | Trimmer

    assembledGenomes = cleanreads
        | Assembler

    assembledGenomes
        .view { it -> "Genome assembly completed for: ${it}" }
}