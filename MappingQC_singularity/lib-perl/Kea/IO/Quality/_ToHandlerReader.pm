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
package Kea::IO::Quality::_ToHandlerReader;
use Kea::Object;
use Kea::IO::IReader;
our @ISA = qw(Kea::Object Kea::IO::IReader);

use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE		=> 0;
use constant SENSE		=> "sense";
use constant ANTISENSE	=> "antisense";

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
	my $FILEHANDLE	= $self->check(shift);
	my $handler 	= $self->check(shift);
	
	my $header = undef;
	my @scores = ();
	
	while (<$FILEHANDLE>) {
		
		#>000068_0497_2061 length=48 uaccno=EYOMRYE01BHYM3
		if (/^>(.+)$/) {
		
			if (@scores > 0) {
				
				$handler->_nextHeader($header);
				$handler->_nextQualityScores(\@scores);
				@scores = ();
				$header = undef;
				}
		
			$header = $1;
			}
		
		else {
			my @buffer = split(/\s+/, $_);
			push(@scores, @buffer);
			}
		
		} # End of while - no more lines to parse.
	
	# Process last sequence.
	$handler->_nextHeader($header);
	$handler->_nextQualityScores(\@scores);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

