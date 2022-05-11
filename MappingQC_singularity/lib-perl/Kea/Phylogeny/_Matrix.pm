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
package Kea::Phylogeny::_Matrix;
use Kea::Phylogeny::IMatrix;
use Kea::Object;
our @ISA = qw(Kea::Object Kea::Phylogeny::IMatrix);

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	
	my $className 	= shift;
	my $labels 		= Kea::Object->check(shift);
	my $matrix 		= Kea::Object->check(shift);
	
	my $self = {
		_labels => $labels,
		_matrix => $matrix
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

sub getSize {

	my $self	= shift;
	my $matrix 	= $self->{_matrix};
	
	return scalar(@$matrix);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLabel {

	my $self	= shift;
	my $i		= $self->checkIsInt(shift);
	
	return $self->{_labels}->[$i];
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub setLabel {

	my $self	= shift;
	my $i		= $self->checkIsInt(shift);
	my $id		= $self->check(shift);
	
	my $oldId = $self->{_labels}->[$i];
	
	# CHANGED FROM WARN - BEING STRICT!
	$self->throw(
		"Changing id from '$oldId' to '$id'. " .
		"Extra strict - may want to comment this out!"
		);
	
	$self->{_labels}->[$i] = $id;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLabels {
	return @{shift->{_labels}};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getValue {

	my $self	= shift;
	my $i		= $self->checkIsInt(shift);
	my $j		= $self->checkIsInt(shift);
	
	my $matrix = $self->{_matrix};
	
	return $matrix->[$i]->[$j];
	
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub getRow {

	my $self	= shift;
	my $i		= $self->checkIsInt(shift);
	
	my $matrix = $self->{_matrix};
	
	return @{$matrix->[$i]};
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {

	my $self = shift;
	
	my @labels = $self->getLabels;
	my $n = $self->getSize;
	
	my $text = "";
	for (my $i = 0; $i < $n; $i++) {
		my $data = join("\t", $self->getRow($i));
		$text = $text . $labels[$i] . "\t$data\n";
		}
	
	return $text;
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

