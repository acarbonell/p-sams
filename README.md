# P-SAMS
Plant Small RNA Maker Suite

# Installing P-SAMS
## Minimum Software Requirements
- Tested on Perl v5.10.1 built for x86_64-linux-thread-multi
- Required Perl modules
  - Config::Tiny
  - DBI
  - HTML::Entities
  - Data::Dumper
- TargetFinder v1.7 (https://github.com/carringtonlab/TargetFinder)
- MySQL (http://www.mysql.com/)
- Samtools v0.1.19+ (http://www.htslib.org/)

## Optional Software
P-SAMS has the option to execute TargetFinder jobs on a batch system using the Terascale Open-source Resource and QUEue Manager (TORQUE; http://www.adaptivecomputing.com/products/open-source/torque/).

## Installation
Clone the P-SAMS repository with the TargetFinder submodule.
```
git clone --recursive https://github.com/carringtonlab/p-sams.git
```
Install the prerequisite software and libraries. For MySQL you will need permission to create databases and alter user privileges, but P-SAMS itself only needs a user with SELECT privileges on P-SAMS databases.

Copy the example configuration file into the main program directory. The user custom configuration file will be ignored by git updates. Add the MySQL hostname, username and password for the P-SAMS user.

```
cp ./include/example.psams.conf ./psams.conf
```

## Create a species database for P-SAMS
The following example uses specific files from http://phytozome.jgi.doe.gov, but any plant species can be added in principle.

1. From http://phytozome.jgi.doe.gov/ download the [species].transcript.fa.gz and [species].annotation_info.txt files for the desired species.
2. Unzip the FASTA file (gunzip [species].transcript.fa.gz).
3. Index the FASTA file with samtools (samtools faidx [species].transcript.fa).
3. Use the built-in script phytozome2psams.pl to process the Phytozome files (see the program instructions below).
4. Use the built-in script add_species.pl to create a kmer file from the FASTA file (see the program instructions below).
5. Create the MySQL database.
6. Add the FASTA file path and the MySQL species database name to psams.conf.

```
# Log into MySQL
# Create an empty database
CREATE DATABASE psams_[species];

# Grant select permissions to the P-SAMS user. Add additional security as necessary.
GRANT SELECT ON psams_[species].* TO 'psams_user'@'%';

# Use the mysql command-line tool to inialize the empty database with the P-SAMS schema
mysql -u admin_user -p psams_[species] < ./p-sams/include/structure.mysql

# Switch to the new database
USE psams_[species];

# Load the kmer file
LOAD DATA INFILE 'kmers.tab' INTO TABLE kmers FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n';

# Load the annotation file
LOAD DATA INFILE '[species].annotation.txt' INTO TABLE annotation FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n';
```

# psams.pl
# amiRNA_oligoDesigner.pl
# syntasiRNA_oligoDesigner.pl
# phytozome2psams.pl
# add_species.pl

