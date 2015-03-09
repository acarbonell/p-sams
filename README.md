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

## Optional Software
P-SAMS has the option to execute TargetFinder jobs on a batch system using the Terascale Open-source Resource and QUEue Manager (TORQUE; http://www.adaptivecomputing.com/products/open-source/torque/).

## Installation
Clone the P-SAMS repository with the TargetFinder submodule.
```
git clone --recursive https://github.com/carringtonlab/p-sams.git
```
Install the prerequisite software and libraries. For MySQL you will need permission to create databases and alter user privileges, but P-SAMS itself only needs a user with SELECT privileges on P-SAMS databases.



