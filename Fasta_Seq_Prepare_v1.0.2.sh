#!/usr/bin/env bash

func_copyright ()
{
    cat <<COPYRIGHT

This program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not,
see <https://www.gnu.org/licenses/>.

COPYRIGHT
};

func_authors ()
{
    cat <<AUTHORS
Author:                            Rodolfo Aramayo
WORK_EMAIL:                        raramayo@tamu.edu
PERSONAL_EMAIL:                    rodolfo@aramayo.org
AUTHORS
};

func_usage()
{
    cat <<EOF
########################################################################################################################################################################################################
ARAMAYO_LAB
$(func_copyright)

SCRIPT_NAME:                       $(basename ${0})
SCRIPT_VERSION:                    ${version}

USAGE: $(basename ${0})
       -p Homo_sapiens.GRCh38.pep.all.fa               # REQUIRED if -t Not Provided (Proteins File - Proteome)
       -t Homo_sapiens.GRCh38.cds.all.fa               # REQUIRED if -p Not Provided (Transcripts File - Transcriptome)
       -l Sequences Lower Size                         # OPTIONAL (default = 50 - proteins | 150 - transcripts)
       -u Sequences Upper Size                         # OPTIONAL (default = No Limit)
       -f Filter Biotypes                              # OPTIONAL (default = No)
       -d Dust Gremlings                               # OPTIONAL (default = Yes)(Yes: Converts * to X - proteins and * to n - nucleotides)
       -s Sort File From Shorter to Larger             # OPTIONAL (default = No) (Yes: Sequences will be sorted from shorter to larger)
       -r Sort File From Larger to Shorter             # OPTIONAL (default = No) (Yes: Sequences will be sorted from larger to shorter)
       -c Cluster Sequences                            # OPTIONAL (default = No) (Yes: Requires cd-hit Installed)
       -w Fasta Width                                  # OPTIONAL (default = 80)
       -i Split fasta file                             # OPTIONAL (default = No = 1)
       -x Number of Cores                              # OPTIONAL (default = 2)
       -z TMPDIR Location                              # OPTIONAL (default=0='TMPDIR Run')

TYPICAL COMMANDS:
                                   $(basename ${0}) -p Homo_sapiens.GRCh38.pep.all.fa
                                   $(basename ${0}) -p Homo_sapiens.GRCh38.pep.all.fa -c yes
                                   $(basename ${0}) -t Homo_sapiens.GRCh38.cdna.all.fa
                                   $(basename ${0}) -t Homo_sapiens.GRCh38.cdna.all.fa -c yes

INPUT01:          -p FLAG          REQUIRED input ONLY if the '-t' flag associated file is not provided
INPUT01_FORMAT:                    Proteome Fasta File
INPUT01_DEFAULT:                   No default

INPUT02:          -t FLAG          REQUIRED input ONLY if the '-p' flag associated file is not provided
INPUT02_FORMAT:                    Transcriptome Fasta File
INPUT02_DEFAULT:                   No default

INPUT03:          -l FLAG          OPTIONAL input. Sequence Lower Size Filtering Value
INPUT03_FORMAT:                    Numeric
INPUT03_DEFAULT:                   50 (proteins) | 150 (transcripts) | 1 = No Limit (Do Not Filter)
INPUT03_NOTES:                     If provided, this number will be used to reject sequences whose length are equal to, or shorter than, the number provided
INPUT03_NOTES:                     Note that the default value is a function of the class of file provided (i.e., proteome or transcriptome)
INPUT03_NOTES:                     Also note that any numerical value will be accepted

INPUT04:          -u FLAG          OPTIONAL input. Sequence Upper Size Filtering Value
INPUT04_FORMAT:                    Numeric
INPUT04_DEFAULT:                   0 = No Limit (Do Not Filter)
INPUT04_NOTES:                     If provided, this number will be used to reject sequences whose length are equal to, or larger than, the number provided
INPUT04_NOTES:                     Note that any numerical value will be accepted

INPUT05:          -f FLAG          OPTIONAL input. Filter Biotype
INPUT05_FORMAT:                    yes | no
INPUT05_DEFAULT:                   no (Do Not Filter)
INPUT05_NOTES:                     If Activated, sequences belonging to the following biotypes will be filtered out: IG_D_gene, IG_J_gene, TR_D_gene, and TR_J_gene

INPUT06:          -d FLAG          OPTIONAL input. Dust Gremlings
INPUT06_FORMAT:                    yes | no
INPUT06_DEFAULT:                   yes (Dust Gremlings)
INPUT06_NOTES:                     Dusting will convert '*' to 'X' (for proteins), and '*' to 'n' (for transcripts)

INPUT07:          -s FLAG          OPTIONAL input. Sort file
INPUT07_FORMAT:                    yes | no
INPUT07_DEFAULT:                   no (Do Not Sort)
INPUT07_NOTES:                     If provided, sequences will be sorted from shorter to larger

INPUT08:          -r FLAG          OPTIONAL input. Sort file
INPUT08_FORMAT:                    yes | no
INPUT08_DEFAULT:                   no (Do Not Sort)
INPUT08_NOTES:                     If provided, sequences will be sorted from larger to shorter

INPUT09:          -c FLAG          OPTIONAL input. Cluster Sequences
INPUT09_FORMAT:                    yes | no
INPUT09_DEFAULT:                   no (Do Not Cluster)
INPUT09_NOTES:                     If provided, sequences will be clustered by cd-hit according to stringent parameters

INPUT10:          -w FLAG          OPTIONAL input
INPUT10_FORMAT:                    Numeric
INPUT10_DEFAULT:                   80
INPUT10_NOTES:                     The number sets the width of the output fasta file

INPUT11:          -i FLAG          OPTIONAL input
INPUT11_FORMAT:                    Numeric
INPUT11_DEFAULT:                   1 (Do Not Split)
INPUT11_NOTES:                     Determines the number of fasta sequences requested to be present on each resulting splitted file
INPUT11_NOTES:                     This option is only valid for fasta files containing >= 2 files

INPUT12:          -x FLAG          OPTIONAL input
INPUT12_FORMAT:                    Numeric
INPUT12_DEFAULT:                   2
INPUT12_NOTES:                     The maximum number of cores requested should be equal to N-1; where N is the total number of cores available in the computer performing the analysis
INPUT12_NOTES:                     Number of Cores

INPUT13:          -z FLAG          OPTIONAL input
INPUT13_FORMAT:                    Numeric: 0 == TMPDIR Run | 1 == Normal Run
INPUT13_DEFAULT:                   0 == TMPDIR Run
INPUT13_NOTES:                     0 Processes the data in the \$TMPDIR directory of the computer used or of the node assigned by the SuperComputer scheduler
INPUT13_NOTES:                     Processing the data in the \$TMPDIR directory of the node assigned by the SuperComputer scheduler reduces the possibility of file error generation due to network traffic
INPUT13_NOTES:                     1 Processes the data in the same directory where the script is being run

DEPENDENCIES:                      GNU AWK:       Required (https://www.gnu.org/software/gawk/)
                                   GNU COREUTILS: Required (https://www.gnu.org/software/coreutils/)
                                   CD-HIT:        Required if clustering is invoked (https://github.com/weizhongli/cdhit; PMID: 16731699; PMID: 23060610)

$(func_authors)
########################################################################################################################################################################################################
EOF
};

## Defining_Script_Current_Version
version="1.0.2";

## Defining_Script_Initial_Version_Data (date '+DATE:%Y/%m/%d%tTIME:%R')
version_date_initial="DATE:2020/08/17   TIME:00:00";

## Defining_Script_Current_Version_Data (date '+DATE:%Y/%m/%d%tTIME:%R')
version_date_current="DATE:2024/04/04	TIME:16:58";

## Testing_Script_Input
## Is the number of arguments null?
if [[ $# -eq 0 ]];
then
    echo -e "\nPlease enter required arguments";
    func_usage;
    exit 1;
fi

while true;
do
    case $1 in
        -h|--h|-help|--help|-\?|--\?)
            func_usage;
            exit 0;
            ;;
        -v|--v|-version|--version)
            printf "Version: $version %s\n" >&2;
            exit 0;
            ;;
        -p|--p|-proteome|--proteome)
            proteinsfile="$2";
            shift;
            ;;
        -t|--t|-transcriptome|--transcriptome)
            transcriptsfile="$2";
            shift;
            ;;
        -l|--l|-lower|--lower)
            seqlowersize="$2";
            shift;
            ;;
        -u|--u|-upper|--upper)
            sequppersize="$2";
            shift;
            ;;
        -f|--f|-filter|--filter)
            filterbiotypes="$2";
            shift;
            ;;
        -d|--d|-dust|--dust)
            dustgremlings="$2";
            shift;
            ;;
        -s|--s|-sort|--sort)
            sortshortertolarger="$2";
            shift;
            ;;
        -r|--r|-reverse|--reverse)
            sortlargertoshorter="$2";
            shift;
            ;;
        -c|--c|-cluster|--cluster)
            clustersequences="$2";
            shift;
            ;;
        -w|--w|-width|--width)
            fasta_width="$2";
            shift;
            ;;
        -i|--i|-split|--split)
            var_split_file="$2";
            shift;
            ;;
        -x|--x|-xcores|--xcores)
            var_ncores="$2";
            shift;
            ;;
	-z|--z|-tmp-dir|--tmp-dir)
            var_tmp_dir="$2";
            shift;
            ;;
        -?*)
            printf '\nWARNNING: Unknown Option (ignored): %s\n\n' "$1" >&2;
            func_usage;
            exit 0;
            ;;
        :)
            printf '\nWARNING: Invalid Option (ignored): %s\n\n' "$1" >&2;
            func_usage;
            exit 0;
            ;;
        \?)
            printf '\nWARNING: Invalid Option (ignored): %s\n\n' "$1" >&2;
            func_usage;
            exit 0;
            ;;
        *)  # Should not get here
            break;
            exit 1;
            ;;
    esac
    shift;
