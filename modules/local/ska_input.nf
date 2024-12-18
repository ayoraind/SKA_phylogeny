process SKA_INPUT {
    tag "$meta.id"
    label 'process_medium'

    conda "bioconda::ska"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/ska:1.0--h9a82719_1' :
        'quay.io/biocontainers/ska:1.0--h9a82719_1' }"

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("${meta.id}.skf"), emit: skf_ch
    path "versions.yml"           , emit: versions_ch

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def input_files = meta.type == 'fastq' ? reads.join(' ') : reads
    """
    ska ${meta.type} $args $input_files -o $prefix > ${prefix}.log

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        ska: \$(ska --version 2>&1 | sed 's/^.*ska //; s/ .*\$//')
    END_VERSIONS
    """
}
