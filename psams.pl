#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Std;
use Config::Tiny;
use DBI;
use String::Approx qw(adist);
use constant DEBUG => 1;

################################################################################
# Begin variables
################################################################################
my (%opt, @accessions, $fasta, $species, $fb, $ids, $bg, @t_sites);
getopts('a:s:t:f:ho',\%opt);
var_check();

# Constants
my $conf_file = '/var/www/asrp/sites/amirna/amiRNA_tool.conf';
my $conf = Config::Tiny->read($conf_file);
my $db = '/var/www/asrp/sites/amirna/databases/transcripts.sqlite3';
my $mRNAdb = $conf->{$species}->{'mRNA'};
my $seed = 15;

################################################################################
# End variables
################################################################################

################################################################################
# Begin main
################################################################################

# Build foreground index
if ($fasta) {
	$ids = build_fg_index_fasta($fasta);
} else {
	$ids = build_fg_index(@accessions);
}

# Build background index
if ($opt{'o'}) {
	($ids, $bg) = build_bg_index($ids, $seed, $db, $species);
} elsif (!$fasta) {
	$ids = populate_fg_index($ids, $seed, $db, $species);
}

# Find sites
if ($opt{'o'}) {
	@t_sites = get_tsites($ids, $seed, $bg);	
} else {
	@t_sites = get_tsites($ids, $seed);
}

# Group sites
my @gsites = group_tsites($seed, @t_sites);

# Scoring sites
@gsites = score_sites(scalar(keys(%{$ids})), $seed, @gsites);

print STDERR "Sorting and outputing results... \n" if (DEBUG);
#@gsites = sort {$a->{'distance'} <=> $b->{'distance'} || $a->{'score'} cmp $b->{'score'}} @gsites;
@gsites = sort {
	$a->{'other_mm'} <=> $b->{'other_mm'}
		||
	$a->{'p21'} <=> $b->{'p21'}
		||
	$a->{'p3'} <=> $b->{'p3'}
		||
	$a->{'p2'} <=> $b->{'p2'}
		||
	$a->{'p1'} <=> $b->{'p1'}
	} @gsites;

# Design and test guide RNAs
# Add rules for site searches. For example:
     # How many results do we want to return?
		 # Are there site types we do not want to accept?
foreach my $site (@gsites) {
	my $guide_RNA = design_guide_RNA($site);
	$site->{'guide'} = $guide_RNA;
#	# TargetFinder
}

print "Accessions\tSites\tAdjusted distance\tp3\tp2\tp1\tp21\n";
foreach my $site (@gsites) {
	#my @inc = split /;/, $site->{'names'};
	#next if (scalar(@inc) < scalar(keys(%{$ids})));
	#print $site->{'names'}."\t".$site->{'seqs'}."\t".$site->{'distance'}."\t".$site->{'score'}."\n";
	print $site->{'names'}."\t".$site->{'seqs'}."\t".$site->{'other_mm'}."\t".$site->{'p3'}."\t".$site->{'p2'}."\t".$site->{'p1'}."\t".$site->{'p21'}."\t".$site->{'guide'}."\n";
}
exit;
################################################################################
# End main
################################################################################

################################################################################
# Begin functions
################################################################################

########################################
# Function: build_fg_index_fasta
# Parses sequences in FASTA-format and builds the foreground index
########################################

sub build_fg_index_fasta {
	my $fasta = shift;
	my %ids;

	print STDERR "Building foreground index... " if (DEBUG);
	my @fasta = split /\n/, $fasta;
	my $accession = shift @fasta;
	$accession = substr($accession,1);
	$ids{$accession} = '';
	foreach my $line (@fasta) {
		next if ($line =~ /^\s*$/);
		if (substr($line,0,1) eq '>') {
			$accession = substr($line,1);
			$ids{$accession} = '';
		} else {
			$ids{$accession} .= $line;
		}
	}
	print STDERR "done\n" if (DEBUG);
	
	return \%ids;
}

########################################
# Function: build_fg_index
# Adds gene accessions to the foreground index
########################################
sub build_fg_index {
	my @accessions = @_;
	my %ids;
	
	print STDERR "Building foreground index... " if (DEBUG);
	foreach my $accession (@accessions) {
		# If the user entered transcript IDs we need to convert to gene IDs
		$accession =~ s/\.\d+$//;	
		$ids{$accession} = 1;
	}
	print STDERR "done\n" if (DEBUG);

	return \%ids;
}

