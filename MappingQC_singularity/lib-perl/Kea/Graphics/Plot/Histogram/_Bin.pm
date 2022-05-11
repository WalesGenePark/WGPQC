#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 28/05/2008 14:55:12
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
package Kea::Graphics::Plot::Histogram::_Bin;
use Kea::Object;
use Kea::Graphics::Plot::Histogram::IBin;
our @ISA = qw(Kea::Object Kea::Graphics::Plot::Histogram::IBin);
 
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
	
	my $className 	= shift;
	
	my %args = @_;
	
	my $binSize 	= Kea::Object->checkIsNumber($args{-binSize});
	my $lowerLimit	= Kea::Object->checkIsNumber($args{-lowerLimit});
	my $midPoint = $lowerLimit + $binSize / 2;
	my $upperLimit = $lowerLimit + $binSize;
	
	my $self = {
	
		_count 		=> 0,
		_binSize 	=> $binSize,
		_lowerLimit => $lowerLimit,
		_midPoint 	=> $midPoint,
		_upperLimit => $upperLimit
	
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

sub getBinSize {
	return shift->{_binSize};
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLowerLimit {
	return shift->{_lowerLimit};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getUpperLimit {
	return shift->{_upperLimit};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////
	
sub getMidPoint {
	return shift->{_midPoint};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////
	
sub getCount {
	return shift->{_count};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub increment {
	shift->{_count}++;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self = shift;
	
	my $count = $self->getCount;
	my $lower = $self->getLowerLimit;
	my $mid = $self->getMidPoint;
	my $upper = $self->getUpperLimit;
	
	return sprintf(
		"count=%s\tlower=%s\tmid=%s\tupper<%s",
		$count,
		$lower,
		$mid,
		$upper
		);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

