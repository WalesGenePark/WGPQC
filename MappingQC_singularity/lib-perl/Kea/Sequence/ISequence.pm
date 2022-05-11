#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 
#    Copyright (C) 2008, University of Liverpool.
#    Author: Kevin Ashelford.
#
#    Contact details:
#    Email: k.ashelford@liv.ac.uk
#    Address:  School of Biological Sciences, University of Liverpool, 
#    Biosciences Building, Crown Street, Liverpool, UK. L69 7ZB
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
package Kea::Sequence::ISequence;

use strict;
use warnings;
use Kea::Object;

our $_message = "undefined method";

################################################################################

sub getSequence 		{Kea::Object->throw($_message);} 

sub setSequence 		{Kea::Object->throw($_message);}

sub getQualities		{Kea::Object->throw($_message);}

sub setQualities		{Kea::Object->throw($_message);}

sub hasQualities		{Kea::Object->throw($_message);}

sub getSubsequence		{Kea::Object->throw($_message);} 

sub append 			{Kea::Object->throw($_message);} 

sub popBase 			{Kea::Object->throw($_message);} 

sub getBases 			{Kea::Object->throw($_message);} 

sub getBaseAt 			{Kea::Object->throw($_message);}

sub getID 			{Kea::Object->throw($_message);} 

sub setID 			{Kea::Object->throw($_message);} 

sub isDNA 			{Kea::Object->throw($_message);} 

sub getSequenceType 	        {Kea::Object->throw($_message);} 

sub getSize 			{Kea::Object->throw($_message);} 

sub getParent 			{Kea::Object->throw($_message);} 

sub setParent 			{Kea::Object->throw($_message);} 

sub hasParent 			{Kea::Object->throw($_message);} 

sub hasSequence 		{Kea::Object->throw($_message);} 

sub hasID 		        {Kea::Object->throw($_message);} 

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

