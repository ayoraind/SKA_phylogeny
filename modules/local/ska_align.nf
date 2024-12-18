process SKA_ALIGN {
    label 'process_medium'

    conda "bioconda::ska"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/ska:1.0--h9a82719_1' :
        'quay.io/biocontainers/ska:1.0--h9a82719_1' }"

    input:
    path(collected_skfs)

    output:
    path("*.aln")                 , emit: align_ch
    path "versions.yml"           , emit: versions_ch

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    ska align $args -v $collected_skfs

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        ska: \$(ska --version 2>&1 | sed 's/^.*ska //; s/ .*\$//')
    END_VERSIONS
    """
}

