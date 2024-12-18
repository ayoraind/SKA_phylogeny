#!/usr/bin/env python

import os
import sys
import errno
import argparse

def parse_args(args=None):
    Description = "Reformat ska_phylogeny samplesheet file and check its contents."
    Epilog = "Example usage: python check_samplesheet.py <FILE_IN> <FILE_OUT>"

    parser = argparse.ArgumentParser(description=Description, epilog=Epilog)
    parser.add_argument('FILE_IN', help="Input samplesheet file.")
    parser.add_argument("FILE_OUT", help="Output file.")
    return parser.parse_args()

def make_dir(path):
    if len(path) > 0:
        try:
            os.makedirs(path)
        except OSError as exception:
            if exception.errno != errno.EEXIST:
                raise exception

def print_error(error, context=''):
    print("ERROR: Please check samplesheet -> {}".format(error))
    if context:
        print("Context: {}".format(context))
    sys.exit(1)

def check_samplesheet(file_in, file_out):
    """
    This function checks that the samplesheet follows the following structure:

    id,fastq_1,fastq_2,fasta
    SAMPLE1,/path/to/sample1_R1.fastq.gz,/path/to/sample1_R2.fastq.gz,
    SAMPLE2,/path/to/sample2_R1.fastq.gz,/path/to/sample2_R2.fastq.gz,
    SAMPLE3,,,fasta
    """
    
    sample_run_dict = {}
    with open(file_in, "r") as fin:
        header = fin.readline().strip().split(",")
        if header != ['id', 'fastq_1', 'fastq_2', 'fasta']:
            print_error("Samplesheet header is incorrect, should be: id,fastq_1,fastq_2,fasta")

        for line in fin:
            lspl = [x.strip() for x in line.strip().split(",")]

            # Check valid number of columns per row
            if len(lspl) != len(header):
                print_error("Invalid number of columns (should be {})".format(len(header)), "Line: {}".format(line.strip()))

            id, fastq_1, fastq_2, fasta = lspl

            if id in sample_run_dict:
                print_error("Duplicate sample ID", "ID: {}".format(id))

            # Check if either FASTQ or FASTA is provided
            if (fastq_1 or fastq_2) and fasta:
                print_error("Both FASTQ and FASTA provided", "ID: {}".format(id))
            elif not (fastq_1 or fastq_2) and not fasta:
                print_error("Neither FASTQ nor FASTA provided", "ID: {}".format(id))

            # Check FASTQ files
            if fastq_1 or fastq_2:
                if fastq_1:
                    if not os.path.exists(fastq_1):
                        print_error("FASTQ_1 file does not exist", "File: {}".format(fastq_1))
                # if fastq_2:
                #     if not os.path.exists(fastq_2):
                #         print_error("FASTQ_2 file does not exist", "File: {}".format(fastq_2))
                # if bool(fastq_1) != bool(fastq_2):
                #     print_error("Both FASTQ_1 and FASTQ_2 must be provided if using FASTQ input", "ID: {}".format(id))

            # Check FASTA file
            if fasta:
                if not os.path.exists(fasta):
                    print_error("FASTA file does not exist", "File: {}".format(fasta))

            sample_run_dict[id] = {'fastq_1': fastq_1, 'fastq_2': fastq_2, 'fasta': fasta}

    # Write validated samplesheet
    out_dir = os.path.dirname(file_out)
    make_dir(out_dir)
    out_file = os.path.join(out_dir, "samplesheet.valid.csv")
    with open(out_file, "w") as fout:
        fout.write(",".join(['id', 'fastq_1', 'fastq_2', 'fasta']) + "\n")
        for sample in sorted(sample_run_dict.keys()):
            fout.write(",".join([sample, sample_run_dict[sample]['fastq_1'], sample_run_dict[sample]['fastq_2'], sample_run_dict[sample]['fasta']]) + "\n")

    print("Samplesheet checked and validated: {}".format(out_file))

def main(args=None):
    args = parse_args()
    check_samplesheet(args.FILE_IN, args.FILE_OUT)

if __name__ == "__main__":
    sys.exit(main())