done

## Processing: -p and -t Flags
if [[ ! -z $proteinsfile ]];
then
    INFILE01="$proteinsfile";
    var_INFILE01="proteins_file";
else
    var_INFILE01="transcripts_file";
fi
if [[ $var_INFILE01 == "proteins_file" ]];
then
    if [[ ! -f $proteinsfile ]];
    then
	echo "Please provide a proteome fasta file";
	func_usage;
	exit 1;
    fi
fi
if [[ ! -z $transcriptsfile ]];
then
    INFILE01="$transcriptsfile";
    var_INFILE01="transcripts_file";
else
    var_INFILE01="proteins_file";
fi
if [[ $var_INFILE01 == "transcripts_file" ]];
then
    if [[ ! -f $transcriptsfile ]];
    then
	echo "Please provide a transcriptome fasta file";
	func_usage;
	exit 1;
    fi
fi
if [[ ! -z $proteinsfile && ! -z $transcriptsfile ]];
then
    echo -e "\nPlease provide either a protein of a transcript file, but not both";
    func_usage;
    exit 1;
fi

## Processing: -l Flag
if [[ -z $seqlowersize ]];
then
    if [[ $var_INFILE01 == "proteins_file" ]];
    then
	seqlowersize="${seqlowersize:=50}";
    fi

    if [[ $var_INFILE01 == "transcripts_file" ]];
    then
	seqlowersize="${seqlowersize:=150}";
    fi
