#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 14/02/2008 15:01:29 
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
package Kea::IO::BlastClust::_ToHandlerReader;
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
	
	my $self = shift;
	my $FILEHANDLE = shift;
	my $handler = Kea::Object->check(shift, "Kea::IO::BlastClust::IReaderHandler");
	
	while (<$FILEHANDLE>) {
		chomp;
		my @ids = split(/\s+/, $_);
		$handler->nextLine(@ids);
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

=pod

AL111168_CAL34416.1 AL111168_CAL35661.1 AL111168_CAL34315.1 1336_ORF_138 1336_ORF_245 1336_ORF_1716 
AL111168_CAL35450.1 AL111168_CAL35451.1 1336_ORF_1553 1336_ORF_1552 1336_ORF_1524 1336_ORF_1551 
AL111168_CAL34774.1 AL111168_CAL35773.1 1336_ORF_2130 1336_ORF_2079 
AL111168_CAL35202.1 1336_ORF_1264 1336_ORF_1252 1336_ORF_1253 
AL111168_CAL34903.1 1336_ORF_812 1336_ORF_811 1336_ORF_810 
1336_ORF_591 AL111168_CAL34670.1 AL111168_CAL34668.1 AL111168_CAL34669.1 
AL111168_CAL35421.1 1336_ORF_1523 1336_ORF_1522 1336_ORF_1663 
AL111168_CAL35420.1 AL111168_CAL35419.1 1336_1336_joined_160 1336_ORF_1519 
1336_ORF_934 AL111168_CAL34997.1 AL111168_CAL34998.1 AL111168_CAL34996.1 
AL111168_CAL35583.1 1336_ORF_1822 1336_ORF_1646 
AL111168_CAL34908.1 1336_ORF_818 1336_ORF_819 
AL111168_CAL34656.1 1336_ORF_525 1336_ORF_526 
AL111168_CAL34676.1 1336_ORF_584 1336_ORF_585 
1336_1336_joined_36 AL111168_CAL34527.1 AL111168_CAL34526.1 
AL111168_CAL35225.1 1336_ORF_1293 1336_ORF_1294 
AL111168_CAL34641.1 1336_ORF_515 1336_ORF_547 
1336_ORF_202 AL111168_CAL34357.1 AL111168_CAL34358.1 
AL111168_CAL34905.1 1336_ORF_814 1336_ORF_815 
AL111168_CAL34753.1 1336_ORF_646 1336_ORF_647 
AL111168_CAL34928.1 1336_ORF_859 1336_ORF_860 
AL111168_CAL35491.1 1336_ORF_1604 1336_ORF_1603 
AL111168_CAL35247.1 1336_ORF_1320 1336_ORF_1319 
1336_ORF_2008 AL111168_CAL35807.1 AL111168_CAL35806.1 
AL111168_CAL35123.1 1336_ORF_1185 1336_1336_joined_130 
1336_ORF_1239 AL111168_CAL35072.1 AL111168_CAL35071.1 
AL111168_CAL35476.1 1336_ORF_1584 1336_1336_joined_162 
AL111168_CAL35054.1 1336_ORF_1027 1336_ORF_1028 
AL111168_CAL34846.1 1336_ORF_758 1336_ORF_759 
AL111168_CAL34658.1 1336_ORF_523 1336_ORF_601 
AL111168_CAL34803.1 1336_ORF_707 1336_ORF_708 
AL111168_CAL35685.1 1336_ORF_1863 1336_ORF_1864 
AL111168_CAL34701.1 1336_ORF_559 1336_ORF_557 
AL111168_CAL34458.1 1336_ORF_401 1336_ORF_400 


=cut