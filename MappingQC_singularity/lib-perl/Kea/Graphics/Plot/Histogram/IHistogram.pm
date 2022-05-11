#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 28/05/2008 14:46:50
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
package Kea::Graphics::Plot::Histogram::IHistogram;

use strict;
use warnings;
use Kea::Object;

our $_message = "Undefined method.";

################################################################################

# Returns ordered bin objects associated with histogram.  Each bin 
# corrresponds to a separate bar in the histogram.
sub getBinCollection 	{Kea::Object->throw($_message);}
	
# Returns the lower limit of the first bin (bar) within the histogram.
sub getStart 			{Kea::Object->throw($_message);}
	
# Returns the upper limit of the final bin (bar) within the histogram.
sub getEnd 				{Kea::Object->throw($_message);}
	
# Returns height of tallest bar in histogram (highest bin count).
sub getHighestCount		{Kea::Object->throw($_message);}

# Returns size of bin which is equivalent to width of histogram bar.
sub getBinSize 			{Kea::Object->throw($_message);}

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

