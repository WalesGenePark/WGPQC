#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 15/05/2008 15:53:03
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
package Kea::IO::tRNAscan::_tRNAResult;
use Kea::Object;
use Kea::IO::tRNAscan::ItRNAResult;
our @ISA = qw(Kea::Object Kea::IO::tRNAscan::ItRNAResult);
 
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
		_id 			=> $args{-id},
		_number 		=> $args{-number},
		_location 		=> $args{-location},
		_orientation	=> $args{-orientation},
		_type 			=> $args{-type},
		_anticodon		=> $args{-anticodon},
		_intronLocation => $args{-intronLocation},
		_coveScore 		=> $args{-coveScore}
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

sub getId {
	return shift->{_id};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getNumber {
	return shift->{_number};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLocation {
	return shift->{_location};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getOrientation {
	return shift->{_orientation};
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub getType {
	return shift->{_type};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAnticodon {
	return shift->{_anticodon};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getIntronLocation {
	return shift->{_intronLocation};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getCoveScore {
	return shift->{_coveScore};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

