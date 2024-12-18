#!/usr/bin/env python

import argparse
import dendropy
import os
from Bio import SeqIO 
def parse_arguments():
    description = """
    A script to rescale branch lengths in a tree with substitutions per site based on the alignment length
    The length can be specified either by passing in the alignment with -a or by passing the length with -1
    """
    # parse all arguments
    parser = argparse.ArgumentParser(description=description,formatter_class=argparse.RawDescriptionHelpFormatter,)
    parser.add_argument('-t', '--tree_filepath', help='path to tree file', required = True)
    length_determiner = parser.add_mutually_exclusive_group(required = True)
    length_determiner.add_argument('-a', '--alignment_filepath', help='path to alignment file')
    length_determiner.add_argument('-l', '--alignment_length', help='length of alignment used to generate the tree')


    options = parser.parse_args()
    return options


def main(tree_filepath, alignment_length):
    # Read and validate tree file
    try:
        with open(tree_filepath, 'r') as f:
            tree_data = f.read()
        if not tree_data.strip():
            raise ValueError("Tree file is empty or invalid.")
        tree = dendropy.Tree.get_from_string(tree_data, schema='newick')
    except Exception as e:
        print(f"Error reading tree file: {e}")
        return

    # Rescale branch lengths
    for edge in tree.postorder_edge_iter():
        if edge.length:
            edge.length = round(edge.length * alignment_length)

    # Write the rescaled tree to a new file
    new_tree_filepath = os.path.join(
        os.path.dirname(tree_filepath),
        '.'.join(os.path.basename(tree_filepath).split('.')[:-1]) + '.rescaled.' + os.path.basename(tree_filepath).split('.')[-1]
    )
    with open(new_tree_filepath, 'w') as output_file:
        output_file.write(tree.as_string('newick'))

    



if __name__ == "__main__":
    options = parse_arguments()
    if options.alignment_filepath:
        alignment_length = len(next(SeqIO.parse(options.alignment_filepath, "fasta")).seq)
    else:
        alignment_length = int(options.alignment_length)
    main(options.tree_filepath, alignment_length)