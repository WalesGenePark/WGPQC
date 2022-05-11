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

# CLASS NAME
package Kea::Assembly::IContig;
use Kea::Object;

use strict;
use warnings;

our $_message = "\nERROR: Undefined method";

################################################################################

sub getName 							{Kea::Object->throw($_message);} 

sub getNumberOfBasesInPaddedConsensus 	{Kea::Object->throw($_message);} 

sub getNumberOfReads 					{Kea::Object->throw($_message);} 

sub getOrientation	 					{Kea::Object->throw($_message);} 

sub getPaddedConsensus 					{Kea::Object->throw($_message);} 

sub getConsensus 						{Kea::Object->throw($_message);}

sub getPositionKey						{Kea::Object->throw($_message);}

sub getSequence 						{Kea::Object->throw($_message);} 

sub getQualityScores 					{Kea::Object->throw($_message);} 

sub getSize 							{Kea::Object->throw($_message);} 

sub getPaddedSize						{Kea::Object->throw($_message);}

sub getReadCollection 					{Kea::Object->throw($_message);} 

sub getReadAlignment					{Kea::Object->throw($_message);}

sub getAlignment						{Kea::Object->throw($_message);}

sub getAlignmentWithoutDuplicates		{Kea::Object->throw($_message);}

sub getDiffRegionCollection				{Kea::Object->throw($_message);}

sub getDifferenceString					{Kea::Object->throw($_message);}

sub getDifferenceLocations				{Kea::Object->throw($_message);}

sub toString 							{Kea::Object->throw($_message);} 

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

