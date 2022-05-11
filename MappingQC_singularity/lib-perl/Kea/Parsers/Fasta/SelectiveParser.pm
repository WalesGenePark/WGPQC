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
package Kea::Parsers::Fasta::SelectiveParser;

use Kea::Parsers::_AbstractParser;
our @ISA = "Kea::Parsers::_AbstractParser";


## Purpose		: Selectively, parses fasta files according to provide list of record codes (e.g. accessions).

use strict;
use warnings;

use constant TRUE => 1;
use constant FALSE => 0;

################################################################################

# CLASS FIELDS

################################################################################

# PRIVATE METHODS

# Private method: returns true if supplied header string contains code for sequence to be parsed.
my $parseThisRecord = sub {
	my ($header, @codes) = @_;
	
	foreach my $code (@codes) {
		if ($header =~ m/$code/) {
			return TRUE;
			} 
		}
	return FALSE;
	};

################################################################################


# CONSTRUCTOR

## Purpose		: Constructor.
## Returns		: n/a.
## Parameter	: n/a.
## Throws		: n/a.
sub new {
	my ($className, $filehandle, @codes) = @_;
	
	my @headers;
	my @sequences;
	my $sequence;
	
	my $header;
	while (<$filehandle>) {
		chomp;
		# If a header is encountered...
		if (/^>(.+)$/) {
		
			# If previous header is active...
			if ($header) {
				# Store existing data and clear variables.
				push(@headers, $header); 
				push(@sequences, $sequence);
				$header = "";
				$sequence = "";
				}
			
			# If header represents sequence to be processed, proceed.
			if ($parseThisRecord->($1, @codes)) {
				$header = $1;
				} 
		
			}
		# If sequence data are encountered and is to be stored...
		elsif (/^(\w+)/ && $header) {
			$sequence = $sequence . $1;
			}
		
		} # End of while - no more lines to process.
	
	# store final header and sequence.
	if ($header) {
		push(@headers, $header); 
		push(@sequences, $sequence);
		}
	
	# Check same no of headers and sequences!
	scalar(@headers) == scalar(@sequences) or die "ERROR: The number of headers and sequences do not match! Parsing failed.  Check that file is correctly formatted.  "; 
	
	# Check that all requested codes have been selected (check no. of codes equals no of headers extracted).
	scalar(@headers) == scalar(@codes) or die "ERROR: The number of headers and requested codes do not mtach! Parsing failed.\nAre you sure the file contains all the records requested? ";
	
	my $self = {
		_headers => \@headers,
		_codes => \@codes,
		_sequences => \@sequences
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

