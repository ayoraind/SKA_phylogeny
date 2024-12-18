#!/usr/bin/env nextflow

include { RAXMLNG } from '../../modules/nf-core/raxmlng/main'
include { FASTTREE } from '../../modules/nf-core/fasttree/main'
include { FASTME } from '../../modules/nf-core/fastme/main'
include { RAPIDNJ } from '../../modules/nf-core/rapidnj/main'
include { IQTREE } from '../../modules/nf-core/iqtree/main'

workflow PHYLOGENETIC_TREE {
    take:
    alignment   // channel: [ val(meta), path(alignment) ]
    tree_method // val: String specifying the tree method to use

    main:
    ch_versions = Channel.empty()

    // Choose the appropriate tree-building method based on the input
    switch(tree_method) {
        case 'raxml':
            RAXMLNG ( alignment )
            ch_tree = RAXMLNG.out.tree_ch
            ch_versions = ch_versions.mix(RAXMLNG.out.versions)
            break
        case 'fasttree':
            FASTTREE ( alignment )
            ch_tree = FASTTREE.out.tree_ch
            ch_versions = ch_versions.mix(FASTTREE.out.versions)
            break
        case 'fastme':
            FASTME ( alignment )
            ch_tree = FASTME.out.tree_ch
            ch_versions = ch_versions.mix(FASTME.out.versions)
            break
        case 'rapidnj':
            RAPIDNJ ( alignment )
            ch_tree = RAPIDNJ.out.tree_ch
            ch_versions = ch_versions.mix(RAPIDNJ.out.versions)
            break
        case 'iqtree':
            IQTREE ( alignment, "" )
            ch_tree = IQTREE.out.tree_ch
            ch_versions = ch_versions.mix(IQTREE.out.versions)
            break
        default:
            error "Unsupported tree method: ${tree_method}"
    }

    emit:
    tree     = ch_tree     // channel: [ val(meta), path(tree) ]
    versions = ch_versions // channel: [ path(versions.yml) ]
}
