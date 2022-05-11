#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 11/06/2008 18:05:33
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
package Kea::IO::Stockholm::_Record;
use Kea::Object;
use Kea::IO::Stockholm::IRecord;
our @ISA = qw(Kea::Object Kea::IO::Stockholm::IRecord);
 
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
	my $id = Kea::Object->check(shift);
	
	my $self = {_id => $id};
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

sub getAccession {
	return shift->{_accession};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _setAccession {
	my $self = shift;
	my $accession = shift;
	$self->{_accession} = $accession;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getDescription {
	return shift->{_description};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _setDescription {
	my $self = shift;
	my $description = shift;
	$self->{_description} = $description;
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

