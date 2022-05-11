#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 30/07/2008 11:02:11
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
package Kea::Statistics::LikelihoodRatioTest::_Result;
use Kea::Object;
use Kea::Statistics::LikelihoodRatioTest::IResult;
our @ISA = qw(Kea::Object Kea::Statistics::LikelihoodRatioTest::IResult);
 
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
		_df		=> $args{-df},
		_lrt 	=> $args{-lrt},
		_lowerP	=> $args{-lowerP},
		_upperP => $args{-upperP}
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

sub getLRT {
	return shift->{_lrt};
	} # End of method.

sub getdf {
	return shift->{_df};
	} # End of method.

sub getUpperP {
	return shift->{_upperP};
	} # End of method.

sub getLowerP {
	return shift->{_lowerP};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self = shift;
	my $lrt = $self->getLRT;
	my $upperP = $self->getUpperP;
	my $lowerP = $self->getLowerP;
	
	return "$lrt: $upperP < P < $lowerP";
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

