#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 07/05/2008 17:29:37
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
package Kea::IO::NCBI::AGP::_ToHandlerReader;
use Kea::Object;
use Kea::IO::IReader;
our @ISA = qw(Kea::Object Kea::IO::IReader);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;

use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant UNKNOWN	=> "unknown";
use constant NA			=> "not applicable";

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

	my $self 		= shift;
	my $FILEHANDLE 	= $self->check(shift);
	my $handler 	= $self->check(shift, "Kea::IO::NCBI::AGP::IReaderHandler");
	
	while (<$FILEHANDLE>) {
		
		# scaffold00001   1       152535  1       W       contig00002     1       152535  +
		# scaffold00002   1       47448   1       W       contig00003     1       47448   +
		
		# Ignore comments.
		next if /^#/;

		if (/^(\S+)\t(\d+)\t(\d+)\t(\d+)\t([ADFGOPW])\t(\S+)\t(\d+)\t(\d+)\t(\+|\-|0|na)$/) {
			$handler->_nextLineA(
				$1,	# id 	(object)
				$2,	# start (object_beg)
				$3,	# end 	(object_end)
				$4,	# part_number 		- The line count for the components/gaps that make up the object
				$5,	# component_type 	- The sequencing status of the component.
				$6,	# component_id		- If column 5 not equal to N: This is a unique identifier for the sequence component contributing to the object described in column 1.
				$7,	# component_beg		- If column 5 not equal to N: This column specifies the beginning of the part of the component sequence that contributes to the object in column 1
				$8,	# component_end		- If column 5 not equal to N: This column specifies the end of the part of the component that contributes to the object in column 1.
				$9	# orientation		- If column 5 not equal to N: This column specifies the orientation of the component relative to the object in column 1.
				);
			}
		
		# scaffold00002   47449   47477   2       N       29      fragment        yes
		elsif (/^(\S+)\t(\d+)\t(\d+)\t(\d+)\t([NU])\t(\d+)\t(fragment|clone|contig|centromere|short_arm|heterochromatin|telomere|repeat)\t(yes|no)\t*$/) {
			
			$handler->_nextLineB(
				$1,	# id 	(object)
				$2,	# start (object_beg)
				$3,	# end 	(object_end)
				$4,	# part_number 		- The line count for the components/gaps that make up the object
				$5,	# component_type 	- The sequencing status of the component - N.
				$6,	# gap_length		- If column 5 equal to N: This column represents the length of the gap.
				$7,	# gap_type			- If column 5 equal to N: This column specifies the gap type.
				$8	# linkage			- If column 5 equal to N: This column indicates if there is evidence of linkage between the adjacent lines.
				);
			
			}
		
		else {
			$self->throw("Unexpected line:\n\t$_");
			}
		
		}
	
	$handler->_endOfFile;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

