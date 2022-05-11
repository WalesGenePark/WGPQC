#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 08/03/2008 19:18:20 
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
package Kea::Phylogeny::Distance::_NoModel;
use Kea::Object;
use Kea::Phylogeny::Distance::IModel;
our @ISA = qw(Kea::Object Kea::Phylogeny::Distance::IModel);

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
	
	# Assume sequences already fully checked by ModelFactory.
	my $matrix = Kea::Object->check(shift);
	
	my $n = @{$matrix->[0]};
	
	my $x = 0;
	for (my $i = 0; $i < $n; $i++) {
		$x++ if ($matrix->[0]->[$i] ne $matrix->[1]->[$i]);
		}
	
	# Observed proportion of different sites.
	my $p = ($x)/$n;
	
	
	# Estimate of distance.	
	my $d = $p; 
	
	my $self = {
		_x			=> $x,
		_n			=> $n,
		_p 			=> $p,
		_d 			=> $d
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

sub getPercentIdentity {
	
	my $self = shift;
	return (($self->{_n} - $self->{_x}) / $self->{_n}) * 100;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getNumberOfDifferentSites {
	return shift->{_x};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getNumberOfSites {
	return shift->{_n};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getUncorrectedDistance {
	return shift->{_p};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getDistance {
	return shift->{_d};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self = shift;
	
	my $text = sprintf(
		"The observed proportion of different sites, p = %d/%d = %.5f.\n" .
		"The estimated distance, d = %.4f.\n", 
		$self->getNumberOfDifferentSites,
		$self->getNumberOfSites,
		$self->getUncorrectedDistance,
		$self->getDistance
		);
	
	return $text;
	
	} #ÊEnd of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;
