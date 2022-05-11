#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 09/04/2008 12:28:22
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
package Kea::Assembly::Newbler::AllDiffs::ISummaryLine;

use strict;
use warnings;
use Kea::Object;

our $_message = "Undefined method.";

################################################################################

sub getReferenceId 						{Kea::Object->throw($_message);}

sub getLocation 						{Kea::Object->throw($_message);}

sub getRefSequenceAtLocation 			{Kea::Object->throw($_message);}

sub getDifferingSequencesAtLocation		{Kea::Object->throw($_message);}

sub getTotalFowardReadsWithDifference 	{Kea::Object->throw($_message);}

sub getTotalReverseReadsWithDifference 	{Kea::Object->throw($_message);}

sub getTotalReadsWithDifference 		{Kea::Object->throw($_message);}

sub getTotalReads 						{Kea::Object->throw($_message);}

sub getPercentDifferentReads			{Kea::Object->throw($_message);}

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

