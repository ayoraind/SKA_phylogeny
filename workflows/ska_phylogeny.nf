include { SKA_ANALYSIS } from '../subworkflows/local/ska_analysis'
include { SNPSITES     } from '../modules/nf-core/snpsites/main'
include { PHYLOGENETIC_TREE } from '../subworkflows/local/phylogenetic_tree'
include { RESCALE_TREE } from '../modules/local/rescale_tree/main'

workflow SKA_PHYLOGENY {
    take:
    ch_input
    tree_method

    main:
    // SKA Analysis
    SKA_ANALYSIS(ch_input)

    // SNP-sites (optional)
    ch_alignment_for_tree = SKA_ANALYSIS.out.alignment
    ch_snpsites_versions = Channel.empty()
    if (params.run_snpsites) {
        SNPSITES(SKA_ANALYSIS.out.alignment)
        ch_alignment_for_tree = SNPSITES.out.snps_aln
        ch_snpsites_versions = SNPSITES.out.versions
    }

    // Generate phylogenetic tree (optional)
    ch_tree = Channel.empty()
    ch_tree_versions = Channel.empty()
    ch_rescale_tree_versions = Channel.empty()
    if (params.run_tree_building) {
        PHYLOGENETIC_TREE(ch_alignment_for_tree, tree_method)
        ch_tree = PHYLOGENETIC_TREE.out.tree
        ch_tree_versions = PHYLOGENETIC_TREE.out.versions
        // rescale tree
        RESCALE_TREE(ch_tree, ch_alignment_for_tree)
        ch_rescale_tree_versions = RESCALE_TREE.out.versions
    }

    emit:
    alignment = ch_alignment_for_tree
    tree = ch_tree
    distance_matrix = SKA_ANALYSIS.out.distance
    versions = SKA_ANALYSIS.out.versions
        .mix(ch_snpsites_versions.ifEmpty(Channel.empty()))
        .mix(ch_tree_versions.ifEmpty(Channel.empty()))
        .mix(ch_rescale_tree_versions.ifEmpty(Channel.empty()))
}
