#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 19/02/2008 20:33:47 
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
package Kea::Phylogeny::Distance::_JC69;
use Kea::Object;
use Kea::Phylogeny::Distance::IModel;
our @ISA = qw(Kea::Object Kea::Phylogeny::Distance::IModel);

## Purpose		: 

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
	my $d = -(3/4) * log(1 - 4/3 * $p); 
	
	# Approximate variance.
	my $var_d = 
		(
			$p*(1-$p)/$n
		)
		*
		(
			1/(1 - 4*$p/3)**2
		);
	
	
	
	
	# Equation 1.44 from page 23 of Yang 2006.
	my $e = exp(-4*$p/3);
	my $lnL = $x*log((1 - $e)/16) + ($n-$x)*log((1+ 3*$e)/16);
	
	# Equation from page 24 if Yang 2006 - gives same value as example, p. 25.
	my $lnL2 = $x*log($x/(12*$n)) + ($n-$x)*log(($n-$x)/(4*$n));
	
	
	
	my $self = {
		_lnL		=> $lnL2,
		_x			=> $x,
		_n			=> $n,
		_p 			=> $p,
		_d 			=> $d,
		_variance 	=> $var_d
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

sub getNumberOfDifferentSites {
	return shift->{_x};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLogLikelihood {
	return shift->{_lnL};
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
		"The observed proportion of different sites, p = %d/%d = %.5f.\n" .
		"The estimated distance, d = %.4f.\n" .
		"Variance = %.7f.\n" .
		"Standard error = %.4f.\n" .
		"Approximate 95%% confidence interval = (%.4f, %.4f).\n" .
		"Log Likelihood = %.3f\n", 
		$self->getNumberOfDifferentSites,
		$self->getNumberOfSites,
		$self->getUncorrectedDistance,
		$self->getDistance,
		$self->getVariance,
		$self->getStandardError,
		$self->get95PercentConfidenceInterval->[0],
		$self->get95PercentConfidenceInterval->[1],
		$self->getLogLikelihood
		);
	
	return $text;
	
	} #ÊEnd of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

