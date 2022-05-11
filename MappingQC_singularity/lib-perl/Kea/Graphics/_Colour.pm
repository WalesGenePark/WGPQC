#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 24/04/2008 15:46:29
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
package Kea::Graphics::_Colour;
use Kea::Object;
use Kea::Graphics::IColour;
our @ISA = qw(Kea::Object Kea::Graphics::IColour);
 
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
	
	my $self = {
		_name 	=> $args{-name},
		_red	=> $args{-red},
		_green	=> $args{-green},
		_blue	=> $args{-blue}
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

sub getName {
	return shift->{_name};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getRgb {
	my $self = shift;
	return [
		$self->{_red},
		$self->{_green},
		$self->{_blue}
		];
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getRed {
	return shift->{_red};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getGreen {
	return shift->{_green};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getBlue {
	return shift->{_blue};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	my $self = shift;
	
	my $name = $self->getName;
	my $red = $self->getRed;
	my $green = $self->getGreen;
	my $blue = $self->getBlue;
	
	return "$name ($red $green $blue)";
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

