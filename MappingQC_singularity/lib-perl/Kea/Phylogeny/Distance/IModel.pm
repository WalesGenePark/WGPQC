#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 19/02/2008 20:32:25 
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
package Kea::Phylogeny::Distance::IModel;

use strict;
use warnings;
use Kea::Object;

our $_message = "Undefined method.";

################################################################################

sub getPercentIdentity				{Kea::Object->throw($_message);}

sub getDistance 					{Kea::Object->throw($_message);} 

sub getNumberOfDifferentSites		{Kea::Object->throw($_message);} 

sub getLogLikelihood 				{Kea::Object->throw($_message);} 

sub getNumberOfSites 				{Kea::Object->throw($_message);} 

sub getUncorrectedDistance 			{Kea::Object->throw($_message);} 

sub getVariance 					{Kea::Object->throw($_message);} 

sub getStandardError 				{Kea::Object->throw($_message);} 

sub get95PercentConfidenceInterval 	{Kea::Object->throw($_message);}

sub getk 							{Kea::Object->throw($_message);}

sub getk1 							{Kea::Object->throw($_message);}

sub getk2 							{Kea::Object->throw($_message);}

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

