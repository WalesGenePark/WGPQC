#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 05/03/2008 14:18:17 
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
package Kea::Assembly::Newbler::AllDiffs::_AlignmentLine;
use Kea::Object;
use Kea::Assembly::Newbler::AllDiffs::IAlignmentLine;
our @ISA = qw(Kea::Object Kea::Assembly::Newbler::AllDiffs::IAlignmentLine);

use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	my %args = @_;
	
	my $location 	= Kea::Object->check($args{-location}, "Kea::IO::Location");
	my $orientation = Kea::Object->checkIsOrientation($args{-orientation});
	
	my $self = {
		_id 			=> $args{-id},
		_number 		=> $args{-number} || undef,
		_location 		=> $location,
		_orientation 	=> $orientation,
		_sequence 		=> $args{-sequence}
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

#///////////////////////////////////////////////////////////////////////////////

sub getNumber {
	
	my $self = shift;
	
	if ($self->hasNumber) {
		return $self->{_number};
		}
	else {
		$self->throw("No number in parentheses associated with " . $self->getId);
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasNumber {
	
	my $self = shift;
	
	if (defined $self->{_number}) {
		return TRUE;	
		}
	else {
		return FALSE;
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLocation {
	return shift->{_location};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getOrientation {
	return shift->{_orientation};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSequence {
	return shift->{_sequence};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {

	my $self = shift;
	
	my $id = $self->getId;
	my $orientation = $self->getOrientation;
	my $sequence = $self->getSequence;
	
	my $start = $self->getLocation->getStart;
	my $end = $self->getLocation->getEnd;
	if ($orientation eq ANTISENSE) {
		$end = $self->getLocation->getStart;
		$start = $self->getLocation->getEnd;
		}
	
	my $number = "";
	if ($self->hasNumber) {
		$number = "(" . $self->getNumber . ")";
		}
	
	if ($orientation eq SENSE) {$orientation = "+"}
	elsif ($orientation eq ANTISENSE) {$orientation = "-";}
	else {
		$self->throw("Unexpected orientation: $orientation.");
		}
	
	return sprintf(
		"%-15s %-5s%9d%s %s %-d",
		$id,
		$number,
		$start,
		$orientation,
		$sequence,
		$end
		);	


	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