########################################
# Function: build_bg_index
# Builds an index of kmers from all non-target transcripts
########################################

sub build_bg_index {
	my $ids = shift;
	my $seed = shift;
	my $db = shift;
	my $species = shift;
	
	# Connect to database, initialize database handler
	my $dbh = DBI->connect("dbi:SQLite:dbname=$db","","");
	my $sth = $dbh->prepare("SELECT * FROM `$species`");
	
	my %bg;
	my $site_length = 21;
	my $offset = $site_length - $seed - 1;
	
	print STDERR "Building background index... " if (DEBUG);
	$sth->execute();
	while (my $row = $sth->fetchrow_hashref()) {
		my $accession;
		if ($row->{'accession'} =~ /^(.+)\.\d+$/) {
			$accession = $1;
		} else {
			$accession = $row->{'accession'};
		}
		if (exists($ids->{$accession})) {
			$ids->{$accession} = $row->{'sequence'};
			next;
		}
		my $length = length($row->{'sequence'});
		for (my $i = 0; $i <= $length - $site_length; $i++) {
			my $kmer = substr(substr($row->{'sequence'},$i,$site_length),$offset,$seed);
			$bg{$kmer} = 1;
		}
	}
	print STDERR "done\n" if (DEBUG);
	
	return ($ids, \%bg);
}

########################################
# Function: populate_fg_index
# Builds a foreground index without background subtraction
########################################
sub populate_fg_index {
	my $ids = shift;
	my $seed = shift;
	my $db = shift;
	my $species = shift;
	my %tmp = %{$ids};
	
	# Connect to database, initialize database handler
	my $dbh = DBI->connect("dbi:SQLite:dbname=$db","","");
	my $sth = $dbh->prepare("SELECT * FROM `$species` WHERE `accession` LIKE ?");
	
	my $site_length = 21;
	my $offset = $site_length - $seed - 1;
	
	print STDERR "Building index... " if (DEBUG);
	while (my ($gene, $seq) = each(%tmp)) {
		$sth->execute("$gene\%");
		while (my $row = $sth->fetchrow_hashref()) {
			my $accession;
			if ($row->{'accession'} =~ /^(.+)\.\d+$/) {
				$accession = $1;
			} else {
				$accession = $row->{'accession'};
			}
			if (exists($ids->{$accession})) {
				$ids->{$accession} = $row->{'sequence'};
			}
		}
	}
	print STDERR "done\n" if (DEBUG);
	
	return $ids;
}

########################################
# Function: get_tsites
# Identify all putative target sites
########################################
sub get_tsites {
	my $ids = shift;
	my $seed = shift;
	my $bg = shift;
	
	my @t_sites;
	my $site_length = 21;
	my $offset = $site_length - $seed - 1;
	
	print STDERR "Finding sites in foreground transcripts... " if (DEBUG);
	while (my ($accession, $seq) = each(%{$ids})) {
		my $length = length($seq);
		for (my $i = 0; $i <= $length - $site_length; $i++) {
			my $site = substr($seq,$i,$site_length);
			my $kmer = substr($site,$offset,$seed);
			next if ($bg && exists($bg->{$kmer}));
			my %hash;
			$hash{'name'} = $accession;
			$hash{'seq'} = $site;
			#$hash{'ideal'} = eval_tsite($site);
			push @t_sites, \%hash;
		}
	}
	print STDERR "done\n" if (DEBUG);
	
	return @t_sites;
}

########################################
# Function: group_tsites
# Group target sites based on seed sequence
########################################
sub group_tsites {
	my $seed = shift;
	my @t_sites = @_;
	
	my $site_length = 21;
	my $offset = $site_length - $seed - 1;
	
	print STDERR "Grouping sites... " if (DEBUG);
	@t_sites = sort {substr($a->{'seq'},$offset,$seed) cmp substr($b->{'seq'},$offset,$seed) || $a->{'name'} cmp $b->{'name'}} @t_sites;
	
	my (@names, $lastSeq, @seqs, @gsites);
	my $score = 0;
	my $i = 0;
	foreach my $row (@t_sites) {
		if (scalar(@names) == 0) {
			$lastSeq = $row->{'seq'};
		}
		if (substr($lastSeq,$offset,$seed) eq substr($row->{'seq'},$offset,$seed)) {
			push @names, $row->{'name'};
			push @seqs, $row->{'seq'};
			#$score += $row->{'ideal'};
		} else {
			my %hash;
			$hash{'names'} = join(";",@names);
			$hash{'seqs'} = join(";", @seqs);
			#$hash{'score'} = $score;
			
			# Edit distances
			#if (scalar(@names) > 1) {
			#	my @distances = adist(@seqs);
			#	@distances = sort {$b <=> $a} @distances;
			#	$hash{'distance'} = $distances[0];
			#} else {
			#	$hash{'distance'} = 0;
			#}
			push @gsites, \%hash;
			
			@names = $row->{'name'};
			@seqs = $row->{'seq'};
			#$score = $row->{'ideal'};
			
			$lastSeq = $row->{'seq'};
			if ($i == scalar(@t_sites) - 1) {
				my %last;
				$last{'names'} = $row->{'name'};
				$last{'seqs'} = $row->{'seq'};
				#$last{'score'} = $row->{'ideal'};
				#$last{'distance'} = 0;
			}
		}
		$i++;
	}
	print STDERR "done\n" if (DEBUG);
	
	return @gsites;
}

