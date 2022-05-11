#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 
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
package Kea::IO::Location;
use Kea::Object;
our @ISA = qw(Kea::Object);

use strict;
use warnings;

use constant TRUE	=> 1;
use constant FALSE 	=> 0;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className 	= shift;
	my $start 		= Kea::Object->check(shift);
	my $end 		= Kea::Object->check(shift);
	
	
	my $startQualifier;
	my $endQualifier;
	
	if ($start =~ s/<//) {
		$startQualifier = "<"; # TODO - yet to fully code for...
		}
	
	if ($end =~ s/>//) {
		$endQualifier = ">";  # TODO - yet to fully code for...
		}
	
	Kea::Object->throw(
		"$start..$end: $start is greater than $end, should this be antisense?"
		)
	if $start > $end;
	
	my $self = {
		_start			=> $start,
		_end			=> $end,
		_startQualifier	=> $startQualifier,
		_endQualifier	=> $endQualifier
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

sub clone {
	my $self = shift;
	return Kea::IO::Location->new($self->{_start}, $self->{_end});
	}

#///////////////////////////////////////////////////////////////////////////////

sub setStart {
	my ($self, $start) = @_;
	$self->{_start} = $start;
	} # End of method.


#///////////////////////////////////////////////////////////////////////////////

sub setEnd {
	my ($self, $end) = @_;
	$self->{_end} = $end;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# reduce both start and end by one.
sub deincrement {
	my $self = shift;
	$self->{_start}--;
	$self->{_end}--;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# increase both start and end by one.
sub increment {
	my $self = shift;
	$self->{_start}++;
	$self->{_end}++;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub incrementBy {
	my $self = shift;
	my $value = shift;
	$self->{_start} = $self->{_start} + $value;
	$self->{_end} = $self->{_end} + $value;
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub deincrementBy {
	my $self = shift;
	my $value = shift;
	$self->{_start} = $self->{_start} - $value;
	$self->{_end} = $self->{_end} - $value;
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub incrementStart {
	my $self = shift;
	$self->{_start}++;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub deincrementStart {
	my $self = shift;
	$self->{_start}--;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub incrementEnd {
	my $self = shift;
	$self->{_end}++;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub deincrementEnd {
	my $self = shift;
	$self->{_end}--;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getStart {
	return shift->{_start};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getEnd {
	return shift->{_end};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getMidpoint {
	my $self = shift;
	my $start = $self->{_start};
	my $end = $self->{_end};
	return $start + ($end-$start)/2;
	}

#///////////////////////////////////////////////////////////////////////////////

sub getLength {
	my $self = shift;
	return $self->{_end} - $self->{_start} + 1;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub equals {

	my $self = shift;
	my $location = $self->check(shift, "Kea::IO::Location");
	
	if ($self->toString eq $location->toString) {
		return TRUE;
		}
	else {
		return FALSE;
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getStartQualifier {
	return shift->{_startQualifier};
	} # End of method.

sub hasStartQualifier {
	
	my $self = shift;
	
	return TRUE if defined $self->{_startQualifier};
	return FALSE;
	
	} # End of method.



sub setStartQualifier {
	
	my $self = shift;
	my $qualifier = shift;
	$self->{_startQualifier} = $qualifier;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getEndQualifier {
	return shift->{_endQualifier};
	} # End of method.

sub hasEndQualifier {
	
	my $self = shift;
	
	return TRUE if defined $self->{_endQualifier};
	return FALSE;
	
	} # End of method.

sub setEndQualifier {

	my $self = shift;
	my $qualifier = shift;
	$self->{_endQualifier} = $qualifier;

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {

	my $self 	= shift;
	my $start 	= $self->getStart;
	my $end 	= $self->getEnd;
	
	my $startQualifier = "";
	my $endQualifier = "";
	
	if ($self->hasStartQualifier) {
		$startQualifier = $self->getStartQualifier;
		}
	
	if ($self->hasEndQualifier) {
		$endQualifier = $self->getEndQualifier;
		}
	
	
	return "$startQualifier$start..$endQualifier$end";
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

