#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 09/04/2008 13:44:02
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
package Kea::Assembly::ReadFactory;
use Kea::Object;
our @ISA = qw(Kea::Object);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::Assembly::_Read;

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

#�PRIVATE METHODS

my $privateMethod = sub {
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub createRead {

	my $self = shift;
	my %args = @_;
	
	my $name 			= $self->check($args{-name});
	my $region	 		= $args{-region};
	my $orientation 	= $args{-orientation};
	my $contig			= $args{-contig};
	my $otherContigs	= $args{-otherContigs};
#	my $otherReads		= $args{-otherReads}; 		# duplicate reads.
#	my $sequence		= $args{-sequence};
	
	# Check correct type:
	#=================================================
	if (defined $region) {
		$self->check($region, "Kea::IO::Location");
		}
	
	if (defined $orientation) {
		$self->checkIsOrientation($orientation);
		}
	
	if (defined $otherContigs) {
		$self->checkIsArrayRef($otherContigs);
		}
	
	#if (defined $otherReads) {
	#	$self->checkIsArrayRef($otherReads);	
	#	}
	#
	#if (defined $sequence) {
	#	$self->check($sequence);
	#	}
	#================================================
	
	return Kea::Assembly::_Read->new(
		-name 			=> $name,
		-region 		=> $region,
		-orientation 	=> $orientation,
		-contig 		=> $contig,
		-othercontigs 	=> $otherContigs
		#-otherReads		=> $otherReads,
		#-sequence		=> $sequence
		);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;
