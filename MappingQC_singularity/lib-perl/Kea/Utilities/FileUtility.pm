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
package Kea::Utilities::FileUtility;

## Purpose		: 

use strict;
use warnings;
use Carp;
use Kea::Arg;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use constant FASTA 		=> "fasta";
use constant EMBL 		=> "embl";
use constant GENBANK	=> "genbank";
use constant UNKNOWN 	=> "unknown";

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
	my $self = {};
	bless(
		$self,
		$className
		);
	return $self;
	} # End of constructor.

################################################################################

# METHODS

sub getFileType {
	my $self = shift;
	my $file = Kea::Arg->checkIsFile(shift);
	
	# FOR MOMENT CONCENTRATE ON FIRST LINE ONLY AND MAKE SIMPLE ASSUMPTIONS -
	# MAY CHANGE LATER IF INSUFFICIENT...
	open(IN, $file) or confess "\nERROR: Could not open $file";
	my $line = readline(IN);
	close(IN);
	
	# If line begin with '>' assume fasta.
	return FASTA if $line =~ /^>/;

	# If line begins with 'ID' assume embl.
	return EMBL if $line =~ /^ID/;
	
	return GENBANK if $line =~ /^LOCUS/;
		
	# otherwise return unknown.
	return UNKNOWN;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose		: Concatenates a list of files into a single file.
## Returns		: n/a.
## Parameter	: -outfile = Name of concatenated file.
## Parameter	: -files = Array of files to concatenate.
sub cat {
	my ($self, %args) = @_;
	
	my $outfile = $args{-outfile} or
		confess "ERROR: No outfile name provided.  Use -outfile flag.  ";
	my $fileList = $args{-infiles} or
		confess "ERROR: No file list provided.  Use -files flag.  ";
	
	
	open (OUT, ">$outfile") or confess "Could not create outfile: $outfile.\n";
	
	foreach my $file (@$fileList) {
		open (IN, "$file") or confess "Could not open tmp file: $file.\n";
		
		while(<IN>) {
			print OUT $_;
			}
		
		close(IN);
		}
	
	close(OUT);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

