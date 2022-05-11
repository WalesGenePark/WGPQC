#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 21/02/2008 20:19:14 
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


#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////

# CLASS NAME
package Kea::Phylogeny::Distance::_K80;
use Kea::Object;
use Kea::Phylogeny::Distance::IModel;
our @ISA = qw(Kea::Object Kea::Phylogeny::Distance::IModel);

## Purpose		: 

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use Kea::Alignment::Pairwise::StatisticsFactory;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	my $className = shift;
	
	# Assume sequences already fully checked by ModelFactory.
	my $matrix = Kea::Object->check(shift);
	
	my $n = @{$matrix->[0]};
	
	my $stats =
		Kea::Alignment::Pairwise::StatisticsFactory->createDNAStatistics(
			$matrix
			);
	
	
	my $S = $stats->S;
	my $V = $stats->V;
	
	# d
	my $d = -(1/2*log(1 - 2*$S - $V)) - (1/4 * log(1 - 2 * $V));
	
	# k
	my $k = (2 * log(1 - 2*$S - $V) )/( log(1 - 2*$V) ) - 1;
	
	# Variance
	my $a = (1 - 2*$S - $V)**-1;
	
	my $b  =
		1/2
		*
		(
			(1 - 2*$S - $V)**-1
			+
			(1 - 2*$V)**-1
		);
	
	my $var =
		(
			$a**2*$S + $b**2*$V
			-
			($a*$S + $b*$V)**2
		)
		/
		$n;
	
	
	
	
	my $self = {
		_n => $n,
		_d => $d,
		_k => $k,
		_variance => $var
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

sub getNumberOfSites {
	return shift->{_n};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getDistance {
	return shift->{_d};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getk {
	return shift->{_k};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getVariance {
	return shift->{_variance};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getStandardError {
	return sqrt(shift->{_variance});
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub get95PercentConfidenceInterval {
	
	my $self 	= shift;
	my $d 		= $self->getDistance;
	my $se 		= $self->getStandardError;
	
	my $lower = $d - 1.96 * $se;
	my $upper = $d + 1.96 * $se;
	
	return [$lower, $upper];
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self = shift;
	
	my $text = sprintf(
		"The estimated distance, d = %.4f.\n" .
		"The estimated transition/transversion rate ratio, k = %.3f.\n" . 
		"Variance = %.7f.\n" .
		"Standard error = %.4f.\n" .
		"Approximate 95%% confidence interval = (%.4f, %.4f).\n",
		$self->getDistance,
		$self->getk,
		$self->getVariance,
		$self->getStandardError,
		$self->get95PercentConfidenceInterval->[0],
		$self->get95PercentConfidenceInterval->[1]
		);
	
	return $text;
	
	} #ÊEnd of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

