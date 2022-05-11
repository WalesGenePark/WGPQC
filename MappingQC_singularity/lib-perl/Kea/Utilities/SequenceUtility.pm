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

#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////

# CLASS NAME
package Kea::Utilities::SequenceUtility;

## Purpose		: Encapsulates general methods for sequence (DNA, protein) manipulation etc.

use strict;
use warnings;
use Carp;

use constant TRUE => 1;
use constant FALSE => 0;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

## Purpose    : Constructor.
## Returns    : n/a.
## Parameters : n/a.
## Throws     : n/a.
sub new {
	my $className = shift;
	
	my %args = @_;
	
	if (!exists $args{-showInformationMessages}) {$args{-showInformationMessages} = TRUE;}
	if (!exists $args{-showWarningMessages}) {$args{-showWarningMessages} = TRUE;}
	if (!exists $args{-showErrorMessages}) {$args{-showErrorMessages} = TRUE;}
	
	my $self = {
		-showInformationMessages => $args{-showInformationMessages},
		-showWarningMessages => $args{-showWarningMessages},
		-showErrorMessages => $args{-showErrorMessages}
		};
	
	bless(
		$self,
		$className
		);
	return $self;
	} # End of constructor.

################################################################################

# METHODS

## Purpose    	: Convert to lowercase.
## Returns    	: Lowercase sequence.
## Parameters 	: Sequence to convert.
## Throws     	: n/a.
sub toLowerCase {
	my $self = shift;
    my $sequence = shift;
    $sequence =~ tr/A-Z/a-z/;
    return $sequence;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose    	: Convert to uppercase.
## Returns    	: uppercase sequence.
## Parameters 	: Sequence to convert.
## Throws     	: n/a.
sub toUpperCase {
	my $self = shift;
    my $sequence = shift;
    $sequence =~ tr/a-z/A-Z/;
    return $sequence;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose    	: Remove any gap characters (e.g. whitespace, or '-') from supplied sequence.
## Returns    	: Modified sequence
## Parameters 	: Sequence to convert.
## Throws     	: n/a.
sub removeGaps {
	my ($self, $sequence) = @_;
	
	if (!defined $sequence) {
		confess "\nERROR: Undefined sequence";
		}
	
	$sequence =~ s/[\s\.-]//g;
	return $sequence;
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;