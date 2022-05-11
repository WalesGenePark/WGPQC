#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 16/03/2009 12:28:51
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
package Kea::Reference::_Affiliation;
use Kea::Object;
use Kea::Reference::IAffiliation;
our @ISA = qw(Kea::Object Kea::Reference::IAffiliation);
 
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
	
	my $affiliation	= Kea::Object->check(shift);
	my $division 	= Kea::Object->check(shift);
	my $city 		= Kea::Object->check(shift);
	my $country 	= Kea::Object->check(shift);
	my $street 		= Kea::Object->check(shift);
	my $email 		= Kea::Object->check(shift);
	my $fax 		= Kea::Object->check(shift);
	my $phone 		= Kea::Object->check(shift);
	my $postcode 	= Kea::Object->check(shift);
	
	my $self = {
		_affiliation	=> $affiliation,
		_division		=> $division,
		_city			=> $city,
		_country		=> $country,
		_street			=> $street,
		_email			=> $email,
		_fax 			=> $fax,
		_phone			=> $phone,
		_postcode		=> $postcode
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

#ÊGet affiliation name, e.g. "The University of Liverpool" 
sub getAffiliation	{
	return shift->{_affiliation};
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

# get division, e.g. "School of Biosciences"
sub getDivision	{
	return shift->{_division};
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

# city e.g. "Liverpool"       
sub getCity	{
	return shift->{_city};
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////           

#country, e.g. "UK"
sub getCountry	{
	return shift->{_country};
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

#street, e.g. "Biosciences Building, Crown Street" 
sub getStreet	{
	return shift->{_street};
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

#email, e.g.  "k.ashelford@liverpool.ac.uk"
sub getEmail {
	return shift->{_email};
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

#fax, e.g. "+44 (0)151 795 4551"
sub getFax {
	return shift->{_fax};
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

#phone, e.g. "+44 (0)151 795 4551"
sub getPhone {
	return shift->{_phone};
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

#postal-code, e.g. "L69 7ZB"
sub getPostcode {
	return shift->{_postcode};
	} #ÊEnd of method

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

