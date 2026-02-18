process SKA_DISTANCE {
    label 'process_high'

    conda "bioconda::ska"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/ska:1.0--h9a82719_1' :
        'quay.io/biocontainers/ska:1.0--h9a82719_1' }"

    input:
    path(merged_file)

    output:
    path("*")                 , emit: distance_ch
    path "versions.yml"           , emit: versions_ch

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    ska distance $args $merged_file

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        ska: \$(ska --version 2>&1 | sed 's/^.*ska //; s/ .*\$//')
    END_VERSIONS
    """
}

