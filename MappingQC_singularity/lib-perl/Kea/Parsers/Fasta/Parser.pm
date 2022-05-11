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
package Kea::Parsers::Fasta::Parser;

use Kea::Parsers::_AbstractParser;
our @ISA = "Kea::Parsers::_AbstractParser";


## Purpose		: Parses fasta formatted files.

use strict;
use warnings;
use Carp;

use constant TRUE => 1;
use constant FALSE => 0;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

## Purpose		: Constructor.
## Parameter	: Filehandle reference for file to parse.
sub new {
	my ($className, $filehandle) = @_;
	
	my @headers;
	my @sequences;
	my $sequence;
	
	while (<$filehandle>) {
		chomp;
		
		if (/^>(.+)$/) {
			if ($sequence) {
				push(@sequences, $sequence);
				$sequence = "";
				};
			push(@headers, $1);
			}
		elsif (/^([\w\-]+)/) {
			$sequence = $sequence . $1;
			}
		
		} # End of while - no more lines to process.
	
	# store final sequence.
	push(@sequences, $sequence);
	
	# Check same no of headers and sequences!
	my $n = scalar(@headers);
	my $m = scalar(@sequences);
	
	$n == $m or confess
		"\n".
		"\tXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n".
		"\tERROR: The number of headers ($n) and sequences ($m) do not match! Parsing failed.\n".
		"\tCheck that file is correctly formatted.\n" .
		"\tXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n".
		"\n"; 
	
	# Also extract codes from headers (if headers are complex).
	my @codes;
	foreach (@headers) {
		#>gi|57165696|gb|CP000025.1| Campylobacter jejuni RM1221, complete genome
		if (/gi\|\d+\|gb\|(\w+)/) {
			push(@codes, $1);
			}
	
		elsif (/^([\w\d]+)/) {
			push(@codes, $1);
			}
		else {
			confess
				"\n".
				"\tXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n".
				"\tERROR: Code regex failed to match!\n".
				"\tXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n".
				"\n";	
			}
		}
	# Check right number!
	scalar(@codes) == scalar(@headers) or die "ERROR: could not read codes from header lines! ";
	
	my $self = {
		_headers => \@headers,
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
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

