#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 16/03/2009 12:35:22
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
package Kea::Reference::AffiliationFactory;
use Kea::Object;
our @ISA = qw(Kea::Object);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::Reference::_Affiliation;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

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

#ÊPRIVATE METHODS

my $privateMethod = sub {
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub createAffiliation {
	
	my $self = shift;
	my %args = @_;
	
	#ÊGet affiliation name, e.g. "The University of Liverpool" 
	my $affiliation = $args{-affilication};
	
	# get division, e.g. "School of Biosciences"
	my $division	= $args{-division};
	
	# city e.g. "Liverpool"       
	my $city		= $args{-city};	           
	
	#country, e.g. "UK"
	my $country		= $args{-country};
	
	#street, e.g. "Biosciences Building, Crown Street" 
	my $street		= $args{-street};
	
	#email, e.g.  "k.ashelford@liverpool.ac.uk"
	my $email		= $args{-email};
	
	#fax, e.g. "+44 (0)151 795 4551"
	my $fax			= $args{-fax};
	
	#phone, e.g. "+44 (0)151 795 4551"
	my $phone		= $args{-phone};
	
	#postal-code, e.g. "L69 7ZB"
	my $postcode	= $args{-postcode};
	
	return Kea::Reference::_Affiliation->new(
		$affiliation,
		$division,
		$city,
		$country,
		$street,
		$email,
		$fax,
		$phone,
		$postcode
		);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

