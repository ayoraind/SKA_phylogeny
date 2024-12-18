process FASTME {
    tag "$alignment"
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/fastme:2.1.6.1--hec16e2b_1':
        'biocontainers/fastme:2.1.6.1--hec16e2b_1' }"

    input:
    path(alignment)

    output:
    path("*.nwk")       , emit: tree_ch
    path "versions.yml" , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args    = task.ext.args ?: ''
    def prefix  = task.ext.prefix ?: alignment
    """

    msaconverter -i $alignment -o output.phylip -p fasta -q phylip -t DNA

    fastme \\
        $args \\
        -i output.phylip \\
        -o ${prefix}.nwk \\
        -T $task.cpus \\
        -d F84


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        fastme: \$(fastme --version 2>&1 | awk '/FastME/{print \$2}')
        msaconverter: \$(msaconverter -h 2>&1 | grep V0 | sed 's/^V//;s/:\$//')
    END_VERSIONS
    """
}
