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
package Kea::Parsers::Glimmer::PredictFile::Parser;

## Purpose		: 

use strict;
use warnings;
use Carp;

use constant TRUE => 1;
use constant FALSE => 0;

use Kea::Parsers::Glimmer::PredictFile::AbstractHandler;

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
sub parse {
	my ($self, $FILEHANDLE, $handler) = @_;
	
	$handler->isa("Kea::Parsers::Glimmer::PredictFile::AbstractHandler")
		or confess "\nERROR: Method requires a Kea::Parsers::Glimmer::PredictFile::AbstractHandler object";
	
	while(<$FILEHANDLE>) {
		
		# >contig00001  length=55125   numreads=2530
		if (m/>(\w+)\s+length=(\d+)\s+numreads=(\d+)/) {
			$handler->nextHeader(
				$1,	# Contig id, e.g. contig00001
				$2,	# Contig length.
				$3	# Number of reads.
				);
			}
		
		# >contig00001
		elsif (m/>(\w+)/) {
			$handler->nextHeader(
				$1,	# Contig id, e.g. contig00001
				undef,	# Contig length.
				undef	# Number of reads.
				);
			}
		
		# orf00094    74985    75770  +3    11.75
		elsif (m/(orf\d+)\s+(\d+)\s+(\d+)\s+([+-]\d)\s+(\d+\.\d+)/) {
			$handler->nextORF(
				$1, # orf id. e.g. orf00001
				$2, # start position
				$3, # end position
				$4, # reading frame
				$5	# raw score
				);
			}
		
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

