#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 14/05/2008 16:54:03
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
package Kea::IO::SwissProt::_SwissProtRecord;
use Kea::Object;
use Kea::IO::SwissProt::ISwissProtRecord;
our @ISA = qw(Kea::Object Kea::IO::SwissProt::ISwissProtRecord);
 
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
	my %args = @_;
	
	my $self = {
		_entryName 			=> $args{-entryName},
		_dataClass 			=> $args{-dataClass},
		_moleculeType 		=> $args{-moleculeType},
		_accessions			=> $args{-accessions},
		_sequence 			=> $args{-sequence},
		_molecularWeight 	=> $args{-molecularWeight},
		_sequence64bitCRC 	=> $args{-sequence64bitCRC},
		_description		=> $args{-description}
		};
	
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

sub getEntryName {
	return shift->{_entryName};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getDataClass {
	return shift->{_dataClass};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getMoleculeType {
	return shift->{_moleculeType};
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLength {
	return length(shift->{_sequence});
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAccessions {
	return shift->{_accessions};
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSequence {
	return shift->{_sequence};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getMolecularWeight {
	return shift->{_molecularWeight};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getDescription {
	return shift->{_description};
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

# see http://www.expasy.org/sprot/userman.html#SQ_line
sub getSequence64bitCRC {
	return shift->{_sequence64bitCRC};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

