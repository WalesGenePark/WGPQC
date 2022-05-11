#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 11/06/2008 12:24:30
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
package Kea::IO::Pfam::_PfamResult;
use Kea::Object;
use Kea::IO::Pfam::IPfamResult;
our @ISA = qw(Kea::Object Kea::IO::Pfam::IPfamResult);
 
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
		_queryId 		=> $args{-queryId},
		_queryLocation 	=> $args{-queryLocation},
		_hmmId			=> $args{-hmmId},
		_hmmLocation	=> $args{-hmmLocation},
		_bitScore		=> $args{-bitScore},
		_eValue			=> $args{-eValue},
		_hmmName		=> $args{-hmmName},
		_isNested		=> $args{-isNested}
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

sub getQueryId {
	return shift->{_queryId};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getQueryLocation {
	return shift->{_queryLocation};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getHmmId {
	return shift->{_hmmId};
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getHmmLocation {
	return shift->{_hmmLocation};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getBitScore {
	return shift->{_bitScore};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getEValue {
	return shift->{_eValue};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getHmmName {
	return shift->{_hmmName};
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub isNested {
	return shift->{_isNested};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

