#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 
#    Copyright (C) 2008, University of Liverpool.
#    Author: Kevin Ashelford.
#
#    Contact details:
#    Email: k.ashelford@liv.ac.uk
#    Address:  School of Biological Sciences, University of Liverpool, 
#    Biosciences Building, Crown Street, Liverpool, UK. L69 7ZB
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
#===============================================================================

#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////

# CLASS NAME
package Kea::Clustering::OrthoMCL;

## Purpose		: Wrapper class for orthoMCL program for clustering orthologs.

use strict;
use warnings;
use Cwd "abs_path";

use constant TRUE => 1;
use constant FALSE => 0;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

## Purpose		: Constructor.
## Returns		: n/a.
## Parameter	: n/a.
## Throws		: n/a.
sub new {
	my $className = shift;
	my $self = {
		_clusters => []
		};
	bless(
		$self,
		$className
		);
	return $self;
	} # End of constructor.

################################################################################

# METHODS

## Purpose		: Runs orthoMCL script clustering supplied protein records into orthologous groupings.
## Returns		: 2 dimensional array of protein code (e.g. accession) strings.
## Parameter	: -pathToOrthomcl = full path to orthoMCL script (required by orthomcl_module.pm).
##ÊParameter	: -orthomclDataDir = full path to directory containing protein fasta files to process (required by orthomcl_module.pm).
## Parameter	: -orthomclWorkingDir = full path to directory to where outfiles will be stored (required by orthomcl_module.pm).
## Parameter	: -mode = Integer value indicating orthomcl.pl mode.
## Throws		: n/a.
sub run {
	my ($self, %args) = @_;
	
	my $mode = $args{-mode} or die "ERROR: No mode value provided. ";
	
	# Note these parameters are required by the orthomcl_module.pm.  Unfortunately these values need to be
	# hard-coded in this module - see below (use of TEMPLATE).
	my $pathToOrthomcl = $args{-pathToOrthomcl} or die "ERROR: No path to orthoMCL program provided.  ";
	my $orthomclDataDir = $args{-orthomclDataDir} or die "ERROR: No data directory provided.  ";
	my $orthomclWorkingDir = $args{-orthomclWorkingDir} or die "ERROR: No working directory provided.  ";
	
	# NOTE: important paramaters hardcoded into orthomcl_module.pm - long-term, think about changing this.
	open(TEMPLATE, "$pathToOrthomcl/template.txt") or die "ERROR: Could not open orthomcl_module.pm template file.  ";
	open(OUT, ">$pathToOrthomcl/orthomcl_module.pm") or die "ERROR: Could not create orthomcl_module.pm.  ";
	while(<TEMPLATE>) {
		s/__ORTHOMCL_DATA_DIR__/$orthomclDataDir/;
		s/__PATH_TO_ORTHOMCL__/$pathToOrthomcl/;
		s/__ORTHOMCL_WORKING_DIR__/$orthomclWorkingDir/;
		print OUT;
		}
	close(OUT);
	close(TEMPLATE);
	
	# orthomcl_module.pm has now been written - can now construct and run orthomcl.pl command:
	
	# Get list of files from which orthoMCL command can be constructed.
	opendir (DIR, "$orthomclDataDir") or die "ERROR: Could not open directory '$orthomclDataDir'.\n";
	my $file;
	my @files;
	while (defined ($file = readdir(DIR))) {
		# Only consider FASTA files.
		if ($file !~ m/(\.fas)|(\.fa)$/) {next;}
		# Store FASTA file.
		push(@files, $file);	
		} # End of while - no more files to process.
	close(DIR);
	print scalar(@files) . " files will be passed to orthoMCL...\n";
		
	# Create list of fasta filenames to pass to orthoMCL. 
	my $fileString = join(",", @files);
	
	# Run perl script.
	my $command = "$pathToOrthomcl/orthomcl.pl --mode $mode --fa_files \"$fileString\"";
	
	print
		"\n".
		"\t--------------------\n".
		"\t Running OrthoMCL...\n".
		"\t--------------------\n".
		"\n";
	system($command);
	print
		"\n".
		"\t----------------------\n".
		"\t ...OrthoMCL finished \n".
		"\t----------------------\n".
		"\n";
	
	
	# If successful, orthomcl.pl should write an outfile 'all_orthomcl.out' to its working directory
	# (defined above).  File contains a clustering of protein codes (e.g. accessions).
	# Last step therefore is to parse these clustered data to a two-dimensional array.  
	
	# Parse outfile, extracting clusters.
	# Outfile should exist in $OUT_DIRECTORY directory created by program.
	open(RESULTS, "$orthomclWorkingDir/all_orthomcl.out") or die "Could not open outfile.  ";
	
	# Will create a two-dimensional array [cluster number][protein code].
	# i.e.
	# [cluster 1] [code 1, code 2..., code n]
	# [cluster 2] [code 1, code 2..., code m]
	# ...
	# [cluster k] [code 1, code 2] for example.
	
	my @clusters;
	while (<RESULTS>) {
		
		if (/ORTHOMCL(\d+)\(\d+ genes,\d+ taxa\):\s+(.+)$/) {
			
			my @currentCluster;
			push(@clusters, \@currentCluster);
			
			my $data = $2;
			my @proteinInfo = split(" ", $data);
			foreach my $info (@proteinInfo) {
				if ($info =~ m/(.+)\(.+\)/) {
					# Add current protein code to current cluster.
					push(@currentCluster, $1);
					}
				}
			} # End of if block.
		
		
		} # End of while block - no more ORTHOMCL lines remaining.
	
	close(RESULTS);
	
	return @clusters;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

