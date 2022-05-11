#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 11/06/2008 12:23:59
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
package Kea::IO::Pfam::IPfamResult;

use strict;
use warnings;
use Kea::Object;

our $_message = "Undefined method.";

################################################################################

sub getQueryId			{Kea::Object->throw($_message);}

sub getQueryLocation	{Kea::Object->throw($_message);}

sub getHmmId			{Kea::Object->throw($_message);}

sub getHmmLocation		{Kea::Object->throw($_message);}

sub getBitScore			{Kea::Object->throw($_message);}

sub getEValue			{Kea::Object->throw($_message);}

sub getHmmName			{Kea::Object->throw($_message);}

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