else
    var_posix_regcomp="^[0-9]+$";
    if ! [[ $seqlowersize =~ $var_posix_regcomp ]];
    then
	echo -e "\nPlease enter a numeric argument for lower size sequences";
	func_usage;
	exit 1;
    fi
    seqlowersize="${seqlowersize:=1}";
fi
if [[ $seqlowersize == "50" || $seqlowersize == "150" ]];
then
    var_seqlowersize="l_Off";
else
    var_seqlowersize="l_"$seqlowersize"";
fi

## Processing: -u Flag
if [[ -z $sequppersize ]];
then
    sequppersize="${sequppersize:=0}";
else
    var_posix_regcomp="^[0-9]+$";
    if ! [[ $sequppersize =~ $var_posix_regcomp ]];
    then
	echo -e "\nPlease enter a numeric argument for upper size sequences";
	func_usage;
	exit 1;
    fi
    sequppersize="$sequppersize";
fi
if [[ $sequppersize -eq 0 ]];
then
    var_sequppersize="unlimited_sequppersize";
else
    var_sequppersize="limited_sequppersize";
fi

## Processing: -f Flag
if [[ -z $filterbiotypes ]];
then
    filterbiotypes=${filterbiotypes:=no};
fi
if [[ $filterbiotypes == "n" ||  $filterbiotypes == "N" || $filterbiotypes == "no" || $filterbiotypes == "No" || $filterbiotypes == "NO" ]];
then
    var_filterbiotypes="do_not_filter_biotypes";
elif
    [[ $filterbiotypes == "y" || $filterbiotypes == "Y" || $filterbiotypes == "yes" || $filterbiotypes == "Yes" || $filterbiotypes == "YES" ]];
then
    var_filterbiotypes="filter_biotypes";
else
    echo -e "Check Spelling of the '-f' Flag";
    func_usage;
    exit 1;
fi

## Processing: -d Flag
if [[ -z $dustgremlings ]];
then
    dustgremlings="${dustgremlings:=yes}";
fi
if [[ $dustgremlings == "y" || $dustgremlings == "Y" || $dustgremlings == "yes" || $dustgremlings == "Yes" || $dustgremlings == "YES" ]];
then
    var_dustgremlings="dust_gremlings";
elif
    [[ $dustgremlings == "n" || $dustgremlings == "N" || $dustgremlings == "no" || $dustgremlings == "No" || $dustgremlings == "NO" ]];
then
    var_dustgremlings="do_not_dust_gremlings";
else
    echo -e "Check Spelling of the '-d' Flag";
    func_usage;
    exit 1;
fi

## Processing: -s Flag
if [[ -z $sortshortertolarger ]];
then
    sortshortertolarger="${sortshortertolarger:=no}";
fi
if [[ $sortshortertolarger == "n" || $sortshortertolarger == "N" || $sortshortertolarger == "no" || $sortshortertolarger == "No" || $sortshortertolarger == "NO" ]];
then
    var_sortshortertolarger="do_not_sort_shorter_to_larger";
elif
    [[ $sortshortertolarger == "y" || $sortshortertolarger == "Y" || $sortshortertolarger == "yes" || $sortshortertolarger == "Yes" || $sortshortertolarger == "YES" ]];
then
    var_sortshortertolarger="sort_shorter_to_larger";
else
    echo -e "Check Spelling of the '-s' Flag";
    func_usage;
    exit 1;
fi

## Processing: -r Flag
if [[ -z $sortlargertoshorter ]];
then
    sortlargertoshorter="${sortlargertoshorter:=no}";
fi
if [[ $sortlargertoshorter == "n" || $sortlargertoshorter == "N" || $sortlargertoshorter == "no" || $sortlargertoshorter == "No" || $sortlargertoshorter == "NO" ]];
then
    var_sortlargertoshorter="do_not_sort_larger_to_shorter";
