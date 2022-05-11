#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 14/05/2008 16:55:30
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

# INTERFACE NAME
package Kea::IO::SwissProt::ISwissProtRecord;

use strict;
use warnings;
use Kea::Object;

our $_message = "Undefined method.";

################################################################################

sub getEntryName 			{Kea::Object->throw($_message);}

sub getDataClass 			{Kea::Object->throw($_message);}

sub getMoleculeType 		{Kea::Object->throw($_message);}

sub getLength 				{Kea::Object->throw($_message);}

sub getAccessions 			{Kea::Object->throw($_message);}
	
sub getSequence 			{Kea::Object->throw($_message);}

sub getMolecularWeight 		{Kea::Object->throw($_message);}

# see http://www.expasy.org/sprot/userman.html#SQ_line
sub getSequence64bitCRC 	{Kea::Object->throw($_message);}

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

