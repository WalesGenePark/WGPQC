#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 21/03/2008 16:59:14
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
package Kea::Math::Toolkit;
use Kea::Object;
our @ISA = qw(Kea::Object);
 
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

sub getFactorial {
	
	my $self 	= shift;
	my $n 		= $self->checkIsNonNegativeInt(shift);
	my $result 	= 1;
	
	$result *= $n-- while $n > 1;
	
	return $result;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getPermutation {
	
	my $self 	= shift;
	my $n 		= $self->checkIsPositiveInt(shift);
	my $k 		= $self->checkIsPositiveInt(shift);
	my $result 	= 1;
	
	while ($k--) {$result *= $n--;}
	
	return $result;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getCombination {
	
	my $self = shift;
	my $n = $self->checkIsPositiveInt(shift);
	my $k = $self->checkIsPositiveInt(shift);
	
	my ($result, $j) = (1, 1);
	
	$k = ($n - $k) if ($n - $k) < $k;
	
	while ($j <= $k) {
		$result *= $n--;
		$result /= $j++;
		}
	
	return $result;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