elif
    [[ $sortlargertoshorter == "y" || $sortlargertoshorter == "Y" || $sortlargertoshorter == "yes" || $sortlargertoshorter == "Yes" || $sortlargertoshorter == "YES" ]];
then
    var_sortlargertoshorter="sort_larger_to_shorter";
else
    echo -e "Check Spelling of the '-r' Flag";
    func_usage;
    exit 1;
fi
if [[ $var_sortshortertolarger == "sort_shorter_to_larger" && $var_sortlargertoshorter == "sort_larger_to_shorter" ]];
then
    echo "You cannot request to sort from larger to smaller and smaller to larger at the same time";
    func_usage;
    exit 1;
fi

## Processing: -c Flag
if [[ -z $clustersequences ]];
then
    clustersequences="${clustersequences:=no}";
fi
if [[ $clustersequences == "n" || $clustersequences == "N" || $clustersequences == "no" || $clustersequences == "No" || $clustersequences == "NO" ]];
then
    var_clustersequences="do_not_cluster_sequences";
elif
    [[ $clustersequences == "y" || $clustersequences == "Y" || $clustersequences == "yes" || $clustersequences == "Yes" || $clustersequences == "YES" ]];
then
    var_clustersequences="cluster_sequences";
else
    echo -e "Check Spelling of the '-c' Flag";
    func_usage;
    exit 1;
fi

## Processing: -w Flag
## Assigning Width Outputted Fasta File
if [[ -z $fasta_width ]];
then
    fasta_width="${fasta_width:=80}";
fi

## Processing: -i Flag
## Assigning Splitting of the Outputted Fasta File
if [[ -z $var_split_file ]];
then
    var_split_file="${var_split_file:=1}";
else
    var_posix_regcomp="^[0-9]+$";
    if ! [[ $var_split_file =~ $var_posix_regcomp ]];
    then
	echo -e "\nPlease enter a numeric argument for splitting the file";
	func_usage;
	exit 1;
    fi
fi

## Processing: -x Flag
## Assigning Number of Cores
if [[ -z $var_ncores ]];
then
    var_ncores="${var_ncores:=2}";
fi
## Checking_Processors_Number
var_nproc=$(nproc --all);
if [[ $var_ncores -ge $var_nproc ]];
then
    var_ncores=$(( $var_nproc - 2 ));
elif [[ $var_ncores -eq $var_nproc ]];
then
    var_ncores=$(( "$NPROC" - 2 ));
else [[ $var_ncores -lt $var_nproc ]];
fi

## Processing '-z' Flag
## Determining Where The TMPDIR Will Be Generated
if [[ -z $var_tmp_dir ]];
then
    var_tmp_dir="${var_tmp_dir:=0}";
fi

if [[ ${var_tmp_dir} -ne 0 ]] && [[ ${var_tmp_dir} -ne 1 ]];
then
    var_tmp_dir="0";
fi

## Generating Directories
if [[ ! -d ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir ]];
then
    mkdir ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir;
