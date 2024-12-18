process RESCALE_TREE {
    label 'process_single'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/python:3.8.3' :
        'quay.io/biocontainers/python:3.8.3' }"

    input:
    path tree
    path alignment

    output:
    path '*.rescale*'       , emit: tree_ch
    path "versions.yml", emit: versions

    script: // This script is bundled with the pipeline, in nf-core/rnaseq/bin/
    """
    rescale_tree_based_on_alignment_length.py -t $tree -a $alignment

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version | sed 's/Python //g')
        biopython: \$(python -c "import Bio; print(Bio.__version__)")
        dendropy: \$(python -c "import dendropy; print(dendropy.__version__)")
    END_VERSIONS
    """
}

