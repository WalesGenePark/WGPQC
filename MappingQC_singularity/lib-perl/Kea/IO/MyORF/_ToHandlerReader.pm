#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 05/08/2009 16:53:14
#    Copyright (C) 2009, University of Liverpool.
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
package Kea::IO::MyORF::_ToHandlerReader;
use Kea::IO::IReader;
use Kea::Object;
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
	my $handler		= $self->check(shift, "Kea::IO::MyORF::IReaderHandler");
	
	while (<$FILEHANDLE>) {
	
		if (/^>(.+)$/) {
			$handler->_nextHeader($1);
			}
		elsif (/^(\S+)\t(<{0,1}\d+)\t(>{0,1}\d+)\t(\w+)\t(glimmer|genemark|glimmer\/genemark)\t(.+)$/) {
			$handler->_nextORF(
				$1,	# id
				$2,	# start
				$3,	# end
				$4,	# orientation
				$5, # program
				$6	# note
				);
			}
	
		else {
			$self->throw("Line unaccounted for: '$_'.");
			}
	
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

