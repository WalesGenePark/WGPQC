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
package Kea::Sequence::_Sequence;
use Kea::Object;
use Kea::Sequence::ISequence;
our @ISA = qw(Kea::Object Kea::Sequence::ISequence);

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE	=> 0;

use Kea::Constant;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	my $className = shift;
	
	my %args = @_;
	
	my $record 		= $args{-record}	|| undef; # Want to be flexible not strict here!
	my $id 			= $args{-id}		|| undef; # Strictness to be inforced by public 
	my $sequence 	= $args{-sequence}	|| undef; # factory class not this private class.
	my $qualities	= $args{-qualities} || undef; #
	
	my $self = {
		_id 		=> $id,
		_sequence 	=> $sequence,
		_qualities	=> $qualities,  # NOTE this is a reference to an array of quality values
		_record 	=> $record
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

sub setParent {
	
	my $self = shift;
	my $record = $self->check(shift, "Kea::IO::IRecord");
	
	if (defined $self->{_record}) {
		$self->warn(
			"Record '" . $self->{_record}->getPrimaryAccession . 
			"' has been replaced by '" . $record->getPrimaryAccession . 
			"' in sequence " . $self->{_id} .
			"."
			);
		}
	
	$self->{_record} =$record;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getParent {
	
	my $self = shift;
	return $self->{_record} or
		$self->throw("No record object associated with sequence.");
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSequence {
	
	my $self = shift;
	return $self->{_sequence} or
		$self->throw("No sequence string associated with sequence object.");
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getQualities {
	
	my $self = shift;
	return $self->{_qualities};
	
	} # End of method.

sub setQualities {
	
	my $self = shift;
	my $qualities = $self->checkIsArrayRef(shift);
	
	$self->{_qualities} = $qualities;
	
	} # End of method.

sub hasQualities {
	
	my $self = shift;
	
	if (exists $self->{_qualities}) {
		return TRUE;
		}
	else {
		return FALSE;
		}
		
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSubsequence {
	
	my $self = shift;
	my $location = $self->check(shift, "Kea::IO::Location");
	
	my $sequence = $self->{_sequence};
	return substr($sequence, $location->getStart-1, $location->getLength);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasParent {
	return exists shift->{_record};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasSequence {
	return exists shift->{_sequence};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasID {
	return exists shift->{_id};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getBases {

	my $self 		= shift;
	my $sequence 	= $self->getSequence;
	
	return split(//, $sequence);
		
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getBaseAt {
	
	my $self 	= shift;
	my $i 		= $self->checkIsInt(shift);
	
	return substr(
		$self->{_sequence},
		$i,
		1
		);
		
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setSequence {
	
	my $self 		= shift;
	my $sequence 	= $self->check(shift);
	
	$self->{_sequence} = $sequence;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub append {
	
	my $self 		= shift;
	my $sequence 	= $self->check(shift);
	
	$self->{_sequence} .= $sequence;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getID {

	my $self = shift;
	
	return $self->{_id} or
		$self->throw("No id associated with sequence object.");
		
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setID {

	my $self 	= shift;
	my $id 		= $self->check(shift);
	
	$self->{_id} = $id;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSize {
	return length(shift->getSequence);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub popBase {
	my $self = shift;
	eval {
		return chop($self->{_sequence});
		};
	#ÊDebugging ...
	$self->throw($@) if $@;
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub isDNA {

	my $self = shift;

	my $sequence = uc($self->getSequence);
	if ($sequence =~ /^[ACGTMRWSYKBDHVN-]+$/) {
		return TRUE;	
		}
	else {
		return FALSE;
		}
	} # End of method.

#

#///////////////////////////////////////////////////////////////////////////////

sub getSequenceType {

	my $self = shift;

	my $sequence = uc($self->getSequence);
	if ($sequence =~ /^[ACGTMRWSYKBDHVN-]+$/) {
		return Kea::Constant::DNA;	
		}
	elsif ($sequence =~ /^[ACGUMRWSYKBDHVN-]+$/) {
		return Kea::Constant::RNA;	
		}
	elsif ($sequence =~ /^[ARNDCEQGHILKMFPSTWYVBZJX-]+$/) {
		return Kea::Constant::PROTEIN;
		}
	else {
		return Kea::Constant::UNKNOWN;
		}
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub equals {
	
	my $self = shift;
	my $other = $self->check(shift, "Kea::Sequence::ISequence");
	
	if ($self->getID ne $other->getID) {
		return FALSE;
		}
	
	if ($self->getSequence ne $other->getSequence) {
		return FALSE;
		}
	
	return TRUE;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {

	my $self = shift;
	
	my $id;
	my $record;
	my $sequence;
	my $qualities;
	
	if ($self->hasID) 			{$id = $self->getID;}
	if ($self->hasSequence) 	{$sequence = $self->getSequence;}
	if ($self->hasParent) 		{$record = $self->getParent;}
	if ($self->hasQualities) 	{$qualities = $self->getQualities;}
	
	my $text = ">";
	if (!defined $id) {
		$text .= "unknown";
		}
	elsif (defined $id) {
		$text .= "$id";	
		}
	
	if (defined $record) {
		$text .= " [" . $record->getPrimaryAccession . "]";
		}
	
	if (defined $sequence) {
		my $size = $self->getSize;
		$text .= " ($size)\n";
		$text .= "$sequence\n";
		}
	
	if (defined $qualities) {
		$text .= join(" ", @$qualities);
		}
	
	return $text;
	
	} #ÊEnd of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

