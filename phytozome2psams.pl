#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Std;

################################################################################
# Begin variables
################################################################################
my (%opt, $fasta, $annotation, $species, $version);
getopts('f:a:s:v:h',\%opt);
arg_check();
################################################################################
# End variables
################################################################################

################################################################################
# Begin main
################################################################################
my $out_fasta = $species.'.'.$version.'.transcripts.fasta';
my $out_annotation = $species.'.'.$version.'.annotation.txt';

print STDERR "Parsing FASTA data. Parsed FASTA output will be in $out_fasta... ";
open(OUT, ">$out_fasta") or die "Cannot open $out_fasta: $!\n\n";

open(FASTA, $fasta) or die "Cannot open $fasta: $!\n\n";
my $skip = 0;
while (my $line = <FASTA>) {
  if (substr($line,0,1) eq '>') {
    $skip = 0;
    # Rice has some unusual gene entries that are named inconvienently mRNA.1, etc. Remove for now
    if ($line =~ />ChrSy.fgenesh/ || $line =~ />ChrUn.fgenesh/) {
      $skip = 1;
      next;
    }
    # These are sequence header lines, remove everything except the transcript ID
    my @header = split /\s+/, $line;
    print OUT $header[0]."\n";
  } elsif ($line =~ /^\s*$/) {
    # Skip blank lines
    next;
  } else {
    next if ($skip == 1);
    # These are sequence lines, just print them back out
    print OUT $line;
  }
}
close FASTA;

close OUT;
print STDERR "done\n";

print STDERR "Parsing annotation data. Parsed annotation output will be in $out_annotation... ";
open(OUT, ">$out_annotation") or die "Cannot open $out_annotation: $!\n\n";

open(INFO, $annotation) or die "Cannot open $annotation: $!\n\n";
while (my $line = <INFO>) {
  chomp $line;
  my ($id, $gene, $transcript, $protein, $pfam, $panther, $kog, $ec, $ko, $go, $best_ath, $ath_sym, $ath_desc, $best_os, $os_sym, $os_desc) = split /\t/, $line;
  
  # Description
  my $description;
  if ($ath_desc) {
    $description .= $ath_desc;
    if ($ath_sym) {
      $description .= ' ('.$ath_sym.')'
    }
  } elsif ($os_desc) {
    $description .= $os_desc;
    if ($os_sym) {
      $description .= ' ('.$os_sym.')'
    }
  } else {
    $description = 'unknown';
  }
  
  # Contains
  my @contains;
  if ($pfam || $panther || $kog || $ec || $ko || $go) {
    $description .= '; CONTAINS ';
    if ($pfam) {
      push @contains, 'PFAM:'.$pfam;
    }
    if ($panther) {
      push @contains, 'PANTHER:'.$panther;
    }
    if ($kog) {
      push @contains, 'KOG:'.$kog;
    }
    if ($ec) {
      push @contains, 'EC:'.$ec;
    }
    if ($ko) {
      push @contains, 'KEGG:'.$ko;
    }
    if ($go) {
      push @contains, 'GO:'.$go;
    }
    $description .= join('; ', @contains);
  }
  
  # Best
  my @best;
  if ($best_ath || $best_os) {
    $description .= '; BEST:';
    if ($best_ath) {
      push @best, $best_ath;
    }
    if ($best_os) {
      push @best, $best_os;
    }
    $description .= join(',', @best);
  }
  print OUT $transcript."\t".$description."\n";
}
close INFO;

close OUT;
print STDERR "done\n";

exit;
################################################################################
# End main
################################################################################

################################################################################
# Begin functions
################################################################################
########################################
# Function: arg_check
# Parse Getopt variables
########################################
sub arg_check {
	if ($opt{'h'}) {
		arg_error();
	}
	if ($opt{'a'}) {
		$annotation = $opt{'a'};
	} else {
    arg_error('No annotation file provided!');
  }
	if ($opt{'f'}) {
		$fasta = $opt{'f'};
	} else {
    arg_error('No FASTA file provided!');
  }
  if ($opt{'s'}) {
    $species = $opt{'s'};
  } else {
    arg_error('No species name provided!');
  }
  if ($opt{'v'}) {
    $version = $opt{'v'};
  } else {
    arg_error('No version provided!');
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
usage: phytozome2psams.pl -f FASTA -a ANNOTATION -s SPECIES -v VERSION [-h]

Plant Small RNA Maker Suite (P-SAMS).
  Parse Phytozome transcript FASTA and annotation files.

arguments:
  -f FASTA              FASTA-formatted transcript file (*.transcript.fa).
  -a ANNOTATION         Gene annotation file (*.annotation_info.txt).
  -s SPECIES            Species name. No spaces, will be used in output file names.
  -v VERSION            Species annotation/assembly version. Will be used in output file names.
  -h                    Show this help message and exit.

  ";
  print STDERR $usage;
  exit 1;
}

################################################################################
# End functions
################################################################################