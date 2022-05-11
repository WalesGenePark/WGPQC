#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 15/02/2008 19:08:51 
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
package Kea::ThirdParty::Blast::_BlastClustWrapper;
use Kea::Object;
our @ISA = qw(Kea::Object);

use strict;
use warnings;
use Kea::System;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

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

my $decide = sub {

	my $self 	= shift;
	my $arg 	= shift;
	
	# Default.
	if (!defined $arg) {
		return "T";
		}
	
	elsif ($arg == TRUE) {
		return "T";
		}
	elsif ($arg == FALSE) {
		return "F";
		}
	else {
		$self->throw("Expecting boolean argument: $arg.");
		}

	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $checkInRange = sub {
	
	my $self 	= shift;
	my $arg 	= $self->checkIsNumber(shift);
	my $lower 	= $self->checkIsNumber(shift);
	my $upper	= $self->checkIsNumber(shift);
	my $default = $self->checkIsNumber(shift);
	
	if (!defined $arg) {
		rerurn $default;
		}
	
	elsif ($arg >= $lower && $arg <= $upper) {
		return $arg;
		}
	else {
		$self->throw(
			"$arg does ot fall in the range $lower to $upper."
			);
		}
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub run {
	
	my $self = shift;
	my %args = @_;
	
	my $infile 					= $self->checkIsFile($args{-i});
	my $outfile 				= $self->check($args{-o});
	my $isProtein 				= $self->$decide($args{-p});
	my $bothStrands 			= $self->$decide($args{-b});
	my $similarityThreshold 	= $self->$checkInRange($args{-S}, 0.0, 3.0, 1.75); # CHECK RANGE 0.0 - 3.0
	my $minimumLengthCoverage 	= $self->$checkInRange($args{-L}, 0.0, 1.0, 0.90); # CHECK RANGE 0.0 - 1.0
	
	my $commandArgs =
		"-i $infile " .
		"-o $outfile " .
		"-p $isProtein " .
		"-b $bothStrands " .
		"-S $similarityThreshold " .
		"-L $minimumLengthCoverage";
	
	Kea::System->run("blastclust", $commandArgs);

	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

