#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 05/08/2009 17:20:01
#    Copyright (C) 2009, University of Liverpool.
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
package Kea::IO::MyORF::_ORF;
use Kea::Object;
use Kea::IO::MyORF::IORF;
our @ISA = qw(Kea::Object Kea::IO::MyORF::IORF);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::IO::Location;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	
	my $className = shift;
	
	my $id 			= shift;
	my $start 		= shift;
	my $end 		= shift;
	my $orientation = shift;
	my $program		= shift;
	my $note		= shift;
	
	my $location = Kea::IO::Location->new($start, $end);
	
	my $self = {
		_id				=> $id,
		_start			=> $start,
		_end			=> $end,
		_orientation	=> $orientation,
		_note 			=> $note,
		_location		=> $location,
		_program		=> $program 		|| Kea::Object->throw("Expecting program variable.")
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

sub getId {
	return shift->{_id};
	} # End of method.

sub setId {
	my $self = shift;
	$self->{_id} = shift;
	} # End of method.

sub getStart {
	return shift->{_start};
	} # End of method.

sub getLocation {
	return shift->{_location};
	} # End of method.

sub getEnd {
	return shift->{_end};
	} # End of method.

sub getOrientation {
	return shift->{_orientation};
	} # End of method.

sub getNote {
	return shift->{_note};
	} # End of method.

sub getProgram {
	return shift->{_program};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

