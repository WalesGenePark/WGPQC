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
package Kea::IO::XML::INSDSeq::_FromRecordWriter;
use Kea::IO::IWriter;
our @ISA = "Kea::IO::IWriter";

## Purpose		: 

use strict;
use warnings;
use Carp;

use constant TRUE => 1;
use constant FALSE => 0;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

## Purpose		: Constructor.
## Parameter	: n/a.
## Throws		: n/a.
sub new {
	my $className = shift;
	my $record = shift;
	my $self = {_record => $record};
	bless(
		$self,
		$className
		);
	return $self;
	} # End of constructor.

################################################################################

#?PRIVATE METHODS

my $privateMethod = sub {
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

## Purpose		: ?????????????.
## Returns		: n/a.
## Parameter	: n/a.
## Throws		: n/a.
sub write {
	my ($self, $FILEHANDLE) = @_;
	my $record = $self->{_record};
	
	# WRITE CONTENTS OF RECORD TO FILEHANDLE IN XML FORMAT.
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

