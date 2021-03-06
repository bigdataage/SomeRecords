#!/usr/bin/env  perl5
use  strict;
use  warnings;
use  v5.22;

## Perl5 version >= 5.22
## You can create a symbolic link for perl5 by using "sudo  ln  /usr/bin/perl   /usr/bin/perl5" in Ubuntu.
## Suffixes of all self-defined global variables must be "_g".
###################################################################################################################################################################################################





###################################################################################################################################################################################################
my $input_g  = '2-mergedFASTQ';           ## It is a folder or dir.   
my $output_g = 'index_and_itsRC.txt';  ## It is a file.

opendir(my $DH_input_g, $input_g)  ||  die;
my @inputFiles_g = readdir($DH_input_g);
my $pattern_g    = "[-.0-9A-Za-z]+";

open( my $DH_output_g,   ">",   "$output_g")     or die "$!";   
###################################################################################################################################################################################################





###################################################################################################################################################################################################
{
say   "\n\n\n\n\n\n##################################################################################################";
say   "Checking all the input file names ......";
my @groupFiles = ();
my $fileNameBool = 1;

for ( my $i=0; $i<=$#inputFiles_g; $i++ ) {
        next unless $inputFiles_g[$i] !~ m/^[.]/;
        next unless $inputFiles_g[$i] !~ m/[~]$/;
        next unless $inputFiles_g[$i] !~ m/^QC_Results$/;
        say   "\t......$inputFiles_g[$i]" ;
        my $temp = $inputFiles_g[$i];
        $groupFiles[++$#groupFiles] = $temp;
        $temp =~ m/^(\d+)_($pattern_g)_(Rep[1-9])/    or  die   "wrong-1: ## $temp ##";
        $temp =~ m/_(Rep[1-9])\.sra$/  or  $temp =~ m/_(Rep[1-9])_?([1-2]?)(_Lane[1-2])?\.fastq/  or  die   "wrong-2: ## $temp ##";
        if($temp !~ m/^((\d+)_($pattern_g)_(Rep[1-9]))(_[1-2])?(_Lane[1-2])?(\.fastq)?/) {
             $fileNameBool = 0;
        }
}
if($fileNameBool == 1)  { say    "\n\t\tAll the file names are passed.\n";  }

@groupFiles   = sort(@groupFiles);
my $numGroup  = 0;
my $noteGroup = 0;
my $noteGroup2= 0;
for ( my $i=0; $i<=$#groupFiles; $i++ ) {
    $groupFiles[$i] =~ m/^(\d+)_($pattern_g)_(Rep[1-9])/  or  die;
    my $n1 = $1;
    $n1>=1  or  die;
    if($noteGroup2 != $n1) {say "\n\t\tGroup $n1:";  $numGroup++; }
    say  "\t\t\t$groupFiles[$i]";
    $noteGroup2 = $n1;  
    if($noteGroup < $n1) {$noteGroup = $n1;}
}
($noteGroup == $numGroup)  or  die "##($noteGroup == $numGroup)##\n\n";  ## so the first number of FASTQ file name must be from small to large, 1,2,3,4,5,6,7,8,9 ......   
say  "\n\t\tThere are $numGroup groups.";
}
###################################################################################################################################################################################################






###################################################################################################################################################################################################
{
say   "\n\n\n\n\n\n##################################################################################################";
say   "Detecting index ......";
opendir(my $DH_input, $input_g)  ||  die;
my @twoLanes = readdir($DH_input);
print  $DH_output_g   "myFileName\tindex\tindex_rc\tactualSample\n";

for (my $i=0; $i<=$#twoLanes; $i++) {
    next unless $twoLanes[$i] !~ m/^QC_Results$/;
    next unless $twoLanes[$i] =~ m/\.fastq$/;
    next unless $twoLanes[$i] !~ m/^[.]/;
    next unless $twoLanes[$i] !~ m/[~]$/;
    say    "\t......$twoLanes[$i]";
    $twoLanes[$i] =~ m/^(\d+)_($pattern_g)_(Rep[1-9])_?([1-2]?)(_Lane[1-2])?\.fastq$/   or  die;

    open(INPUT1,    "<",   "$input_g/$twoLanes[$i]")     or   die   "$!"; 
    my @fastq_4n = <INPUT1>;

    my $temp_index  = '';
    my $temp_index2 = '';
    for(my $j=0; $j<=$#fastq_4n; $j=$j+4) {
        ($fastq_4n[$j] =~ m/\d+:N:\d+:([AGCT]+)\n$/)  or die "##err1:$fastq_4n[$j]##";
        $temp_index = $1;
        if($j==0) {$temp_index2 = $temp_index;}
        ($temp_index2 eq $temp_index)   or   die   "##err2: $temp_index2 \t $temp_index \n##";
    }
    my $temp_index_rc  = $temp_index;
    $temp_index_rc =~ tr/AGCT/TCGA/   or   die;
    $temp_index_rc = reverse($temp_index_rc);
    print  $DH_output_g   "$twoLanes[$i]\t$temp_index\t$temp_index_rc\n"
}

}
###################################################################################################################################################################################################





###################################################################################################################################################################################################
say   "\n\n\n\n\n\n##################################################################################################";
say   "\tJob Done! Cheers! \n\n\n\n\n";





## END
