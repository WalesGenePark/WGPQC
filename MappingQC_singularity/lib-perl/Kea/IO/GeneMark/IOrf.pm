#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 21/07/2009 13:12:57
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
package Kea::IO::GeneMark::IOrf;

use strict;
use warnings;
use Kea::Object;

our $_message = "Undefined method.";

################################################################################

sub getGeneNumber 	{Kea::Object->throw($_message);}
sub setGeneNumber 	{Kea::Object->throw($_message);} 

sub getStrand		{Kea::Object->throw($_message);}
sub setStrand		{Kea::Object->throw($_message);}

sub getOrientation	{Kea::Object->throw($_message);}

sub getStart		{Kea::Object->throw($_message);}
sub setStart		{Kea::Object->throw($_message);}

sub getEnd			{Kea::Object->throw($_message);}
sub setEnd			{Kea::Object->throw($_message);}

sub getLocation		{Kea::Object->throw($_message);}

sub getGeneLength	{Kea::Object->throw($_message);}
sub setGeneLength	{Kea::Object->throw($_message);}

sub getClass		{Kea::Object->throw($_message);}
sub setClass		{Kea::Object->throw($_message);}

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

