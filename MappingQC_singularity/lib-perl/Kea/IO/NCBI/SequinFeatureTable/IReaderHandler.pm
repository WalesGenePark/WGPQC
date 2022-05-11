#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 12/02/2009 11:10:04
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
package Kea::IO::NCBI::SequinFeatureTable::IReaderHandler;

use strict;
use warnings;
use Kea::Object;

our $_message = "Undefined method.";

################################################################################

sub _nextHeader			{Kea::Object->throw($_message);} 

sub _nextFeature		{Kea::Object->throw($_message);}

sub _nextQualifier		{Kea::Object->throw($_message);}

sub _nextOffset			{Kea::Object->throw($_message);}

sub _nextLocation		{Kea::Object->throw($_message);}

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