########################################
# Function: score_sites
# Scores sites based on similarity
########################################
sub score_sites {
	my $min_site_count = shift;
	my $seed = shift;
	my @gsites = @_;
	my $site_length = 21;
	my $offset = $site_length - $seed - 1;
	my @scored;
	
	# Score sites on:
	#     Pos. 1
	#     Pos. 2
	#     Pos. 3
	#     Non-seed sites
	#     Pos. 21
	
	foreach my $site (@gsites) {
		my @sites = split /;/, $site->{'seqs'};
		
		next if (scalar(@sites) < $min_site_count);
		# Get the max edit distance for this target site group
		#if (scalar(@sites) > 1) {
		#	# All distances relative to sequence 1
		#	my @distances = adist(@sites);
		#	# Max edit distance
		#	@distances = sort {$b <=> $a} @distances;
		#	if ($distances[0] < 0) {
		#		$distances[0] = 0;
		#	}
		#	$site->{'distance'} = $distances[0];
		#} else {
		#	$site->{'distance'} = 0;
		#}
		
		
		# Score sites on position 21
		for (my $i = 20; $i <= 20; $i++) {
			my %nts = (
				'A' => 0,
				'G' => 0,
				'C' => 0,
				'T' => 0
			);
			foreach my $seq (@sites) {
				$nts{substr($seq,$i,1)}++;
			}
			if ($nts{'A'} == scalar(@sites)) {
				# Best sites have an A to pair with the miRNA 5'U
				$site->{'p21'} = 1;
			} elsif ($nts{'G'} == scalar(@sites)) {
				# Next-best sites have a G to have a G:U bp with the miRNA 5'U
				$site->{'p21'} = 2;
			} elsif ($nts{'A'} + $nts{'G'} == scalar(@sites)) {
				# Sites with mixed A and G can both pair to the miRNA 5'U, but not equally well
				$site->{'p21'} = 3;
				# Adjust distance due to mismatch at pos 21 because we account for it here
				#$site->{'distance'}--;
			} elsif ($nts{'C'} == scalar(@sites) || $nts{'T'} == scalar(@sites)) {
				# All other sites will not match the miRNA 5'U, but this might be okay if no other options are available
				$site->{'p21'} = 4;
			} else {
				# All other sites will not match the miRNA 5'U, but this might be okay if no other options are available
				$site->{'p21'} = 4;
				# Adjust distance due to mismatch at pos 21 because we account for it here
				#$site->{'distance'}-- if (scalar(@sites) > 1);
			}
		}
		
		# Score sites on position 1
		for (my $i = 0; $i <= 0; $i++) {
			my %nts = (
				'A' => 0,
				'G' => 0,
				'C' => 0,
				'T' => 0
			);
			foreach my $seq (@sites) {
				$nts{substr($seq,$i,1)}++;
			}
			# Pos 1 is intentionally mismatched so any base is allowed here
			# However, if G and T bases are present together then pairing is unavoidable due to G:U base-pairing
			if ($nts{'A'} == scalar(@sites) || $nts{'G'} == scalar(@sites) || $nts{'C'} == scalar(@sites) || $nts{'T'} == scalar(@sites)) {
				$site->{'p1'} = 1;
			} elsif ($nts{'G'} > 0 && $nts{'T'} > 0) {
				$site->{'p1'} = 2;
				# Adjust distance due to mismatch at pos 1 because we account for it here
				#$site->{'distance'}--;
			} else {
				$site->{'p1'} = 1;
				# Adjust distance due to mismatch at pos 1 because we account for it here
				#$site->{'distance'}--;
			}
		}
		
		# Score sites on position 2
		for (my $i = 1; $i <= 1; $i++) {
			my %nts = (
				'A' => 0,
				'G' => 0,
				'C' => 0,
				'T' => 0
			);
			foreach my $seq (@sites) {
				$nts{substr($seq,$i,1)}++;
			}
			# We want to pair this position, but it is not required for functionality
			if ($nts{'A'} == scalar(@sites) || $nts{'G'} == scalar(@sites) || $nts{'C'} == scalar(@sites) || $nts{'T'} == scalar(@sites)) {
				# We can pair all of these sites
				$site->{'p2'} = 1;
			} elsif ($nts{'G'} > 0 && $nts{'A'} > 0 && $nts{'G'} + $nts{'A'} == scalar(@sites)) {
				# We can pair or G:U pair all of these sites
				$site->{'p2'} = 2;
				# Adjust distance due to mismatch at pos 2 because we account for it here
				#$site->{'distance'}--;
			} else {
				# Some of these will be unpaired
				$site->{'p2'} = 3;
				# Adjust distance due to mismatch at pos 2 because we account for it here
				#$site->{'distance'}--;
			}
		}
		
		# Score sites on position 3
		for (my $i = 2; $i <= 2; $i++) {
			my %nts = (
				'A' => 0,
				'G' => 0,
				'C' => 0,
				'T' => 0
			);
			foreach my $seq (@sites) {
				$nts{substr($seq,$i,1)}++;
			}
			# The miRNA is fixed at position 19 (C) so ideally we will have a G at position 3 of the target site
			# However, mismatches can be tolerated here
			if ($nts{'G'} == scalar(@sites)) {
				$site->{'p3'} = 1;
			} elsif ($nts{'A'} == scalar(@sites) || $nts{'C'} == scalar(@sites) || $nts{'T'} == scalar(@sites)) {
				$site->{'p3'} = 2;
			} else {
				$site->{'p3'} = 3;
				# Adjust distance due to mismatch at pos 2 because we account for it here
				#$site->{'distance'}--;
			}
		}
		
		# Score remaining sites
		$site->{'other_mm'} = 0;
		for (my $i = 3; $i < $offset; $i++) {
			my %nts = (
				'A' => 0,
				'G' => 0,
				'C' => 0,
				'T' => 0
			);
			foreach my $seq (@sites) {
				$nts{substr($seq,$i,1)}++;
			}
			unless ($nts{'A'} == scalar(@sites) || $nts{'G'} == scalar(@sites) || $nts{'C'} == scalar(@sites) || $nts{'T'} == scalar(@sites)) {
				$site->{'other_mm'}++;
			}
		}
		
		push @scored, $site;
	}
	
	return @scored;
}

