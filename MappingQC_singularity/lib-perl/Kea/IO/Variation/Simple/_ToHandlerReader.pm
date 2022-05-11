#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 25/04/2008 11:54:14
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
package Kea::IO::Variation::Simple::_ToHandlerReader;
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
	
	my $handler	=
		$self->check(shift, "Kea::IO::Variation::Simple::IReaderHandler");
	
	while (<$FILEHANDLE>) {
		
		# 34	34	two-Ia	454	G	A
		if (/^(\d+)\t(\d+)\t([\S\|]+)\t([\S\|]+)\t([\w\|]+)\t([\w\|]+)$/) {
			$handler->_nextLine(
				$1,	# before start
				$2,	# before end
				$3,	# before id
				$4,	# after id.
				$5,	# before allele.
				$6,	# after allele.
				);
			}
		
		# 34	34	two-Ia	454	G	A	[key=value;key;value;...]
		elsif (/^(\d+)\t(\d+)\t([\S\|]+)\t([\S\|]+)\t([\w\|]+)\t([\w\|]+)\t\[(.+)\]$/) {
			$handler->_nextLine(
				$1,	# before start
				$2,	# before end
				$3,	# before id
				$4,	# after id.
				$5,	# before allele.
				$6,	# after allele.
				$7	# attributes string.
				);
			}
		
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

