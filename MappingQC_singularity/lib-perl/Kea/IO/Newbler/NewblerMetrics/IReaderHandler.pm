#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 30/01/2009 16:03:01
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
package Kea::IO::Newbler::NewblerMetrics::IReaderHandler;

use strict;
use warnings;
use Kea::Object;

our $_message = "Undefined method.";

################################################################################

sub _totalNumberOfReads 		{Kea::Object->throw($_message);}
			
sub _totalNumberOfBases			{Kea::Object->throw($_message);}
				
sub _numberOfSearches			{Kea::Object->throw($_message);}
			
sub _seedHitsFound				{Kea::Object->throw($_message);}
			
sub _overlapsFound				{Kea::Object->throw($_message);}
		
sub _overlapsReported			{Kea::Object->throw($_message);}
			
sub _overlapsUsed				{Kea::Object->throw($_message);}

#==========================================================

sub _numAlignedReads			{Kea::Object->throw($_message);}

sub _numAlignedBases			{Kea::Object->throw($_message);}

sub _inferredReadError			{Kea::Object->throw($_message);}

#==========================================================

sub _numberAssembled			{Kea::Object->throw($_message);}

sub _numberPartial				{Kea::Object->throw($_message);}

sub _numberSingletons			{Kea::Object->throw($_message);}

sub _numberRepeat				{Kea::Object->throw($_message);}

sub _numberOutlier				{Kea::Object->throw($_message);}

sub _numberTooShort				{Kea::Object->throw($_message);}

#==========================================================

sub _numberOfLargeContigs		{Kea::Object->throw($_message);}

sub _numberOfLargeContigBases	{Kea::Object->throw($_message);}

sub _avgLargeContigSize			{Kea::Object->throw($_message);}

sub _N50ContigSize				{Kea::Object->throw($_message);}

sub _largestContigSize			{Kea::Object->throw($_message);}

sub _Q40PlusBases				{Kea::Object->throw($_message);}

sub _Q39MinusBases				{Kea::Object->throw($_message);}

#==========================================================

sub _numberOfContigs		 	{Kea::Object->throw($_message);}

sub _numberOfBases				{Kea::Object->throw($_message);}

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

