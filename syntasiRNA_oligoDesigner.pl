#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Std;

################################################################################
# Begin variables
################################################################################
my (%opt, $seq_list, $name_list);
getopts('s:n:h', \%opt);
arg_check();
################################################################################
# End variables
################################################################################

################################################################################
# Begin main
################################################################################
oligo_designer($seq_list, $name_list);

exit;
################################################################################
# End main
################################################################################

################################################################################
# Begin functions
################################################################################

########################################
# Function: oligo_designer
# Design oligos from input sequence
########################################
sub oligo_designer {
  my $seq_list = shift;
  my $name_list = shift;
	
	my @syntasiRNAs = split /,/, $seq_list;
	my @names = split /,/, $name_list;
	
	if (scalar(@syntasiRNAs) != scalar(@names)) {
		arg_error("The length of the syntasiRNA sequence and names lists do not match.");
	}
	
  # Reformat for conistency
	for (my $i = 0; $i < scalar(@syntasiRNAs); $i++) {
		$syntasiRNAs[$i] = uc($syntasiRNAs[$i]);
		$syntasiRNAs[$i] =~ s/U/T/g;
	}
  
  # Forward oligo
  my $oligo_f = join('', @syntasiRNAs);
  # Reverse oligo
	my $oligo_r = reverse($oligo_f);
  $oligo_r =~ tr/ATGC/TACG/;
  # Add bsaI overhangs
  $oligo_f = 'ATTA'.$oligo_f;
  $oligo_r = 'GTTC'.$oligo_r;

	# Format JSON results
	my @pairs;
	for (my $i = 0; $i < scalar(@syntasiRNAs); $i++) {
		push @pairs, '"'.$names[$i].'": "'.$syntasiRNAs[$i].'"';
	}
	my $json = '{"results": {"syntasiRNA:" [';
	$json .= join(',', @pairs);
	$json .= '], "Forward Oligo": "'.$oligo_f.'", "Reverse Oligo": "'.$oligo_r.'"}}';

	print $json;
}

########################################
# Function: arg_check
# Parse Getopt variables
########################################
sub arg_check {
	if ($opt{'h'}) {
		arg_error();
	}
  if ($opt{'s'}) {
    $seq_list = $opt{'s'};
  } else {
    arg_error("No syn-tasiRNA sequences were provided!");
  }
  if ($opt{'n'}) {
    $name_list = $opt{'n'};
  } else {
    arg_error("No syn-tasiRNA sequence names were provided!");
  }
}

########################################
# Funtion: arg_error
# Process input errors and print help
########################################
sub arg_error {
  my $error = shift;
  if ($error) {
    print STDERR $error."\n";
  }
  my $usage = "
usage: syntasiRNA_oligoDesigner.pl -s SEQUENCES -n NAMES [-h]

Plant Small RNA Maker Suite (P-SAMS).
  Synthetic trans-acting siRNA oligo designer tool.

arguments:
  -s SEQUENCES           Syn-tasiRNA sequences. A comma-separated list of one or more 21-nucleotides long sequences.
  -n NAMES               A comma-separated list of names for the syn-tasiRNA sequences. Length must match the sequences list.
  -h                     Show this help message and exit.

  ";
  print STDERR $usage;
  exit 1;
}

################################################################################
# End functions
################################################################################









