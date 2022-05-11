#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 05/08/2008 10:12:07
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
package Kea::IO::SOLiD::MatchFile::_MatchResult;
use Kea::Object;
use Kea::IO::SOLiD::MatchFile::IMatchResult;
our @ISA = qw(Kea::Object Kea::IO::SOLiD::MatchFile::IMatchResult);
 
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
	
	my $id = Kea::Object->check(shift);
	my $hitCollection =
		Kea::Object->check(shift, "Kea::IO::SOLiD::MatchFile::HitCollection");
	
	my $self = {
		_id 			=> $id,
		_hitCollection 	=> $hitCollection
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

sub getHitCollection {
	return shift->{_hitCollection};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self 			= shift;
	my $id 				= $self->getId;
	my $hitCollection 	= $self->getHitCollection;
	
	return "$id," . $hitCollection->toString;
	
	} #ÊEnd of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

