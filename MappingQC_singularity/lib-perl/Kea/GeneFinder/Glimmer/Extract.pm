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
package Kea::GeneFinder::Glimmer::Extract;

## Purpose		: Wrapper class for extract program.

use strict;
use warnings;

use constant TRUE => 1;
use constant FALSE => 0;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

## Purpose		: Constructor.
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

#ÊPRIVATE METHODS

my $privateMethod = sub {
	
	}; # End of method.

################################################################################

## Purpose		: ?????????????.
## Returns		: n/a.
## Parameter	: n/a.
## Throws		: n/a.
sub run {
	my ($self, %args) = @_;
	
	my ($sequenceFile, $coordsFile, $outfile);
	
	$sequenceFile = $args{-sequence} or die "ERROR: No sequence file provided.  Use -sequence flag.";
	$coordsFile = $args{-coords} or die "ERROR: No coordinates file provided.  Use -coords flag.";
	$outfile = $args{-outfile} or die "ERROR: No outfile provided.  Use -outfile flag.";
	
	# Construct command.
	my $command = "extract $sequenceFile $coordsFile > $outfile";
	
	print
		"\n".
		"\t--------------------\n".
		"\t Running extract... \n".
		"\t--------------------\n".
		"\n";
		
	# Run command.
	system($command) == 0 or die "ERROR: extract failed to run. ";
	
	print
		"\n".
		"\t---------------------\n".
		"\t ...extract finished \n".
		"\t---------------------\n".
		"\n";
	
	
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

