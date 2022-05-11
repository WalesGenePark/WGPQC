#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 05/08/2008 10:44:36
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
package Kea::IO::SOLiD::MatchFile::Hit;
use Kea::Object;
our @ISA = qw(Kea::Object);
 
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
	
	my $orientation 	= shift;
	my $position 	= shift;
	my $mismatch 	= shift;
	
	my $self = {
		_orientation 	=> $orientation,
		_position		=> $position,
		_mismatch		=> $mismatch
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

sub getOrientation {
	return shift->{_orientation};
	} # End of method.

sub getStartPosition {
	return shift->{_position};
	} #ÊEnd of method.

sub getMismatch {
	return shift->{_mismatch};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self 		= shift;
	my $orientation = $self->getOrientation;
	my $position 	= $self->getStartPosition;
	my $mismatch 	= $self->getMismatch;
	
	if ($orientation eq SENSE) {
		return "$position.$mismatch";
		}
	else {
		return "-$position.$mismatch";
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

