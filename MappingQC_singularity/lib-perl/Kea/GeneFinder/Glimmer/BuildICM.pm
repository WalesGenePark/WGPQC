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

# CLASS NAME
package Kea::GeneFinder::Glimmer::BuildICM;
use Kea::Object;
our @ISA = qw(Kea::Object);

use strict;
use warnings;

use constant TRUE => 1;
use constant FALSE => 0;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

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

## Purpose		: Runs program with parameters provided.
## Returns		: n/a.
## Parameter	: -outfile = Name of outfile to write ICM to.
## Parameter	: -trainingFile = Name of fasta formatted file containing training gene DNA sequences.
## Parameter	: -r If true, model is built in the backwards direction (default).
sub run {
	my ($self, %args) = @_;
	
	my ($r, $outfile, $trainingFile);
	
	$r = $args{-r} or $r = TRUE;
	$outfile = $args{-outfile} or $self->throw("No outfile name provided.  Use -outfile flag.");
	$trainingFile = $args{-training} or $self->throw("No training data file provided.  Use -training flag.");
	
	# Construct build-icm command.
	my $command = "build-icm ";
	if ($r) {$command = $command . "-r ";}
	$command = $command . "$outfile < $trainingFile";
	
	print 
		"\n".
		"\t---------------------\n".
		"\t Running build-icm...\n".
		"\t---------------------\n".
		"\n";
	
	system($command) == 0 or $self->throw("build-icm failed to run.");

	print 
		"\n".
		"\t-----------------------\n".
		"\t ...build-icm finished \n".
		"\t-----------------------\n".
		"\n";
	
		
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

