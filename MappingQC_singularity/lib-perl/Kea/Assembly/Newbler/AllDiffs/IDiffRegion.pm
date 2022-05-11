#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 05/03/2008 12:52:54 
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
package Kea::Assembly::Newbler::AllDiffs::IDiffRegion;

use strict;
use warnings;
use Kea::Object;

our $_message = "Undefined method.";

################################################################################

sub getSummaryLine 									{Kea::Object->throw($_message);}

sub getDifferenceString								{Kea::Object->throw($_message);} 

sub getRefAlignmentLine 							{Kea::Object->throw($_message);} 

sub getReadsWithDifferenceAlignmentLineCollection	{Kea::Object->throw($_message);}

sub hasOtherReads									{Kea::Object->throw($_message);}

sub getOtherReadsAlignmentLineCollection 			{Kea::Object->throw($_message);}

sub getDiff											{Kea::Object->throw($_message);}

sub getReadIds										{Kea::Object->throw($_message);}

sub getAllAlignmentLines							{Kea::Object->throw($_message);}

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

