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
package Kea::IO::Paml::Sequential::_ToHandlerReader;
use Kea::IO::IReader;
our @ISA = "Kea::IO::IReader";

## Purpose		: 

use strict;
use warnings;
use Carp;

use constant TRUE => 1;
use constant FALSE => 0;

use constant SENSE => "sense";
use constant ANTISENSE => "antisense";

use constant FASTA => "fasta";
use constant EMBL => "embl";
use constant UNKNOWN => "unknown";

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

my $store = sub {
	my ($handler, $id, $seq) = @_;
	
	#Êremove whitespace from sequence.
	$seq =~ s/\s//g;
	
	$handler->nextSequence($id, $seq);
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

## Purpose		: ?????????????.
## Returns		: n/a.
## Parameter	: n/a.
## Throws		: n/a.
sub read {
	my ($self, $FILEHANDLE, $handler) = @_;
	
	my $currentId = undef;
	my $currentSequence = undef;
	
	while (my $line = <$FILEHANDLE>) {
		
		if ($line =~ /^\s+(\d+)\s+(\d+)\w*$/) {
			$handler->header($1, $2);
			}
		
		elsif ($line =~ /^(\S+)\s+(.+)$/) {
		
			if (defined $currentId) {
				# Store previous sequence.
				$store->($handler, $currentId, $currentSequence);
				}
		
			$currentId = $1;
			$currentSequence = $2;
			}
		
		elsif ($line =~ /^(.+)$/) {
			$currentSequence = $currentSequence . $1;
			}
		
		}
	# Store last remaining sequence.
	$store->($handler, $currentId, $currentSequence);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

