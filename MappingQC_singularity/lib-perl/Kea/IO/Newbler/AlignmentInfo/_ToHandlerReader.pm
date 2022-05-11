#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 07/05/2008 15:23:17
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
package Kea::IO::Newbler::AlignmentInfo::_ToHandlerReader;
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
	my $handler =
		$self->check(shift, "Kea::IO::Newbler::AlignmentInfo::IReaderHandler");
	
	while (<$FILEHANDLE>) {
		
		# Position        Consensus       Quality Score   Depth   Signal  StdDeviation
		# >contig00001    1
		if (/^>(\S+)\s+(\d+)\s*$/) {
		
			print;
		
			$handler->_nextHeader(
				$1, # Contig name
				$2	# Number (?)
				);
			
			}
		
		# 1       C       64      16      2.93    0.85
		# 2       C       64      16      2.93    0.85
		# 3       C       18      16      2.93    0.85
		# 4       T       64      16      2.91    0.80
		# 5       T       64      16      2.91    0.80
		# 6       T       19      16      2.91    0.80
		# 7       G       64      16      0.98    0.31
		# 8       T       64      16      0.94    0.30
		elsif (/^(\d+)\s+(\w)\s+(\d+)\s+(\d+)\s+([\.\d]+)\s+([\.\d]+)$/) {
			
			$handler->_nextInfoLine(
				$1,	# Position in contig.
				$2,	# consensus base.
				$3,	# quality score.
				$4,	# depth.
				$5,	# Signal.
				$6	# Standard deviation.
				);
			}
		
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

