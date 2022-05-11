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
package Kea::IO::Fasta::_ToHandlerReader;
use Kea::Object;
use Kea::IO::IReader;
our @ISA = qw(Kea::Object Kea::IO::IReader);

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

sub read {

	my $self 		= shift;
	my $FILEHANDLE 	= $self->check(shift);
	my $handler 	= $self->check(shift, "Kea::IO::Fasta::IReaderHandler");
	
	my $header = undef;
	my $sequence = undef;
	
	while (<$FILEHANDLE>) {
		
		
		s/\r//;
		
		next if /^\s*$/;
		
		# e.g. 
		#>gi|30407139|emb|AL111168.1| Campylobacter jejuni subsp. jejuni NCTC 11168 complete genome
		#>gi|57165696|gb|CP000025.1| Campylobacter jejuni RM1221, complete genome
		
		if (/^>(.+)$/) {
			
			if (defined $sequence) {
	
				$sequence =~ s/[\s\d]//g;
				
				$handler->_nextHeader($header);
				$handler->_nextSequence($sequence);
				$sequence = undef;
				$header = undef;
				}
		
			$header = $1;
			
			}
		
		else {
			$sequence .= $_;
			}
		
		} # End of while - no more lines to parse.
	
	# Process last sequence.
	$handler->_nextHeader($header);
	$sequence =~ s/[\s\d]//g or $self->warn("No sequence for header '$header': $sequence");
	$handler->_nextSequence($sequence);
		
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

