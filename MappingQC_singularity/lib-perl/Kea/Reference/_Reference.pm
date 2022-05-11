#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 02/03/2009 10:04:27
#    Copyright (C) 2009, University of Liverpool.
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
package Kea::Reference::_Reference;
use Kea::Object;
use Kea::Reference::IReference;
our @ISA = qw(Kea::Object Kea::Reference::IReference);
 
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

	# As used by GenBank file format - ref 1, 2, 3 etc.
	my $number = Kea::Object->checkIsInt(shift);
	
	my $authorCollection =
		Kea::Object->check(shift, "Kea::Reference::AuthorCollection");
	
	my $title 	= Kea::Object->check(shift);
	my $journal	= Kea::Object->check(shift);
	
	my $self = {
		_number				=> $number,
		_authorCollection 	=> $authorCollection,
		_title				=> $title,
		_journal			=> $journal
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

sub getNumber {
	return shift->{_number};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAuthorCollection {
	return shift->{_authorCollection};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getTitle {
	return shift->{_title};
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getJournal {
	return shift->{_journal};
	} #ÊEnd of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

