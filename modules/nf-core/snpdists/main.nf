process SNPDISTS {
    label 'process_low'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/snp-dists:0.8.2--h5bf99c6_0' :
        'biocontainers/snp-dists:0.8.2--h5bf99c6_0' }"

    input:
    path(alignment)

    output:
    path("*.tsv"), emit: tsv
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    
    """
    snp-dists \\
        $args \\
        $alignment > snp_dists.tsv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        snpdists: \$(snp-dists -v 2>&1 | sed 's/snp-dists //;')
    END_VERSIONS
    """
}
