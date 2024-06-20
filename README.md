[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10905863.svg)](https://doi.org/10.5281/zenodo.10905863)
# Fasta_Seq_Prepare_Bash
![alt text](https://github.com/raramayo/Fasta_Seq_Prepare_Bash/blob/main/Images/Fasta_Seq_Prepare_logo.png)

## Motivation

The main motivation for generating this script was to be able to
pre-process both transcriptome and/or proteome fasta files before
subjecting them to computational analysis.

By default the '-d' flag (Dust Gremlings) of the script will remove
characters that, if present in the sequence, have the potential to
interfere and or abort the processing of the file by certain software
packages. This is particularly true for InterProScan, which is extremely
sensitive to the presence of the character '*", which can usually be found
in ENSEMBL protein sequences. These characters, when found, are replaced by
the IUPAC 'X' (unknown).

In addition, the '-r', and '-s' flags, control the sorting of the
transcriptome and/or proteome fasta sequences from large to small (-r
flag), or from small to large (-s flag).

By default, the '-l' flag of the script removes transcripts that are '<='
than 150 nucleotides, and proteins that are '<=' than 50 amino-acids
residues, unless other values are assigned.

If desired, the '-u flag' of the script can also remove sequences that are
'>=' to a given size provided.

If activated, the '-f flag' of the script will remove sequences belonging to
the following biotypes:

```
  IG_D_gene,
  IG_J_gene,
  TR_D_gene, and
  TR_J_gene
```

as defined by the fasta headers of ENSEMBL transcriptome and/or protein
sequences. For this flag to work properly, these biotypes must have beeb
defined and present in the sequences headers. Without this information, no
removal can be performed.

A fasta file can also be split into files containing a given number of
sequences (e.g., 50000). This behavior (suppressed by default) is
controlled by the '-i' flag. This flag must be used with caution. For
example, if you select '10' for a fasta file containing 100,000 sequences,
you are requesting the script to generate 10,000 fasta files!. This option
is only valid for fasta files containing >= 2 sequences.

A transcriptome and/or proteome file can also be clustered using CD-HIT-EST
or CD-HIT, respectively. The clustering parameters can be modified by
editing the script directly. By default, the clustering parameters are very
stringent (i.e., 100% Identity and 100% Length). This option is controlled
by the '-c flag'. This behavior is suppressed by default.

If splitting and clustering of a given fasta file is simultaneously
requested, the file will be first clustered and then the resulting
clustered file will be split.

The '-x' flag, controls the number of cores used in the clustering and
sorting processes. To work in the clustering process CD-HIT multi-threading
with OpenMP must be enabled.

Finally, one can use the '-z' flag to control where the TMPDIR will be
written.

## Documentation

```
###########################################################################
ARAMAYO_LAB

This program is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option)
any later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
more details.

You should have received a copy of the GNU General Public License along
with this program. If not, see <https://www.gnu.org/licenses/>.

SCRIPT_NAME:                    Fasta_Seq_Prepare_v1.0.4.sh
SCRIPT_VERSION:                 1.0.4

USAGE: Fasta_Seq_Prepare_v1.0.4.sh
 -p Proteins_Fasta_File.fa      # REQUIRED (Proteins File)
                                  (if '-t' Not Provided)
 -t Transcripts_Fasta_File.fa   # REQUIRED (Transcripts File)
                                  (if '-p' Not Provided)
 -l Sequences Lower Size        # OPTIONAL
                                  (default=50 (proteins) | 150 (transcripts)
 -u Sequences Upper Size        # OPTIONAL (default = No Limit)
 -f Filter Biotypes             # OPTIONAL (default = No)
 -d Dust Gremlings              # OPTIONAL (default = Yes)
                                  (Yes: Converts * to X - proteins)
                                  (Yes: Converts * to n - nucleotides)
 -s Sort From Shorter to Larger # OPTIONAL (default = No)
                                  (Yes: Sequences will be sorted
                                  from shorter to larger)
 -r Sort From Larger to Shorter # OPTIONAL (default = No)
                                  (Yes: Sequences will be sorted
                                  from larger to shorter)
 -c Cluster Sequences           # OPTIONAL (default = No)
                                  (Yes: Requires cd-hit Installed)
 -w Fasta Width                 # OPTIONAL (default = 80)
 -i Split fasta file            # OPTIONAL (default = No = 1)
 -x Number of Cores             # OPTIONAL (default = 2)
 -z TMPDIR Location             # OPTIONAL (default=0='TMPDIR Run')

TYPICAL COMMANDS:
 Fasta_Seq_Prepare_v1.0.4.sh -p Proteins_Fasta_File.fa
 Fasta_Seq_Prepare_v1.0.4.sh -p Proteins_Fasta_File.fa -c yes
 Fasta_Seq_Prepare_v1.0.4.sh -t Transcripts_Fasta_File.fa
 Fasta_Seq_Prepare_v1.0.4.sh -t Transcripts_Fasta_File.fa -c yes

INPUT01:          -p FLAG       REQUIRED input ONLY if the '-t' flag
                                  associated file is not provided
INPUT01_FORMAT:                 Proteome Fasta File
INPUT01_DEFAULT:                No default

INPUT02:          -t FLAG       REQUIRED input ONLY if the '-p' flag
                                  associated file is not provided
INPUT02_FORMAT:                 Transcriptome Fasta File
INPUT02_DEFAULT:                No default

INPUT03:          -l FLAG       OPTIONAL input. Lower Size Filtering Value
INPUT03_FORMAT:                 Numeric
INPUT03_DEFAULT:                50 (proteins)
                                150 (transcripts)
                                1 = No Limit (Do Not Filter)
INPUT03_NOTES:
 If provided, this number will be used to reject sequences whose length are
equal to, or shorter than, the number provided.

  Note that the default value is a function of the class of file provided
(i.e., proteome or transcriptome). Also note that any numerical value will be accepted.

INPUT04:          -u FLAG       OPTIONAL input. Sequence Upper Size Filtering Value
INPUT04_FORMAT:                 Numeric
INPUT04_DEFAULT:                0 = No Limit (Do Not Filter)
INPUT04_NOTES:
 If provided, this number will be used to reject sequences whose length are
equal to, or larger than, the number provided.

 Note that any numerical value will be accepted..

INPUT05:          -f FLAG       OPTIONAL input. Filter Biotype
INPUT05_FORMAT:                 yes | no
INPUT05_DEFAULT:                no (Do Not Filter)
INPUT05_NOTES:
 If Activated, sequences belonging to the following biotypes will be
filtered out: IG_D_gene, IG_J_gene, TR_D_gene, and TR_J_gene.

INPUT06:          -d FLAG       OPTIONAL input. Dust Gremlings
INPUT06_FORMAT:                 yes | no
INPUT06_DEFAULT:                yes (Dust Gremlings)
INPUT06_NOTES:
 Dusting will convert:
  '*' to 'X' (for proteins).
  '*' to 'n' (for transcripts).

INPUT07:          -s FLAG       OPTIONAL input. Sort file
INPUT07_FORMAT:                 yes | no
INPUT07_DEFAULT:                no (Do Not Sort)
INPUT07_NOTES:
 If provided, sequences will be sorted from shorter to larger.

INPUT08:          -r FLAG       OPTIONAL input. Sort file
INPUT08_FORMAT:                 yes | no
INPUT08_DEFAULT:                no (Do Not Sort)
INPUT08_NOTES:
 If provided, sequences will be sorted from larger to shorter.

INPUT09:          -c FLAG       OPTIONAL input. Cluster Sequences
INPUT09_FORMAT:                 yes | no
INPUT09_DEFAULT:                no (Do Not Cluster)
INPUT09_NOTES:
 If provided, sequences will be clustered by cd-hit according to stringent
parameters (i.e., 100% Identity and 100% Length).

INPUT10:          -w FLAG       OPTIONAL input
INPUT10_FORMAT:                 Numeric
INPUT10_DEFAULT:                80
INPUT10_NOTES:
 The number sets the width of the sequence of the output fasta file.

INPUT11:          -i FLAG       OPTIONAL input
INPUT11_FORMAT:                 Numeric
INPUT11_DEFAULT:                1 (Do Not Split)
INPUT11_NOTES:
 Determines the number of fasta sequences requested to be present on
each resulting splitted file.

 This option is only valid for fasta files containing >= 2 sequences.

 Be careful with this flag. If you select '10' for a fasta file containing
100,000 sequences, you are requesting the script to generate 10,000 fasta files!

INPUT12:          -x FLAG       OPTIONAL input
INPUT12_FORMAT:                 Numeric
INPUT12_DEFAULT:                2
INPUT12_NOTES:
 The maximum number of cores requested should be equal to N-1; where N is
the total number of cores available in the computer performing the analysis.

INPUT13:          -z FLAG       OPTIONAL input
INPUT13_FORMAT:                 Numeric: '0' == TMPDIR Run | '1' == Local Run
INPUT13_DEFAULT:                '0' == TMPDIR Run
INPUT13_NOTES:
 '0' Processes the data in the $TMPDIR directory of the computer used or of
the node assigned by the SuperComputer scheduler.

 Processing the data in the $TMPDIR directory of the node assigned by the
SuperComputer scheduler reduces the possibility of file error generation
due to network traffic,

 '1' Processes the data in the same directory where the script is being run.

DEPENDENCIES:
 GNU AWK:       Required (https://www.gnu.org/software/gawk/)
 GNU COREUTILS: Required (https://www.gnu.org/software/coreutils/)
 CD-HIT:        Required if clustering is invoked
                 (https://github.com/weizhongli/cdhit)
                 (PMID: 16731699, and PMID: 23060610)

Author:                            Rodolfo Aramayo
WORK_EMAIL:                        raramayo@tamu.edu
PERSONAL_EMAIL:                    rodolfo@aramayo.org
###########################################################################
```

## Development/Testing Environment:

```
Distributor ID:       Apple, Inc.
Description:          Apple M1 Max
Release:              14.4.1
Codename:             Sonoma
```

```
Distributor ID:       Ubuntu
Description:          Ubuntu 22.04.3 LTS
Release:              22.04
Codename:             jammy
```

## Required Script Dependencies:
### GNU AWK (https://www.gnu.org/software/gawk/)
#### Version Number: 5.3.0, API 4.0

```
GNU Awk 5.3.0, API 4.0
Copyright (C) 1989, 1991-2023 Free Software Foundation.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.
```

### GNU COREUTILS (https://www.gnu.org/software/coreutils/)
#### Version Number: 8.30

```
(GNU coreutils) 9.4
Copyright (C) 2023 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Written by Richard M. Stallman and David MacKenzie.
```

### CDHIT (https://github.com/weizhongli/cdhit)
#### Version Number: 4.8.1

```
		====== CD-HIT version 4.8.1 (built on Jan 21 2024) ======

Usage: cd-hit [Options]

Options

   -i	input filename in fasta format, required, can be in .gz format
   -o	output filename, required
   -c	sequence identity threshold, default 0.9
 	this is the default cd-hit's "global sequence identity" calculated as:
 	number of identical amino acids or bases in alignment
 	divided by the full length of the shorter sequence
   -G	use global sequence identity, default 1
 	if set to 0, then use local sequence identity, calculated as :
 	number of identical amino acids or bases in alignment
 	divided by the length of the alignment
 	NOTE!!! don't use -G 0 unless you use alignment coverage controls
 	see options -aL, -AL, -aS, -AS
   -b	band_width of alignment, default 20
   -M	memory limit (in MB) for the program, default 800; 0 for unlimitted;
   -T	number of threads, default 1; with 0, all CPUs will be used
   -n	word_length, default 5, see user's guide for choosing it
   -l	length of throw_away_sequences, default 10
   -t	tolerance for redundance, default 2
   -d	length of description in .clstr file, default 20
 	if set to 0, it takes the fasta defline and stops at first space
   -s	length difference cutoff, default 0.0
 	if set to 0.9, the shorter sequences need to be
 	at least 90% length of the representative of the cluster
   -S	length difference cutoff in amino acid, default 999999
 	if set to 60, the length difference between the shorter sequences
 	and the representative of the cluster can not be bigger than 60
   -aL	alignment coverage for the longer sequence, default 0.0
 	if set to 0.9, the alignment must covers 90% of the sequence
   -AL	alignment coverage control for the longer sequence, default 99999999
 	if set to 60, and the length of the sequence is 400,
 	then the alignment must be >= 340 (400-60) residues
   -aS	alignment coverage for the shorter sequence, default 0.0
 	if set to 0.9, the alignment must covers 90% of the sequence
   -AS	alignment coverage control for the shorter sequence, default 99999999
 	if set to 60, and the length of the sequence is 400,
 	then the alignment must be >= 340 (400-60) residues
   -A	minimal alignment coverage control for the both sequences, default 0
 	alignment must cover >= this value for both sequences
   -uL	maximum unmatched percentage for the longer sequence, default 1.0
 	if set to 0.1, the unmatched region (excluding leading and tailing gaps)
 	must not be more than 10% of the sequence
   -uS	maximum unmatched percentage for the shorter sequence, default 1.0
 	if set to 0.1, the unmatched region (excluding leading and tailing gaps)
 	must not be more than 10% of the sequence
   -U	maximum unmatched length, default 99999999
 	if set to 10, the unmatched region (excluding leading and tailing gaps)
 	must not be more than 10 bases
   -B	1 or 0, default 0, by default, sequences are stored in RAM
 	if set to 1, sequence are stored on hard drive
 	!! No longer supported !!
   -p	1 or 0, default 0
 	if set to 1, print alignment overlap in .clstr file
   -g	1 or 0, default 0
 	by cd-hit's default algorithm, a sequence is clustered to the first
 	cluster that meet the threshold (fast cluster). If set to 1, the program
 	will cluster it into the most similar cluster that meet the threshold
 	(accurate but slow mode)
 	but either 1 or 0 won't change the representatives of final clusters
   -sc	sort clusters by size (number of sequences), default 0, output clusters by decreasing length
 	if set to 1, output clusters by decreasing size
   -sf	sort fasta/fastq by cluster size (number of sequences), default 0, no sorting
 	if set to 1, output sequences by decreasing cluster size
 	this can be very slow if the input is in .gz format
   -bak	write backup cluster file (1 or 0, default 0)
   -h	print this help

   Questions, bugs, contact Weizhong Li at liwz@sdsc.edu
   For updated versions and information, please visit: http://cd-hit.org
                                                    or https://github.com/weizhongli/cdhit

   cd-hit web server is also available from http://cd-hit.org

   If you find cd-hit useful, please kindly cite:

   "CD-HIT: a fast program for clustering and comparing large sets of protein or nucleotide sequences", Weizhong Li & Adam Godzik. Bioinformatics, (2006) 22:1658-1659
   "CD-HIT: accelerated for clustering the next generation sequencing data", Limin Fu, Beifang Niu, Zhengwei Zhu, Sitao Wu & Weizhong Li. Bioinformatics, (2012) 28:3150-3152
```
