#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 17/02/2008 07:12:00 
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
package Kea::IO::Mummer::ShowCoords::_ToHandlerReader;
use Kea::Object;
use Kea::IO::IReader;
our @ISA = qw(Kea::Object Kea::IO::IReader);

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

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
	my $handler 	= $self->check(shift, "Kea::IO::Mummer::ShowCoords::IReaderHandler"); 
	
	while(<$FILEHANDLE>) {
		
		if (/^\s*(\d+)\s+(\d+)\s+\|\s+(\d+)\s+(\d+)\s+\|\s+(\d+)\s+(\d+)\s+\|\s+(\d+\.\d+)\s+\|\s+(.+)\s+(.+)$/) {
		
			$handler->_nextLine(
				$1, # S1
				$2, # E1
				$3, # S2
				$4, # E2
				$5,	# LEN 1
				$6,	# LEN 2
				$7,	# % IDY
				$8,	# first TAG
				$9	# second TAG
				);
			}
		
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

=start
    [S1]     [E1]  |     [S2]     [E2]  |  [LEN 1]  [LEN 2]  |  [% IDY]  | [TAGS]
=====================================================================================
  438110   487757  |        1    49642  |    49648    49642  |    97.84  | gi|57165696|gb|CP000025.1|   contig00001
  487752   492261  |    50619    55125  |     4510     4507  |    93.82  | gi|57165696|gb|CP000025.1|   contig00001
  434519   438069  |     3604       32  |     3551     3573  |    98.63  | gi|57165696|gb|CP000025.1|   contig00002
  786134   803620  |     1331    18863  |    17487    17533  |    95.69  | gi|57165696|gb|CP000025.1|   contig00004
  668540   711217  |        7    42627  |    42678    42621  |    97.45  | gi|57165696|gb|CP000025.1|   contig00005
  711207   723320  |    42749    54851  |    12114    12103  |    97.50  | gi|57165696|gb|CP000025.1|   contig00005
  727219   742249  |    54888    69911  |    15031    15024  |    97.61  | gi|57165696|gb|CP000025.1|   contig00005
  609439   653303  |       13    43877  |    43865    43865  |    97.38  | gi|57165696|gb|CP000025.1|   contig00006
  654687   663843  |    43960    53118  |     9157     9159  |    96.26  | gi|57165696|gb|CP000025.1|   contig00006
 1426894  1445933  |     2067    21114  |    19040    19048  |    96.68  | gi|57165696|gb|CP000025.1|   contig00008
 1448562  1452912  |    24298    28649  |     4351     4352  |    97.91  | gi|57165696|gb|CP000025.1|   contig00008

=cut