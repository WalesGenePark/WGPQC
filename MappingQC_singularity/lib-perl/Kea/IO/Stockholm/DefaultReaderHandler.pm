#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 11/06/2008 17:49:24
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
package Kea::IO::Stockholm::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::Stockholm::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::Stockholm::IReaderHandler);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::IO::Stockholm::RecordCollection;
use Kea::IO::Stockholm::_Record; 

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	
	my $className = shift;
	my $recordCollection = Kea::IO::Stockholm::RecordCollection->new("");
	
	my $self = {
		_recordCollection 	=> $recordCollection,
		_currentRecord 		=> undef
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

sub _nextId {
	
	my $self = shift;
	my $id = shift;
	
	if (defined $self->{_currentRecord}) {
		$self->throw("Current record already defined.");
		}
	
	$self->{_currentRecord} =
		Kea::IO::Stockholm::_Record->new($id);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextAccession {
	
	my $self = shift;
	my $accession = shift;
	
	$self->{_currentRecord}->_setAccession($accession);

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextDescription {
	
	my $self = shift;
	my $description = shift;
	
	$self->{_currentRecord}->_setDescription($description);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextEndOfRecord {
	
	my $self = shift;
	
	$self->{_recordCollection}->add(
		$self->{_currentRecord}
		);
	
	$self->{_currentRecord} = undef;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getRecordCollection {
	return shift->{_recordCollection};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

