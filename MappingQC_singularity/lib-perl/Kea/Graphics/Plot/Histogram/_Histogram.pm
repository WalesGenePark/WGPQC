#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 28/05/2008 14:51:03
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
package Kea::Graphics::Plot::Histogram::_Histogram;
use Kea::Object;
use Kea::Graphics::Plot::Histogram::IHistogram;
our @ISA = qw(Kea::Object Kea::Graphics::Plot::Histogram::IHistogram);
 
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
	
	my $binCollection =
		Kea::Object->check(
			shift,
			"Kea::Graphics::Plot::Histogram::BinCollection"
			);
	
	my $self = {
		_binCollection => $binCollection
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

sub getBinCollection {
	return shift->{_binCollection};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////	
	
sub getStart {
	return shift->{_bins}->[0]->getLowerLimit;
	} # End of method.
	
#///////////////////////////////////////////////////////////////////////////////	
	
sub getEnd {
	my $self = shift;
	my $bins = $self->{_bins};
	return $bins->[@$bins-1]->getLowerLimit + $self->getBinSize;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getHighestCount	{
	
	my $self = shift;
	my $bins = $self->{_bins};
	my $count = 0;
	for (my $i = 0; $i < @$bins; $i++) {
		if ($bins->[$i]->getCount > $count) {
			$count = $bins->[$i]->getCount;
			}
		}
	return $count;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getBinSize {
	return shift->{_bins}->[0]->getBinSize;
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

