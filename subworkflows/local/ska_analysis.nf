include { SKA_INPUT   } from '../../modules/local/ska_input'
include { SKA_ALIGN } from '../../modules/local/ska_align'
include { SKA_MERGE   } from '../../modules/local/ska_merge'
include { SKA_DISTANCE   } from '../../modules/local/ska_distance'

workflow SKA_ANALYSIS {
    take:
    ch_input

    main:
    SKA_INPUT(ch_input)
    SKA_ALIGN(SKA_INPUT.out.skf_ch.map { meta, file -> file }.collect())  // convert tuple to path
    SKA_MERGE(SKA_INPUT.out.skf_ch.map { meta, file -> file }.collect())
    SKA_DISTANCE(SKA_MERGE.out.merged_ch)

    emit:
    alignment = SKA_ALIGN.out.align_ch
    merged   = SKA_MERGE.out.merged_ch
    distance = SKA_DISTANCE.out.distance_ch
    versions = SKA_INPUT.out.versions_ch.mix(SKA_ALIGN.out.versions_ch, SKA_MERGE.out.versions_ch, SKA_DISTANCE.out.versions_ch)
}
