#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Std;
use DBI;

################################################################################
# Begin variables
################################################################################
my (%opt, $fasta, $species, $ksize, %kmers);
getopts('f:s:k:h',\%opt);
arg_check();

my $site_length = 21;
################################################################################
# End variables
################################################################################

################################################################################
# Begin main
################################################################################

my $offset = $site_length - $ksize - 1;
my ($transcript, $seq);
my $count = 0;
open(FASTA, $fasta) or die "Cannot open file $fasta: $!\n\n";
while (my $line = <FASTA>) {
  print STDERR "Processed $count\r";
  chomp $line;
  if (substr($line,0,1) eq '>' || eof(FASTA)) {
    if ($count == 0) {
      ($transcript) = split /\s/, substr($line,1);
      $count++;
      next;
    }
    if (eof($line)) {
      $seq .= $line;
    }
    # Kmerize
    my $length = length($seq);
		$seq = uc($seq);
    for (my $i = 0; $i <= $length - $site_length; $i++) {
      my $kmer = substr(substr($seq,$i,$site_length),$offset,$ksize);
      $kmers{$kmer}->{$transcript} = 1;
    }
    if (!eof(FASTA)) {
      ($transcript) = split /\s/, substr($line,1);
      $seq = '';
      $count++;
    }
  } else {
    $seq .= $line;
  }
}
print STDERR "Processed $count\n";
close FASTA;

open(TMP, ">tmp.tab") or die "Cannot open file tmp.tab: $!\n\n";
while (my ($kmer, $names) = each(%kmers)) {
  my @list;
  while (my ($name, $value) = each(%{$names})) {
    push @list, $name;
  }
  print TMP $kmer."\t".join(",", @list)."\n";
}
close TMP;
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
	if ($opt{'f'}) {
		$fasta = $opt{'f'};
	} else {
    arg_error('No FASTA file was provided!');
  }
  if ($opt{'s'}) {
		$species = $opt{'s'};
	} else {
    arg_error('No species was provided!');
  }
  if ($opt{'k'}) {
    $ksize = $opt{'k'};
  } else {
    arg_error('No ksize was provided!');
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
usage: add_species.pl -f FASTA -s SPECIES -k KSIZE [-h]

Plant Small RNA Maker Suite (P-SAMS).
  Adds a new species to the kmer database.

arguments:
  -f FASTA              FASTA-formatted transcript sequences.
  -s SPECIES            Species code.
  -k KSIZE              Kmer length.
  -h                    Show this help message and exit.

  ";
  print STDERR $usage;
  exit 1;
}

################################################################################
# End functions
################################################################################