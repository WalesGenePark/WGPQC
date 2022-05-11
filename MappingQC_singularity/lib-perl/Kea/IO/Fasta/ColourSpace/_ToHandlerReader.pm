#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 04/08/2008 11:17:58
#    Copyright (C) 2008, University of Liverpool.
#    Author: Kevin Ashelford.
#
#    Contact details:
#    Email:   k.ashelford@liv.ac.uk
#    Address: School of Biological Sciences, University of Liverpool, 
#             Biosciences Building, Crown Street, Liverpool, UK. L69 7ZB
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
package Kea::IO::Fasta::ColourSpace::_ToHandlerReader;
use Kea::Object;
use Kea::IO::IReader;
our @ISA = qw(Kea::Object Kea::IO::IReader);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

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
	
	my $self = shift;
	my $FILEHANDLE = $self->check(shift);
	my $handler = $self->check(shift, "Kea::IO::Fasta::ColourSpace::IReaderHandler");

	my $header = undef;
	my $sequence = undef;
	
	while (<$FILEHANDLE>) {
		
		s/\r//;
		
		# Ignore empty lines.
		next if /^\s*$/;
		
		# Ignore comments.
		next if /^#/;
		
		#>600_50_31_F3
		#T2222002113300322132112231
		#>600_50_63_F3
		#T2330133212130133221033110
		#>600_50_100_F3
		#T0130001131012310201000101
		#>600_50_170_F3
		#T1002312103033121321233103
		#>600_50_174_F3
		#T0330022330332000323031121
		#>600_50_241_F3
		#T2103103103100212123030011
		#>600_50_256_F3
		#T0301131010233311200223332
		#>600_50_329_F3
		#T1303211033112301303220000
		#>600_50_342_F3
		#T2100003012212000310130111
		#>600_50_353_F3
		#T1010323020000033202110102
		if (/^>(.+)$/) {
			
			if (defined $sequence) {
	
				$sequence =~ s/[\s]//g;
				
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
	$sequence =~ s/[\s]//g or $self->warn("No sequence for header '$header': $sequence");
	$handler->_nextSequence($sequence);
		
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

