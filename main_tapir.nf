#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

include { SKA } from './workflows/ska'

// Print help message if requested
if (params.help) {
    log.info skaPipelineHelp()
    exit 0
}

// Print version if requested
if (params.version) {
    log.info "SKA pipeline version ${workflow.manifest.version}"
    exit 0
}

workflow {
    SKA ()
}

def skaPipelineHelp() {
    log.info"""
    SKA v${workflow.manifest.version}
    ===================================
    Usage:
    nextflow run main.nf --input samplesheet.csv --outdir <OUTDIR>

    Mandatory arguments:
      --input                       Path to input samplesheet CSV file
      --outdir                      The output directory where the results will be saved

    Optional arguments:
      --run_snpsites                Run SNP-sites to generate SNP alignment (default: false)
      --run_tree                    Run phylogenetic tree construction (default: false)
      --tree_method                 Method to use for phylogenetic tree construction (default: 'iqtree')
                                    Options: 'iqtree', 'rapidnj', 'raxml', 'fastme', 'fasttree'
      --help                        Display this help message
      --version                     Display version information

    For more information, visit https://github.com/nf-core/ska
    """.stripIndent()
}
