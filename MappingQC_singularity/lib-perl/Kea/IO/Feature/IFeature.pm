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
package Kea::IO::Feature::IFeature;

use strict;
use warnings;
use Kea::Object;

our $_message = "Undefined method";

################################################################################

sub getParent 							{Kea::Object->throw($_message);} 

sub setParent 							{Kea::Object->throw($_message);} 

sub getUniqueId 						{Kea::Object->throw($_message);} 

sub setDNASequence 						{Kea::Object->throw($_message);} 

sub getDNASequence 						{Kea::Object->throw($_message);} 

sub hasDNASequence 						{Kea::Object->throw($_message);} 

sub getTranslation 						{Kea::Object->throw($_message);} 

sub setTranslation 						{Kea::Object->throw($_message);} 

sub getProduct 							{Kea::Object->throw($_message);} 

sub setProduct 							{Kea::Object->throw($_message);} 

sub isPseudo 							{Kea::Object->throw($_message);} 

sub setPseudo 							{Kea::Object->throw($_message);} 

sub getLocusTag 						{Kea::Object->throw($_message);} 

sub setLocusTag 						{Kea::Object->throw($_message);} 

sub getProteinId 						{Kea::Object->throw($_message);} 

sub setProteinId 						{Kea::Object->throw($_message);} 

sub getCodonStart 						{Kea::Object->throw($_message);} 

sub setCodonStart 						{Kea::Object->throw($_message);} 

sub getTranslTable 						{Kea::Object->throw($_message);} 

sub setTranslTable 						{Kea::Object->throw($_message);} 

sub getMolType 							{Kea::Object->throw($_message);} 

sub getOrientation 						{Kea::Object->throw($_message);} 

sub setOrientation 						{Kea::Object->throw($_message);}

sub reverseOrientation					{Kea::Object->throw($_message);}

sub setMolType 							{Kea::Object->throw($_message);} 

sub getDbXref 							{Kea::Object->throw($_message);} 

sub setDbXref 							{Kea::Object->throw($_message);} 

sub getOrganism 						{Kea::Object->throw($_message);} 

sub getStrain 							{Kea::Object->throw($_message);} 

sub getName 							{Kea::Object->throw($_message);}

sub setName 							{Kea::Object->throw($_message);}

sub getGene 							{Kea::Object->throw($_message);} 

sub setGene 							{Kea::Object->throw($_message);}

sub getLocations 						{Kea::Object->throw($_message);} 

sub getLocation 						{Kea::Object->throw($_message);}

sub getFirstLocation					{Kea::Object->throw($_message);}

sub getLastLocation						{Kea::Object->throw($_message);}

sub setLocations 						{Kea::Object->throw($_message);}

sub addLocation							{Kea::Object->throw($_message);}

sub getSize 							{Kea::Object->throw($_message);}

sub getColour 							{Kea::Object->throw($_message);} 

sub setColour 							{Kea::Object->throw($_message);}

sub hasColour							{Kea::Object->throw($_message);}

sub getNote 							{Kea::Object->throw($_message);} 

sub setNote 							{Kea::Object->throw($_message);} 

sub appendToNote 						{Kea::Object->throw($_message);}

sub getNumber							{Kea::Object->throw($_message);}

sub setNumber							{Kea::Object->throw($_message);}

sub getEstimatedLength					{Kea::Object->throw($_message);}

sub setEstimatedLength					{Kea::Object->throw($_message);}

sub getRptFamily						{Kea::Object->throw($_message);}

sub setRptFamily						{Kea::Object->throw($_message);}

sub getInference						{Kea::Object->throw($_message);}

sub setInference						{Kea::Object->throw($_message);}

sub getException						{Kea::Object->throw($_message);}

sub setException						{Kea::Object->throw($_message);}

sub getProtDesc							{Kea::Object->throw($_message);}

sub setProtDesc							{Kea::Object->throw($_message);}

sub getAllQualifiersAsMap				{Kea::Object->throw($_message);}

sub setQualifier						{Kea::Object->throw($_message);}

sub hasQualifier						{Kea::Object->throw($_message);}

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

