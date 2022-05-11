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
package Kea::Parsers::ListParser;

## Purpose		: Parses list files (each line: <code>\t<info>\n).

use strict;
use warnings;

use constant TRUE => 1;
use constant FALSE => 0;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

## Purpose		: Constructor.
## Returns		: n/a.
## Parameter	: n/a.
## Throws		: n/a.
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

# METHODS

## Purpose		: Parses list file as represented by reference to filehandle.
## Returns		: n/a.
## Parameter	: Reference to FILEHANDLE.
## Throws		: n/a.
sub parse {
	my ($self, $filehandle) = @_;
	
	my @codes;
	my @info;
	
	while (<$filehandle>) {
		chomp;
		if (/^(.+)\t(.+)$/) {
			push(@codes, $1);
			push(@info, $2);
			}
		
		} # end of while - no more lines to process.
	
	$self->{_keys} = \@codes;
	$self->{_items} = \@info;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getKeys {
	my $self = shift;
	my $array = $self->{_keys};
	return @$array;
	}  # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getItems {
	my $array = shift->{_items};
	return @$array;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getItem {
	my $self = shift;
	my $key = shift;
	
	my @keys = $self->getKeys;
	my @items = $self->getItems;
	for (my $i = 0;$i < scalar(@keys); $i++) {
		if ($keys[$i] eq $key) {
			return $items[$i];
			}
		}
	die "ERROR: Key '$key' could not be found in list.\n";
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

