#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 16/03/2009 12:19:40
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

# INTERFACE NAME
package Kea::Reference::IAffiliation;

use strict;
use warnings;
use Kea::Object;

our $_message = "Undefined method.";

################################################################################

#ÊGet affiliation name, e.g. "The University of Liverpool" 
sub getAffiliation	{Kea::Object->throw($_message);}

# get division, e.g. "School of Biosciences"
sub getDivision		{Kea::Object->throw($_message);}

# city e.g. "Liverpool"       
sub getCity			{Kea::Object->throw($_message);}	           

#country, e.g. "UK"
sub getCountry		{Kea::Object->throw($_message);}

#street, e.g. "Biosciences Building, Crown Street" 
sub getStreet		{Kea::Object->throw($_message);}

#email, e.g.  "k.ashelford@liverpool.ac.uk"
sub getEmail		{Kea::Object->throw($_message);}

#fax, e.g. "+44 (0)151 795 4551"
sub getFax			{Kea::Object->throw($_message);}

#phone, e.g. "+44 (0)151 795 4551"
sub getPhone		{Kea::Object->throw($_message);}

#postal-code, e.g. "L69 7ZB"
sub getPostcode		{Kea::Object->throw($_message);}

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

