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
package Kea::GeneFinder::Glimmer::Glimmer3;

## Purpose		: Wrapper class for glimmer3 program.

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

# PUBLIC METHODS

## Purpose		: ?????????????.
## Returns		: n/a.
## Parameter	: n/a.
## Throws		: n/a.
sub run {
	my ($self, %args) = @_;
	
	my ($infile, $icmFile, $tag);
	
	$infile = $args{-in} or die "ERROR: No infile provided.  Use -in flag.";
	$icmFile = $args{-icm} or die "ERROR: No ICM model file provided.  Use -icm flag.";
	$tag = $args{-tag} or die "ERROR: No tag provided.  Use -tag flag.";
	
	# Construct command.
	# NOTE - for now will use as defaults flags used in glimmer-provided scripts.
	my $command = "glimmer3 -o50 -g110 -t30 -l $infile $icmFile $tag";
	
	print
		"\n".
		"\t---------------------\n".
		"\t Running glimmer3... \n".
		"\t---------------------\n".
		"\n";
	
	# Run command.
	system($command) == 0 or die "ERROR: glimmer3 failed to run. ";
	
	print
		"\n".
		"\t----------------------\n".
		"\t ...glimmer3 finished \n".
		"\t----------------------\n".
		"\n";
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