else
    rm ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/* &>/dev/null;
fi

if [[ -d ./${INFILE01%.fa}_Fasta_Seq_Prepare.tmp ]];
then
    rm -fr ./${INFILE01%.fa}_Fasta_Seq_Prepare.tmp;
fi

## Generating/Cleaning TMP Data Directory
if [[ $var_tmp_dir -eq 0 ]];
then
    ## Defining Script TMP Data Directory
    var_script_tmp_data_dir="$(pwd)/${INFILE01%.fa}_Fasta_Seq_Prepare.tmp";
    export var_script_tmp_data_dir="$(pwd)/${INFILE01%.fa}_Fasta_Seq_Prepare.tmp";

    if [[ -d $(basename "$var_script_tmp_data_dir") ]];
    then
	rm -fr $(basename "$var_script_tmp_data_dir");
    fi

    if [[ -z $TMPDIR ]];
    then
        ## echo "TMPDIR not defined";
        TMP=$(mktemp -d -p "$TMP"); ## &> /dev/null);
        var_script_tmp_data_dir="$TMP";
        export  var_script_tmp_data_dir="$TMP";
    fi

    if [[ ! -z $TMPDIR ]];
    then
        ## echo "TMPDIR defined";
        TMP=$(mktemp -d -p "$TMPDIR"); ## &> /dev/null);
        var_script_tmp_data_dir="$TMP";
        export  var_script_tmp_data_dir="$TMP";

    fi
fi

if [[ $var_tmp_dir -eq 1 ]];
then
    ## Defining Script TMP Data Directory
    var_script_tmp_data_dir="$(pwd)/${INFILE01%.fa}_Fasta_Seq_Prepare.tmp";
    export var_script_tmp_data_dir="$(pwd)/${INFILE01%.fa}_Fasta_Seq_Prepare.tmp";

    if [[ ! -d $(basename "$var_script_tmp_data_dir") ]];
    then
        mkdir $(basename "$var_script_tmp_data_dir");
    else
        rm -fr $(basename "$var_script_tmp_data_dir");
        mkdir $(basename "$var_script_tmp_data_dir");
    fi
fi

## Initializing_Log_File
time_execution_start=$(date +%s);
echo -e "Starting Processing on: "$(date)"" \
     > ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;

## Verifying_Software_Dependency_Existence
echo -e "Verifying Software Dependency Existence on: "$(date)"" \
     >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
## Determining_Current_Computer_Platform
osname=$(uname -s);
cputype=$(uname -m);
case "$osname"-"$cputype" in
    Linux-x86_64 )           plt=Linux ;;
    Darwin-x86_64 )          plt=Darwin ;;
    Darwin-*arm* )           plt=Silicon ;;
    CYGWIN_NT-* | MINGW*-* ) plt=CYGWIN_NT ;;
    Linux-*arm* )            plt=ARM ;;
esac
## Determining_GNU_Bash_Version
if [[ ${BASH_VERSINFO:-0} -ge 4 ]];
then
    echo "GNU_BASH version 4 or higher is Installed" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
else
    echo "GNU_BASH version 4 or higher is Not Installed";
    echo "Please Install GNU_BASH version 4 or higher";
    rm -fr "$var_script_final_data_dir";
    rm -fr "$var_script_tmp_data_dir";
    func_usage;
    exit 1;
fi
## Testing_GNU_Awk_Installation
type gawk &> /dev/null;
var_sde=$(echo $?);
if [[ $var_sde -eq 0 ]];
then
    echo "GNU_AWK is Installed" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
else
    echo "GNU_AWK is Not Installed";
    echo "Please Install GNU_AWK";
    rm -fr "$var_script_final_data_dir";
    rm -fr "$var_script_tmp_data_dir";
    func_usage;
    exit 1;
fi

if [[ $var_clustersequences == "cluster_sequences" ]];
then
    ## cd-hit
    type cd-hit &> /dev/null;
    var_sde="$(echo $?)";
    if [[ $var_sde -eq 0 ]];
    then
        echo "cd-hit is Installed" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
    else
        echo "cd-hit is Not Installed";
	func_usage;
        exit 1;
    fi
fi

echo -e "Software Dependencies Verified on: "$(date)"\n" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
echo -e "Script Running on: "$osname", "$cputype"\n" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;

## set LC_ALL to "C"
export LC_ALL="C";

## Defining Functions
func_fasta_formatter(){
    ## Fasta Formatter-like AWK code. It is a bit slower but does not have fasta_formatter dependencies
    ## Convert                 to Fasta Format  : awk -F "\t" '{print $1 "\n" $(NF-1)}'
    ## Convert [\074] [<]      to [\076] [>]    : gsub(/\074/,"\076")
    ## Convert [\075] [=]      to [\040] [space]: gsub(/\075/,"\040")
    ## Convert [\137\137] [__] to [\075] [=]    : gsub(/\137\137/,"\075")
    ## Fold Fasta Sequence                      : awk -v wid="$fasta_width" -v FS= '/^>/{print;next}{for (i=0;i<=NF/wid;i++) {for (j=1;j<=wid;j++) printf "%s", $(i*wid +j); print ""}}'
    ## Delete any empty spaces, if any          : sed '/^$/d'

    awk -F "\t" '{print $1 "\n" $(NF-1)}' \
	$1 | \
	awk -F "\t" -v OFS="\t" '{gsub(/\074/,"\076");gsub(/\075/,"\040");gsub(/\137\137/,"\075");print $0}' | \
	awk -v wid="$fasta_width" -v FS= '/^>/{print;next}{for (i=0;i<=NF/wid;i++) {for (j=1;j<=wid;j++) printf "%s", $(i*wid +j); print ""}}' | \
	sed '/^$/d' \
	    > $2;
};

func_time_execution_stop (){
    time_execution_stop=$(date +%s);
    echo -e "\nFinishing Processing on: "$(date)"" \
	 >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
    echo -e "Script Runtime (sec): $(echo "$time_execution_stop"-"$time_execution_start"|bc -l) seconds" \
	 >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
    echo -e "Script Runtime (min): $(echo "scale=2;($time_execution_stop"-"$time_execution_start)/60"|bc -l) minutes" \
	 >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
    echo -e "Script Runtime (hs): $(echo "scale=2;(($time_execution_stop"-"$time_execution_start)/60)/60"|bc -l) hours" \
	 >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
};

## START
echo -e "Command Issued Was:" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
if [[ $var_INFILE01 == "proteins_file" ]];
then
    echo -e "\tFile Type: Proteome" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
else
    echo -e "\tFile Type: Transcriptome" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
fi
if [[ $var_seqlowersize == "l_Off" && $var_INFILE01 == "proteins_file" ]];
then
    echo -e "\t-l Flag: Sequence Lower Size: 50 aar" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
fi
if [[ $var_seqlowersize == "l_Off" && $var_INFILE01 == "transcripts_file" ]];
then
    echo -e "\t-l Flag: Sequence Lower Size: 150 nt" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;

fi
if [[ $var_seqlowersize != "l_Off" ]];
then
    if [[ $var_INFILE01 == "proteins_file" ]];
    then
	echo -e "\t-l Flag: Sequence Lower Size: "$seqlowersize" aar" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
    fi
    if [[ $var_INFILE01 == "transcripts_file" ]];
    then
	echo -e "\t-l Flag: Sequence Lower Size: "$seqlowersize" nt" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
    fi
fi
if [[ $var_sequppersize == "unlimited_sequppersize" ]];
then
    echo -e "\t-u Flag: Sequence Upper Size: No Limit" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
else
    echo -e "\t-u Flag: Sequence Upper Size: "$sequppersize"" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
fi
if [[ $var_filterbiotypes == "filter_biotypes" ]];
then
    echo -e "\t-f Flag: Filter Biotypes: Yes" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
else
    echo -e "\t-f Flag: Filter Biotypes: No" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
fi
if [[ $var_dustgremlings == "dust_gremlings" ]];
then
    echo -e "\t-d Flag: Dust Gremlings: Yes" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
else
    echo -e "\t-d Flag: Dust Gremlings: No" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
fi
if [[ $var_sortshortertolarger == "do_not_sort_shorter_to_larger" ]];
then
    echo -e "\t-s Flag: Sort File (Shorter to Larger): No" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
else
    echo -e "\t-s Flag: Sort File (Shorter to Larger): Yes" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
fi
if [[ $var_sortlargertoshorter == "do_not_sort_larger_to_shorter" ]];
then
    echo -e "\t-r Flag: Sort File (Larger to Shorter): No" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
else
    echo -e "\t-r Flag: Sort File (Larger to Shorter): Yes" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
fi
if [[ $var_clustersequences == "do_not_cluster_sequences" ]];
then
    echo -e "\t-c Flag: Cluster Sequences: No" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
else
    echo -e "\t-c Flag: Cluster Sequences: Yes" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
fi
## Checking if the fasta file can be splitted
if [[ $var_split_file -eq 1 ]];
then
    echo -e "\t-i Flag: Fasta File Splitting was not Requested" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
else
    echo -e "\t-i Flag: Fasta File Splitting was Requested with files containing "$var_split_file" sequence(s) each" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
fi
if [[ $var_split_file -gt 1 && $(grep -c --max-count=2 ">" ${INFILE01}) -eq 1 ]];
then
    echo -e "\t-i Flag: But...The Fasta file you have provided cannot be splitted" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
fi
## Checking where the TMPDIR will be generated
if [[ $var_tmp_dir -eq 0 ]];
then
    echo -e "\t-z Flag: TMPDIR Run for the TMPDIR was Requested" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
else
    echo -e "\t-z Flag: Normal Run for the TMPDIR was Requested" >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
fi

##  Remove empty lines (if present)
## sed --in-place=.bkup '/^$/d' ${INFILE01};
grep -P "^$" $INFILE01 &> /dev/null;
var_sde=$(echo $?);
if [[ $var_sde -eq 0 ]];
then
    sed '/^$/d' $INFILE01 > $var_script_tmp_data_dir/0000_${INFILE01};
else
    ln -s $(pwd)/${INFILE01} $var_script_tmp_data_dir/0000_${INFILE01};
fi

## Convert  [\076] [>]     to  [\074] [<];
## Convert  [\075] [=]     to  [\137\137] [__];
## Convert  [\040] [space] to  [\075] [=];
## Convert ^[\074] [<]    to ^[\076] [>];
## Calculate sequences lengths;
## Filter sequences by size (if so requested)
awk -F "\t" -v OFS="\t" '{gsub(/\076/,"\074",$1);gsub(/\075/,"\137\137",$1);gsub(/\040/,"\075",$1);gsub(/^\074/,"\076",$1);print $0}' \
    $var_script_tmp_data_dir/0000_${INFILE01} | \
    awk -F "\t" -v OFS="\t" 'BEGIN{RS=">"}NR>1{sub("\n","\t"); gsub("\n",""); print RS$0 "\t" length($(NF))}' | \
    awk -F "\t" -v SEQLS=$seqlowersize '{if ($NF >= SEQLS) print $0}' \
	> $var_script_tmp_data_dir/0001_${INFILE01};

## -u Flag
if [[ $var_sequppersize == "limited_sequppersize" ]];
then
    awk -F "\t" -v SeqUpperSize="$sequppersize" '{if(length($2) <= SeqUpperSize) print $0}' \
	$var_script_tmp_data_dir/0001_${INFILE01} \
	> $var_script_tmp_data_dir/0002_${INFILE01};
else
    cp \
	$var_script_tmp_data_dir/0001_${INFILE01} \
	$var_script_tmp_data_dir/0002_${INFILE01};
fi

## -f Flag
if [[ $var_filterbiotypes == "do_not_filter_biotypes" ]];
then
    cp \
	$var_script_tmp_data_dir/0002_${INFILE01} \
	$var_script_tmp_data_dir/0003_${INFILE01};
else
    grep -Pv "gene_biotype:IG_D_gene|gene_biotype:IG_J_gene|gene_biotype:TR_D_gene|gene_biotype:TR_J_gene" \
	 $var_script_tmp_data_dir/0002_${INFILE01} \
	 > $var_script_tmp_data_dir/0003_${INFILE01};
fi

## Convert '*' (052) to 'X' (130)
## -d Flag
if [[ $var_dustgremlings == "dust_gremlings" ]];
then
    awk -F "\t" -v OFS="\t" '{gsub(/\052/, "\130", $2); print}' \
	$var_script_tmp_data_dir/0003_${INFILE01} \
	> $var_script_tmp_data_dir/0004_${INFILE01};
else
    cp \
	$var_script_tmp_data_dir/0003_${INFILE01} \
	$var_script_tmp_data_dir/0004_${INFILE01};
fi

## -s Flag
if [[ $var_sortshortertolarger == "do_not_sort_shorter_to_larger" ]];
then
    cp \
	$var_script_tmp_data_dir/0004_${INFILE01} \
	$var_script_tmp_data_dir/0005_${INFILE01};
else
    sort --parallel="$var_ncores" -k3n \
	 $var_script_tmp_data_dir/0004_${INFILE01} \
	 > $var_script_tmp_data_dir/0005_${INFILE01};
fi

## -r Flag
if [[ $var_sortlargertoshorter == "do_not_sort_larger_to_shorter" ]];
then
    cp \
	$var_script_tmp_data_dir/0005_${INFILE01} \
	$var_script_tmp_data_dir/0006_${INFILE01};
else
    sort --parallel="$var_ncores" -k3nr \
	 $var_script_tmp_data_dir/0005_${INFILE01} \
	 > $var_script_tmp_data_dir/0006_${INFILE01};
fi

## -c Flag
## Do Not Cluster and Do Not Split
if [[ $var_clustersequences == "do_not_cluster_sequences" && $var_split_file -eq 1 ]];
then
    func_fasta_formatter $var_script_tmp_data_dir/0006_${INFILE01} $var_script_tmp_data_dir/0007_${INFILE01};
    mv $var_script_tmp_data_dir/0007_${INFILE01} \
       ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.fa;
    rm -fr $var_script_tmp_data_dir;
    func_time_execution_stop;
    exit 0;
fi

## Do Not Cluster and Do Split
if [[ $var_clustersequences == "do_not_cluster_sequences" && $var_split_file -ne 1 ]];
then
    split -d --suffix-length=6 --elide-empty-files --lines=$var_split_file  $var_script_tmp_data_dir/0006_${INFILE01} $var_script_tmp_data_dir/0006_split_;
    find $var_script_tmp_data_dir -type f -name 0006_split_\* | sort -n > $var_script_tmp_data_dir/0007_retrieve_uniprot_ids_array;
    readarray -t lines < $var_script_tmp_data_dir/0007_retrieve_uniprot_ids_array;
    count="1";
    for i in ${lines[@]};
    do
	func_fasta_formatter ${i} ${var_script_tmp_data_dir}/0008_$(basename ${i});
	cp ${var_script_tmp_data_dir}/0008_$(basename ${i}) ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_"${count}"_Fasta_Seq_Prep.fa;
	((count++));
    done
    rm -fr $var_script_tmp_data_dir;
    func_time_execution_stop;
    exit 0;
fi

## Do Cluster and Do Not Split
if [[ $var_clustersequences == "cluster_sequences" && $var_split_file -eq 1 ]];
then
    ## Proteome Clustering
    if [[ $var_INFILE01 == "proteins_file" ]];
    then
	func_fasta_formatter $var_script_tmp_data_dir/0006_${INFILE01} $var_script_tmp_data_dir/0007_${INFILE01};
	cd-hit \
            -c 1.0 -n 5 -p 1 -g 1 -T $var_ncores -d 300 -M 0 \
	    -i $var_script_tmp_data_dir/0007_${INFILE01} \
	    -o $var_script_tmp_data_dir/0008_${INFILE01} \
	    &> $var_script_tmp_data_dir/0008_${INFILE01}.log;
	mv $var_script_tmp_data_dir/0008_${INFILE01} ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.fa;
	cp $var_script_tmp_data_dir/0008_${INFILE01}.clstr ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.clstr;
	echo -e "\nCD-HIT Clustering Log" \
	     >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
	cat $var_script_tmp_data_dir/0008_${INFILE01%}.log \
	    >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
	echo -e "================================================================" \
	     >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
	rm -fr $var_script_tmp_data_dir;
	func_time_execution_stop;
	exit 0;
    fi
    ## Transcriptome Clustering
    if [[ $var_INFILE01 == "transcripts_file" ]];
    then
	func_fasta_formatter $var_script_tmp_data_dir/0006_${INFILE01} $var_script_tmp_data_dir/0007_${INFILE01};
	cd-hit-est \
            -c 1.0 -n 8 -r 1 -p 1 -g 1 -T $var_ncores -d 40 -M 0 \
	    -i $var_script_tmp_data_dir/0007_${INFILE01} \
	    -o $var_script_tmp_data_dir/0008_${INFILE01} \
	    &> $var_script_tmp_data_dir/0008_${INFILE01}.log;
	mv $var_script_tmp_data_dir/0008_${INFILE01} ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.fa;
	cp $var_script_tmp_data_dir/0008_${INFILE01}.clstr ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.clstr;
	echo -e "\nCD-HIT Clustering Log" \
	     >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
	cat $var_script_tmp_data_dir/0008_${INFILE01%}.log \
	    >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
	echo -e "================================================================" \
	     >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
	rm -fr $var_script_tmp_data_dir;
	func_time_execution_stop;
	exit 0;
    fi
fi

## Do Cluster and Do Split
if [[ $var_clustersequences == "cluster_sequences" && $var_split_file -ne 1 ]];
then
    ## Proteome Clustering
    if [[ $var_INFILE01 == "proteins_file" ]];
    then
	func_fasta_formatter $var_script_tmp_data_dir/0006_${INFILE01} $var_script_tmp_data_dir/0007_${INFILE01};
	cd-hit \
            -c 1.0 -n 5 -p 1 -g 1 -T $var_ncores -d 300 -M 0 \
	    -i $var_script_tmp_data_dir/0007_${INFILE01} \
	    -o $var_script_tmp_data_dir/0008_${INFILE01} \
	    &> $var_script_tmp_data_dir/0008_${INFILE01}.log;

	awk -F "\t" -v OFS="\t" '{gsub(/\040/,"\075",$1);print $0}' $var_script_tmp_data_dir/0008_${INFILE01} | \
	    awk -F "\t" -v OFS="\t" 'BEGIN{RS=">"}NR>1{sub("\n","\t"); gsub("\n",""); print RS$0 "\t" length($(NF))}' \
		> $var_script_tmp_data_dir/0009_${INFILE01};

	split -d --suffix-length=6 --elide-empty-files --lines="$var_split_file"  $var_script_tmp_data_dir/0009_${INFILE01} $var_script_tmp_data_dir/0009_split_;
	find $var_script_tmp_data_dir -type f -name 0009_split_\* | sort -n > $var_script_tmp_data_dir/0010_retrieve_uniprot_ids_array;
	readarray -t lines < $var_script_tmp_data_dir/0010_retrieve_uniprot_ids_array;
	count="1";
	for i in "${lines[@]}";
	do
	    func_fasta_formatter $i $var_script_tmp_data_dir/0011_$(basename $i);
	    cp $var_script_tmp_data_dir/0011_$(basename $i) ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_"$count"_Fasta_Seq_Prep.fa;
	    ((count++));
	done
	mv $var_script_tmp_data_dir/0008_${INFILE01} ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.fa;
	cp $var_script_tmp_data_dir/0008_${INFILE01}.clstr ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.clstr;
	echo -e "\nCD-HIT Clustering Log" \
	     >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
	cat $var_script_tmp_data_dir/0008_${INFILE01%}.log \
	    >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
	echo -e "================================================================" \
	     >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
	rm -fr $var_script_tmp_data_dir;
	func_time_execution_stop;
	exit 0;
    fi
    ## Transcriptome Clustering
    if [[ $var_INFILE01 == "transcripts_file" ]];
    then
	func_fasta_formatter $var_script_tmp_data_dir/0006_${INFILE01} $var_script_tmp_data_dir/0007_${INFILE01};
	cd-hit-est \
            -c 1.0 -n 8 -r 1 -p 1 -g 1 -T $var_ncores -d 40 -M 0 \
	    -i $var_script_tmp_data_dir/0007_${INFILE01} \
	    -o $var_script_tmp_data_dir/0008_${INFILE01} \
	    &> $var_script_tmp_data_dir/0008_${INFILE01}.log;

	awk -F "\t" -v OFS="\t" '{gsub(/\040/,"\075",$1);print $0}' $var_script_tmp_data_dir/0008_${INFILE01} | \
	    awk -F "\t" -v OFS="\t" 'BEGIN{RS=">"}NR>1{sub("\n","\t"); gsub("\n",""); print RS$0 "\t" length($(NF))}' \
		> $var_script_tmp_data_dir/0009_${INFILE01};

	split -d --suffix-length=6 --elide-empty-files --lines="$var_split_file"  $var_script_tmp_data_dir/0009_${INFILE01} $var_script_tmp_data_dir/0009_split_;
	find $var_script_tmp_data_dir -type f -name 0009_split_\* | sort -n > $var_script_tmp_data_dir/0010_retrieve_uniprot_ids_array;
	readarray -t lines < $var_script_tmp_data_dir/0010_retrieve_uniprot_ids_array;
	count="1";
	for i in "${lines[@]}";
	do
	    func_fasta_formatter $i $var_script_tmp_data_dir/0011_$(basename $i);
	    cp $var_script_tmp_data_dir/0011_$(basename $i) ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_"$count"_Fasta_Seq_Prep.fa;
	    ((count++));
	done

	mv $var_script_tmp_data_dir/0008_${INFILE01} ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.fa;
	cp $var_script_tmp_data_dir/0008_${INFILE01}.clstr ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.clstr;
	echo -e "\nCD-HIT Clustering Log" \
	     >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
	cat $var_script_tmp_data_dir/0008_${INFILE01%}.log \
	    >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
	echo -e "================================================================" \
	     >> ./${INFILE01%.fa}_Fasta_Seq_Prepare.dir/${INFILE01%.fa}_Fasta_Seq_Prep.log;
	rm -fr $var_script_tmp_data_dir;
	func_time_execution_stop;
	exit 0;
    fi
fi

exit 0
