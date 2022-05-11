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
package Kea::Assembly::IRead;

use strict;
use warnings;
use Kea::Object;

our $_message = "\nERROR: Undefined method";

################################################################################

# Returns full name - i.e. read accession plus and qualifying information.
sub getName 						{Kea::Object->throw($_message);}
# Returns read accession only (i.e. name without qualification).
sub getAccession					{Kea::Object->throw($_message);}

sub getContig						{Kea::Object->throw($_message);}
sub getOtherContigs					{Kea::Object->throw($_message);}

sub setDuplicateReads				{Kea::Object->throw($_message);}
sub getDuplicateReads				{Kea::Object->throw($_message);}
sub hasDuplicateReads				{Kea::Object->throw($_message);}

sub getPositionKey					{Kea::Object->throw($_message);}

sub getRegionOfinterest				{Kea::Object->throw($_message);}

sub setNumberOfPaddedBases 			{Kea::Object->throw($_message);} 
sub getNumberOfPaddedBases 			{Kea::Object->throw($_message);} 

sub setNumberOfReadTags 			{Kea::Object->throw($_message);} 
sub getNumberOfReadTags 			{Kea::Object->throw($_message);} 

sub setNumberOfWholeReadInfoItems 	{Kea::Object->throw($_message);} 
sub getNumberOfWholeReadInfoItems 	{Kea::Object->throw($_message);} 

sub setPaddedRead	 				{Kea::Object->throw($_message);} 
sub getPaddedRead	 				{Kea::Object->throw($_message);} 

sub setRead		 					{Kea::Object->throw($_message);} 
sub getRead		 					{Kea::Object->throw($_message);} 
sub getSequence 					{Kea::Object->throw($_message);} 

sub setOrientation					{Kea::Object->throw($_message);}
sub getOrientation					{Kea::Object->throw($_message);}

sub setPaddedStartConsensusPosition	{Kea::Object->throw($_message);}
sub getPaddedStartConsensusPosition	{Kea::Object->throw($_message);}

sub setQualClippingStart 			{Kea::Object->throw($_message);}
sub getQualClippingStart 			{Kea::Object->throw($_message);}

sub setQualClippingEnd 				{Kea::Object->throw($_message);}
sub getQualClippingEnd 				{Kea::Object->throw($_message);}

sub getQualClipping					{Kea::Object->throw($_message);}

sub setAlignClippingStart 			{Kea::Object->throw($_message);}
sub getAlignClippingStart 			{Kea::Object->throw($_message);}

sub setAlignClippingEnd 			{Kea::Object->throw($_message);}
sub getAlignClippingEnd 			{Kea::Object->throw($_message);}

sub getAlignClipping				{Kea::Object->throw($_message);}

sub getSize 						{Kea::Object->throw($_message);} 

sub toString 						{Kea::Object->throw($_message);}

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

