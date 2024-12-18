include { SAMPLESHEET_CHECK } from '../../modules/local/samplesheet_check'

workflow INPUT_CHECK {
    take:
    samplesheet // file: /path/to/samplesheet.csv

    main:
    SAMPLESHEET_CHECK ( samplesheet )
        .csv
        .splitCsv ( header:true, sep:',' )
        .map { create_input_channel(it) }
        .set { input_data }

    emit:
    input_data                                     // channel: [ val(meta), [ reads ] ]
    versions = SAMPLESHEET_CHECK.out.versions // channel: [ versions.yml ]
}

// Function to get list of [ meta, [ reads ] ]
def create_input_channel(LinkedHashMap row) {
    // create meta map
    def meta = [:]
    meta.id = row.id
    meta.type = row.fasta ? 'fasta' : 'fastq'

    // add path(s) of the input file(s) to the meta map
    def reads = []
    if (meta.type == 'fastq') {
        if (!file(row.fastq_1).exists()) {
            exit 1, "ERROR: Please check input samplesheet -> Read 1 FastQ file does not exist!\n${row.fastq_1}"
        }
        if (!file(row.fastq_2).exists()) {
            exit 1, "ERROR: Please check input samplesheet -> Read 2 FastQ file does not exist!\n${row.fastq_2}"
        }
        reads = [ file(row.fastq_1), file(row.fastq_2) ]
    } else {
        if (!file(row.fasta).exists()) {
            exit 1, "ERROR: Please check input samplesheet -> FASTA file does not exist!\n${row.fasta}"
        }
        reads = [ file(row.fasta) ]
    }

    return [ meta, reads ]
}