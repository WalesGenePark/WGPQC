#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 21/02/2008 21:16:51 
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
package Kea::Phylogeny::Distance::_TN93;
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
		
	my $S1 = $stats->S1;
	my $S2 = $stats->S2;
	my $V = $stats->V;
	my $freqA = $stats->meanFreqA;
	my $freqG = $stats->meanFreqG;
	my $freqT = $stats->meanFreqT;
	my $freqC = $stats->meanFreqC;
	my $freqR = $stats->meanFreqR;
	my $freqY = $stats->meanFreqY;
	
	

	my $a1 = - log ( 1 - ($freqY*$S1) / (2*$freqT*$freqC) - $V/(2*$freqY) );
	
	my $a2 = - log ( 1 - ($freqR*$S2) / (2*$freqA*$freqG) - $V/(2*$freqR) );
	
	my $b = - log ( 1 - $V/(2*$freqY*$freqR) );
	
	
	# is correct according to baseml output.
	my $d =
		( 2*$freqT*$freqC * ($a1 - $freqR*$b) ) / $freqY
		+
		( 2*$freqA*$freqG * ($a2 - $freqY*$b) ) / $freqR
		+
		( 2 * $freqY * $freqR * $b);
		
		
	my $k1 = ($a1 - $freqR*$b) / ($freqY*$b);
	
	my $k2 = ($a2 - $freqY*$b) / ($freqR*$b);
	
	
	
	
	#my $d2 =
	#	-
	#	(2*$freqA*$freqG)/$freqR * log(1 - $freqR/(2*$freqA*$freqG)*$S1 - 1/(2*$freqR)*$V)
	#	-
	#	(2*$freqT*$freqC)/$freqY * log(1 - $freqY/(2*$freqT*$freqC)*$S2 - 1/(2*$freqY)*$V)
	#	-
	#	2*($freqR*$freqY - ($freqA*$freqG*$freqY)/$freqR - ($freqT*$freqC*$freqR)/$freqY)
	#	*
	#	log(1 - 1/(2*$freqR*$freqY)*$V);
	#
	#
	#print $d2 . "\n";
	
	my $self = {
		_d 	=> $d,
		_k1 => $k1,
		_k2 => $k2
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

#///////////////////////////////////////////////////////////////////////////////

sub getDistance {
	return shift->{_d};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getk1 {
	return shift->{_k1};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getk2 {
	return shift->{_k2};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self = shift;
	
	my $text = sprintf(
		"The estimated distance, d = %.6f.\n" .
		"The estimated transition/transversion rate ratio, k1 = %.3f, k2 = %.3f.\n",
		$self->getDistance,
		$self->getk1,
		$self->getk2
		);
	
	return $text;
	
	} #ÊEnd of method.



################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

