#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 02/03/2009 10:09:06
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
package Kea::Reference::_Author;
use Kea::Object;
use Kea::Reference::IAuthor;
our @ISA = qw(Kea::Object Kea::Reference::IAuthor);
 
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
	
	my $firstName 		= Kea::Object->check(shift);
	my $lastName 		= Kea::Object->check(shift);
	my $initialsArray 	= Kea::Object->checkIsArrayRef(shift);

	# Initials array should include initial for first name provided.  Check
	# that this is so.
	if ($initialsArray->[0] ne substr($firstName, 0,1)) {
		Kea::Object->throw(
			"Initials array (@$initialsArray) does not include initial for " .
			"first name '$firstName'."
			);
		}
	
	my $self = {
		_firstName		=> $firstName,
		_lastName		=> $lastName,
		_initialsArray	=> $initialsArray
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

sub getFirstName {
	return shift->{_firstName};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLastName {
	return shift->{_lastName};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getInitialsArray {
	return @{shift->{_initialsArray}};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self 			= shift;
	my $firstName 		= $self->getFirstName;
	my $lastName 		= $self->getLastName;
	my @initialsArray 	= $self->getInitials;
	
	# Remove redundant first initial.
	shift(@initialsArray);
	
	# Construct text.
	my $text = "$firstName ";
	
	foreach my $initial (@initialsArray) {
		$text .= "$initial. ";
		}
	
	$text .= $lastName;
	
	# return.
	return $text;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

