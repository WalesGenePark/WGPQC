#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 08/05/2008 09:37:15
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
package Kea::Assembly::NCBI::AGP::IAGPComponent;

use strict;
use warnings;
use Kea::Object;

our $_message = "Undefined method.";

################################################################################

sub getLocation 			{Kea::Object->throw($_message);}

sub setLocation				{Kea::Object->throw($_message);}

sub getPartNumber 			{Kea::Object->throw($_message);}

sub setPartNumber			{Kea::Object->throw($_message);}

sub getComponentType 		{Kea::Object->throw($_message);}

sub getComponentId 			{Kea::Object->throw($_message);}

sub setComponentId 			{Kea::Object->throw($_message);}

sub getComponentLocation 	{Kea::Object->throw($_message);}

sub getOrientation 			{Kea::Object->throw($_message);}

sub setOrientation			{Kea::Object->throw($_message);}

sub getGapLength 			{Kea::Object->throw($_message);}

sub getGapType 				{Kea::Object->throw($_message);}

sub getLinkage 				{Kea::Object->throw($_message);}

sub clone 					{Kea::Object->throw($_message);}

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

