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
package Kea::Parsers::Phylip::Interleaved::Parser;

use Kea::Parsers::_AbstractParser;
our @ISA = "Kea::Parsers::_AbstractParser";

## Purpose		: Parses interleaved phylip formatted sequence files.

use strict;
use warnings;

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
	my ($className, $filehandle) = @_;
	
	my $sequenceNumber;
	my $alignmentLength;
	my @codes;
	my @sequences;
	my $counter = 0;
	
	while(<$filehandle>) {
		if (/^\s+(\d+)\s+(\d+)\s*$/) {
			$sequenceNumber = $1;
			$alignmentLength = $2;
			}
		
		# EAT99685   --MLKK---- -VANKIALII LVLLTISFAI FATISYENTQ STILEFSKTA
		elsif (/^(\w+)\s+(.+)$/) {
			push(@codes, $1);
			push(@sequences, $2);
			}
		
		elsif (/^\s+$/) {
			$counter = 0;
			}
		
		elsif (/^\s+(.+)/) {
			$sequences[$counter] = $sequences[$counter] . $1;
			$counter++;	
			}
		
		} # End of while.
	
	
	my $self = {
		_headers => \@codes,
		_sequences => \@sequences,
		_codes => \@codes
		};
	
	bless(
		$self,
		$className
		);
	return $self;
	
	
	} # End of constructor.

################################################################################


################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