########################################
# Function: design_guide_RNA
# Designs the guide RNA based on the
# target site sequence(s)
########################################
sub design_guide_RNA {
	my $site = shift;
	my $guide;
	
	my %mm = (
		'A' => 'A',
		'C' => 'C',
		'G' => 'G',
		'T' => 'T',
		'AC' => 'A',
		'AG' => 'A',
		'AT' => 'C',
		'CG' => 'A',
		'CT' => 'C',
		'ACG' => 'A',
		'ACT' => 'C',
		'GT' => 'G',
		'AGT' => 'G',
		'CGT' => 'T',
		'ACGT' => 'A'
	);
	
	my %bp = (
		'A' => 'T',
		'C' => 'G',
		'G' => 'C',
		'T' => 'A',
		'AC' => 'T',
		'AG' => 'T',
		'AT' => 'T',
		'CG' => 'C',
		'CT' => 'G',
		'ACG' => 'T',
		'ACT' => 'G',
		'GT' => 'C',
		'AGT' => 'T',
		'CGT' => 'A',
		'ACGT' => 'T'
	);

	# Format of site data structure
	#$site->{'names'}
	#$site->{'seqs'}
	#$site->{'other_mm'}
	#$site->{'p3'}
	#$site->{'p2'}
	#$site->{'p1'}
	#$site->{'p21'}
	my @sites = split /;/, $site->{'seqs'};
	
	# Create guide RNA string
	for (my $i = 0; $i <= 20; $i++) {
		my %nts = (
			'A' => 0,
			'C' => 0,
			'G' => 0,
			'T' => 0
		);
		
		# Index nucleotides at position i
		foreach my $seq (@sites) {
			$nts{substr($seq,$i,1)}++;
		}
		
		# Create a unique nt diversity screen for choosing an appropriate base pair
		my $str;
		foreach my $nt ('A','C','G','T') {
			if ($nts{$nt} > 0) {
				$str .= $nt;
			}
		}
		
		if ($i == 0) {
			# Pos 1 is intentionally mismatched so any base is allowed here
			# However, if G and T bases are present together then pairing is unavoidable due to G:U base-pairing
			$guide .= $mm{$str};
		} elsif ($i == 2) {
			# Pos 3 is fixed as a C to pair the the 5'G of the miRNA*
			$guide .= 'C';
		} elsif ($i == 20) {
			# Pos 21, all guide RNAs have a 5'U
			$guide .= 'T';
		} else {
			# All other positions are base paired
			$guide .= $bp{$str};
		}
	}
	
	return reverse $guide;
}

