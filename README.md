# SKA Phylogeny Pipeline

## Overview

The SKA Phylogeny Pipeline is a Nextflow-based workflow for performing phylogenetic analysis using Split Kmer Analysis (SKA). This pipeline integrates various tools and methods to generate phylogenetic trees from genomic data.

## Features

- Flexible input handling with CSV file support
- Optional SNP-sites analysis
- Multiple tree-building methods (IQ-TREE, RapidNJ, RAxML, FastME, FastTree)
- Scalable execution on various computing environments

## Requirements

- Nextflow (version 20.04.0 or later)
- Java 8 or later
- Docker or Singularity (for containerized execution)

## Usage

```bash
nextflow run main.nf [options]

Options
--input: Input CSV file with sample information (required)
--outdir: Output directory (default: './results')
--run_snpsites: Run SNP-sites (default: false)
--run_tree_building: Run tree building (default: false)
--tree_method: Tree building method (default: 'iqtree')
Options: 'iqtree', 'rapidnj', 'raxml', 'fastme', 'fasttree'
Flags
--help: Display help message
--version: Display version information

Input
The pipeline expects an input CSV file with the following format:

```
id,fastq_1,fastq_2,fasta
sample1,/path/to/sample1_R1.fastq.gz,/path/to/sample1_R2.fastq.gz,
sample2,,,/path/to/sample2.fasta
sample3,/path/to/sample3_R1.fastq.gz,,
```

Output
The pipeline generates the following outputs in the specified output directory:

SKA alignment files
SNP-sites output (if enabled)
Phylogenetic tree files (if tree building is enabled)
Examples
Basic run with default settings:

`nextflow run main.nf --input samples.csv -profile conda`

Run with SNP-sites and IQ-TREE:

`nextflow run main.nf --input samples.csv --run_snpsites --run_tree_building --tree_method iqtree -profile conda`

Run with RAxML tree building:

`nextflow run main.nf --input samples.csv --run_tree_building --tree_method raxml -profile conda`

Run without tree building:

`nextflow run main.nf --input samples.csv --run_snpsites -profile conda`

## Pipeline Steps
Input validation
SKA alignment
SNP-sites analysis (optional)
Tree building (optional)


## Citations
If you use this pipeline in your research, please cite:

Nextflow: Di Tommaso, P., Chatzou, M., Floden, E. W., Barja, P. P., Palumbo, E., & Notredame, C. (2017). Nextflow enables reproducible computational workflows. Nature Biotechnology, 35(4), 316-319.
SKA: [Harris SR. 2018. SKA: Split Kmer Analysis Toolkit for Bacterial Genomic Epidemiology. bioRxiv 453142 doi: https://doi.org/10.1101/453142](https://www.biorxiv.org/content/early/2018/10/25/453142)
SNP-sites: "SNP-sites: rapid efficient extraction of SNPs from multi-FASTA alignments", Andrew J. Page, Ben Taylor, Aidan J. Delaney, Jorge Soares, Torsten Seemann, Jacqueline A. Keane, Simon R. Harris, [Microbial Genomics 2(4), (2016)](http://mgen.microbiologyresearch.org/content/journal/mgen/10.1099/mgen.0.000056)
IQ-TREE/RapidNJ/RAxML/FastME/FastTree: L. Nguyen, H.A. Schmidt, A. von Haeseler, B.Q. Minh (2015)
  IQ-TREE: A Fast and Effective Stochastic Algorithm for Estimating Maximum-Likelihood Phylogenies.
  _Mol. Biol. and Evol._, 32:268-274. <https://doi.org/10.1093/molbev/msu300>
  FASTME: Lefort V, Desper R, Gascuel O. FastME 2.0: A Comprehensive, Accurate, and Fast Distance-Based Phylogeny Inference Program. Mol Biol Evol. 2015 Oct;32(10):2798-800. doi: 10.1093/molbev/msv150. Epub 2015 Jun 30. PMID: 26130081; PMCID: PMC4576710.
  FASTTREE: Price, M.N., Dehal, P.S., and Arkin, A.P. (2009) FastTree: Computing Large Minimum-Evolution Trees with Profiles instead of a Distance Matrix. Molecular Biology and Evolution 26:1641-1650, doi:10.1093/molbev/msp077
  RAPIDNJ: Rapid Neighbour Joining. Martin Simonsen, Thomas Mailund and Christian N. S. Pedersen. In Proceedings of the 8th Workshop in Algorithms in Bioinformatics (WABI), LNBI 5251, 113-122, Springer Verlag, October 2008. doi:10.1007/978-3-540-87361-7_10
  RAXMLNG: Alexey M. Kozlov, Diego Darriba, Tom&aacute;&scaron; Flouri, Benoit Morel, and Alexandros Stamatakis (2019)
**RAxML-NG: A fast, scalable, and user-friendly tool for maximum likelihood phylogenetic inference.** 
*Bioinformatics, 35 (21), 4453-4455* 
doi:[10.1093/bioinformatics/btz305](https://doi.org/10.1093/bioinformatics/btz305)
Afolayan et al. (2024). SKA Phylogeny Pipeline. GitHub repository: https://github.com/ayoraind/SKA_phylogeny

#### Credits and Acknowledgements
This is an ongoing project at the Microbial Genome Analysis Group, Institute for Infection Prevention and Hospital Epidemiology, Üniversitätsklinikum, Freiburg. The TAPIR (Tracking the Acquisition of Pathogens in Real-Time) project is funded by BMBF, Germany, and is led by [Dr. Sandra Reuter](https://www.uniklinik-freiburg.de/institute-for-infection-prevention-and-control/microbial-genome-analysis.html).