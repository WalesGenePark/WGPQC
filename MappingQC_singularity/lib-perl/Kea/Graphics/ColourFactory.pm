#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 24/04/2008 15:47:27
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
package Kea::Graphics::ColourFactory;
use Kea::Object;
our @ISA = qw(Kea::Object);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::Graphics::_Colour;

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

sub createColour {

	my $self 			= shift;
	
	if (@_ == 3) {
		my ($red, $green, $blue) = @_;
		
		return Kea::Graphics::_Colour->new(
			-name 	=> "unknown",
			-red 	=> $red,
			-green	=> $green,
			-blue	=> $blue
			);
		
		}
	
	
	elsif (@_ == 1) {
		
		my $colourString 	= $self->check(shift);
	
		if ($colourString eq "red") {
			return
				Kea::Graphics::_Colour->new(
					-name 	=> "red",
					-red	=> 255,
					-green 	=> 0,
					-blue	=> 0
					); 
			}
		
		elsif ($colourString eq "white") {
			return
				Kea::Graphics::_Colour->new(
					-name 	=> "white",
					-red	=> 255,
					-green 	=> 255,
					-blue	=> 255
					); 
			}
		
		elsif ($colourString eq "black") {
			return
				Kea::Graphics::_Colour->new(
					-name 	=> "black",
					-red	=> 0,
					-green 	=> 0,
					-blue	=> 0
					); 
			}
		
		elsif ($colourString eq "green") {
			return
				Kea::Graphics::_Colour->new(
					-name 	=> "green",
					-red	=> 0,
					-green 	=> 255,
					-blue	=> 0
					); 
			}
		
		elsif ($colourString eq "blue") {
			return
				Kea::Graphics::_Colour->new(
					-name 	=> "blue",
					-red	=> 0,
					-green 	=> 0,
					-blue	=> 255
					); 
			}
		
		elsif ($colourString eq "yellow") {
			return
				Kea::Graphics::_Colour->new(
					-name 	=> "yellow",
					-red	=> 255,
					-green 	=> 255,
					-blue	=> 0
					); 
			}
		
		elsif ($colourString eq "magenta") {
			return
				Kea::Graphics::_Colour->new(
					-name 	=> "magenta",
					-red	=> 255,
					-green 	=> 0,
					-blue	=> 255
					); 
			}
		
		elsif ($colourString eq "cyan") {
			return
				Kea::Graphics::_Colour->new(
					-name 	=> "cyan",
					-red	=> 0,
					-green 	=> 255,
					-blue	=> 255
					); 
			}
		
		else {
			$self->throw("Unsupported colour: $colourString.");
			}
		
		}
	
	else {
		$self->throw(
			"Unexpected numbe of arguments: " . @_ . "."
			);
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

