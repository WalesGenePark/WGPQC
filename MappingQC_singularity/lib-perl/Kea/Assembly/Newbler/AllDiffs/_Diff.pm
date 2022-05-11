#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 12/03/2008 13:02:12
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
package Kea::Assembly::Newbler::AllDiffs::_Diff;
use Kea::Object;
use Kea::Assembly::Newbler::AllDiffs::IDiff;
our @ISA = qw(Kea::Object Kea::Assembly::Newbler::AllDiffs::IDiff);
 
use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;
my $GAP	= "-";

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	
	my $className 				= shift;
	my $beforeSequenceString 	= Kea::Object->check(shift);
	my $afterSequenceStrings 	= Kea::Object->checkIsArrayRef(shift);
	my $locationWithinReference = Kea::Object->check(shift, "Kea::IO::Location");
	
	my $self = {
		_before 	=> $beforeSequenceString,
		_after 		=> $afterSequenceStrings,
		_location 	=> $locationWithinReference
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

sub getBefore {
	return shift->{_before};
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAfter {
	return shift->{_after};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# Returns location within UNALIGNED reference sequence. 
sub getLocation {
	return shift->{_location};
	} # End of method

#///////////////////////////////////////////////////////////////////////////////

sub isSnp {
	
	my $self 	= shift;
	my $before 	= $self->getBefore;
	my $after 	= $self->getAfter; # Ref to array.
	my $length 	= $self->getLocation->getLength;
	
	my @buffer;
	push(@buffer, $before);
	push(@buffer, @$after);
	
	# Return false if any sequence (before or after) are too long for snp.
	foreach my $seq (@buffer) {
		return FALSE if length($seq) > 1;
		}
	
	# Return false if any sequence is a gap character (hence indel not snp).
	foreach my $seq (@buffer) {
		return FALSE if $seq eq $GAP;
		}
	
	# Passed tests, therefore is a snp.
	return TRUE;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self = shift;
	
	my $text = "";
	$text .= $self->getLocation->toString . ", ";
	$text .= $self->getBefore . " -> [" . join(", ", @{$self->getAfter}) . "]";
	
	return $text;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

