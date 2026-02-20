#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

include { INPUT_CHECK } from './subworkflows/local/input_check'
include { SKA_PHYLOGENY } from './workflows/ska_phylogeny'

// Function to print help message
def helpMessage() {
    log.info"""
    Usage:
    nextflow run main.nf [options]

    Options:
        --input                 Input CSV file with sample information
        --outdir                Output directory (default: './results')
        --run_snpsites          Run SNP-sites (default: false)
        --run_tree_building     Run tree building (default: false)
        --tree_method           Tree building method (default: 'iqtree')
                                Options: 'iqtree', 'rapidnj', 'raxml', 'fastme', 'fasttree'

    Flags:
        --help          Display this help message
        --version       Display version information
    """
}

// Function to print version information
def versionMessage() {
    log.info"SKA Phylogeny Pipeline v1.0.0"
    log.info"Nextflow version: $workflow.nextflow.version"
}

// Function to print workflow summary
def workflowSummary() {
    // Print parameter summary
    log.info """
    ====================================
    SKA Phylogeny Pipeline
    ====================================
    Input CSV        : ${params.input}
    Output directory : ${params.outdir}
    Run SNP-sites    : ${params.run_snpsites}
    Run tree building: ${params.run_tree_building}
    Tree method      : ${params.run_tree_building ? params.tree_method : 'N/A'}
    ====================================
    """
}

// Main workflow
workflow {

    // Check for help or version flags
    if (params.help) {
        helpMessage()
        exit 0
    }
    if (params.version) {
        versionMessage()
        exit 0
    }

    // Input validation
    INPUT_CHECK ( file(params.input) )
    // INPUT_CHECK.out.input_data.view { "INPUT_CHECK data: $it" }
    // Run the main workflow
    SKA_PHYLOGENY ( INPUT_CHECK.out.input_data, params.tree_method )
    // SKA_PHYLOGENY.out.versions.view { "SKA_PHYLOGENY versions: $it" }
    // Collect and save versions information
    ch_versions = INPUT_CHECK.out.versions.mix(SKA_PHYLOGENY.out.versions.ifEmpty(channel.empty()))

    // Print workflow summary on start
    workflow.onComplete = {
        workflowSummary()
        log.info "Pipeline completed at: $workflow.complete"
        log.info "Execution status: ${ workflow.success ? 'OK' : 'failed' }"
    }
}