########################################
# Function: Off-target check
#   Use TargetFinder to identify the
#   spectrum of predicted target RNAs
########################################
sub off_target_check {
	my $site = shift;
	my $mRNAdb = shift;
	
	# Format of site data structure
	#$site->{'names'}
	#$site->{'seqs'}
	#$site->{'other_mm'}
	#$site->{'p3'}
	#$site->{'p2'}
	#$site->{'p1'}
	#$site->{'p21'}
	#$site->{'guide'}
	
	#my $offCount = 0;
	#my $gid = $gene_id;
	#$gid =~ s/\.\d+$//;
	#my @results;
	#open TF, "/var/www/asrp/sites/amirna/new/targetfinder.pl -s $site->{'guide'} -d $mRNAdb -q guide |";
	#while (my $line = <TF>) {
	#	if ($line =~ /^HIT=/) {
	#		if ($line !~ /$gid/) {
	#			$offCount++;
	#		}
	#		next;
	#	}
	#	push @results, $line;
	#}
	#close TF;
	#return ($offCount, @results);
}

########################################
# Function: parse_list
# Parses deliminated lists into an array
########################################
sub parse_list {
	my $sep = shift;
  my ($flatList) = @_;
  my @final_list;

  # put each deliminated entry in an array
  if ($flatList =~ /$sep/) {
    @final_list = split (/$sep/,$flatList);
  } else {
    push(@final_list,$flatList);
  }
 return @final_list;
}

########################################
# Function: var_check
# Parse Getopt variables
########################################
sub var_check {
	if ($opt{'h'}) {
		var_help();
	}
	if (!$opt{'a'} && !$opt{'f'}) {
		print STDERR "An input sequence or a gene accession ID were not provided!\n";
		var_help();
	}
	if ($opt{'a'}) {
		@accessions = parse_list(',', $opt{'a'});
		if ($opt{'s'}) {
			$species = $opt{'s'};
		} else {
			print STDERR "A species name was not provided!\n";
			var_help();
		}
	}
	if ($opt{'f'}) {
		$fasta = $opt{'f'};
		if ($opt{'s'}) {
			$species = $opt{'s'};
		}
	}
	if ($opt{'t'}) {
		$fb = $opt{'t'};
	} else {
		$fb = 'eudicot';
	}
}

########################################
# Funtion: var_help
# Print help menu
########################################
sub var_help {
	print STDERR "\n";
	print STDERR "This script is the amiRNA and syntasiRNA designer tools main program.\n";
	print STDERR "Usage: designer_tool.pl\n\n";
	print STDERR " -t <Foldback type>  [STRING]  DEFAULT = eudicot\n";
	print STDERR " -f <Fasta sequence> [STRING]  Fasta-formatted sequence. Not used if -a is used.\n\n";
	print STDERR " -a <Accession>      [STRING]  Gene accession(s). Can be a single accession or comma-separated list. Not used if -f is used.\n\n";
	print STDERR " -s <Species>        [STRING]  Species. Required if -a is used.\n";
	print STDERR " -o                  [BOOLEAN] Predict off-target transcripts? Filters guide sequences to minimize/eliminate off-targets.\n\n";
	print STDERR " -h                  [BOOLEAN] Print this menu.\n\n";
	exit 1;
}

################################################################################
# End functions
################################################################################

## Deprecated
########################################
# Function: eval_tsite
# Evaluate target site based on design rules
########################################
sub eval_tsite {
	my $site = shift;
	if ($site =~ /[AG]$/) {
		return 1;
	} else {
		return 0;
	}
}