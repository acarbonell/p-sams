#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Std;

################################################################################
# Begin variables
################################################################################
my (%opt, $amiRNA, $name, $type);
getopts('s:n:t:h', \%opt);
arg_check();
################################################################################
# End variables
################################################################################

################################################################################
# Begin main
################################################################################
my ($oligo_f, $oligo_r, $amiRNAstar) = oligo_designer($amiRNA, $type);

# Format JSON results
my $json = '{"results": {"amiRNA": "'.$amiRNA.'", "miRNA*": "'.$amiRNAstar.'", "Forward Oligo" : "'.$oligo_f.'", "Reverse Oligo": "'.$oligo_r.'", "name": "'.$name.'"}}';
print $json;

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
  my $amiRNA = shift;
  my $type = shift;
  
  # Reformat for conistency
  $amiRNA = uc($amiRNA);
  $amiRNA =~ s/U/T/g;
  
  # amiRNA reverse complement
  my $amiRNA_revcomp = reverse $amiRNA;
  $amiRNA_revcomp =~ tr/ACGT/TGCA/;
  
  # We need to engineer a specific mismatch in the star strand
  my @nts = split //, $amiRNA_revcomp;
  my $central_bulge = $nts[10];
  if ($central_bulge eq 'A') {
    $central_bulge = 'C';
  } elsif ($central_bulge eq 'G') {
    $central_bulge = 'T';
  } elsif ($central_bulge eq 'C') {
    $central_bulge = 'A';
  } elsif ($central_bulge eq 'T') {
    $central_bulge = 'G';
  }
  
  if ($type eq 'eudicot') {
    # Define sequence opposite amiRNA in oligo
    my $duplex_seq = substr($amiRNA_revcomp, 0, 10).$central_bulge.substr($amiRNA_revcomp, 11, 10);
    # Forward oligo
    my $oligo_f = $amiRNA.'ATGATGATCACATTCGTTATCTATTTTTT'.$duplex_seq;
    # Reverse oligo
    my $oligo_r = reverse $oligo_f;
    $oligo_r =~ tr/ATGC/TACG/;
    # Define amiRNA*
    my $amiRNAstar = substr($duplex_seq, 2, 20).'CA';
    # Add bsaI overhangs
    $oligo_f = 'TGTA'.$oligo_f;
    $oligo_r = 'AATG'.$oligo_r;
    return ($oligo_f, $oligo_r, $amiRNAstar);
  } elsif ($type eq 'monocot') {
    my $end_bulge = (substr($amiRNA,0,1) =~ /[ATC]/) ? 'C' : 'A';
    # Define sequence opposite amiRNA in oligo
    my $duplex_seq = substr($amiRNA_revcomp, 0, 10).$central_bulge.substr($amiRNA_revcomp, 11, 9).$end_bulge;
    # Forward oligo
    my $oligo_f = $amiRNA.'ATGATGATCACATTCGTTATCTATTTTTT'.$duplex_seq;
    # Reverse oligo
    my $oligo_r = reverse $oligo_f;
    $oligo_r =~ tr/ATGC/TACG/;
    # Define amiRNA*
    my $amiRNAstar = substr($duplex_seq, 2, 20).'CA';
    # Add bsaI overhangs
    $oligo_f = 'CTTG'.$oligo_f;
    $oligo_r = 'CATG'.$oligo_r;
    return ($oligo_f, $oligo_r, $amiRNAstar);
  }
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
    $amiRNA = $opt{'s'};
  } else {
    arg_error("An amiRNA sequence was not provided!");
  }
  if ($opt{'n'}) {
    $name = $opt{'n'};
  } else {
    arg_error("The amiRNA construct name was not provided!");
  }
  if ($opt{'t'}) {
    $type = $opt{'t'};
    unless ($type eq 'eudicot' || $type eq 'monocot') {
      arg_error("The type $type is not supported!");
    }
  } else {
    arg_error("The foldback type was not provided!");
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
usage: amiRNA_oligoDesigner.pl -s SEQUENCE -n NAME -t TYPE [-h]

Plant Small RNA Maker Suite (P-SAMS).
  Artificial microRNA oligo designer tool.

arguments:
  -s SEQUENCE           Artificial microRNA sequence. Must be 21-nucleotides long.
  -n NAME               Artificial microRNA name.
  -t TYPE               Foldback type. Options = eudicot or monocot.
  -h                    Show this help message and exit.

  ";
  print STDERR $usage;
  exit 1;
}

################################################################################
# End functions
################################################################################









