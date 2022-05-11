#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 21/04/2008 15:07:58
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
package Kea::IO::Gff::IGffRecord;

use strict;
use warnings;
use Kea::Object;

our $_message = "Undefined method.";

################################################################################

sub getPrimaryAccession					{Kea::Object->throw($_message);}

sub setFeatureOntologyURI				{Kea::Object->throw($_message);}
sub getFeatureOntologyURI				{Kea::Object->throw($_message);}

sub setAttributeOntologyURI				{Kea::Object->throw($_message);}
sub getAttributeOntologyURI 			{Kea::Object->throw($_message);}

sub getSource							{Kea::Object->throw($_message);}
sub setSource							{Kea::Object->throw($_message);}

sub getFeature							{Kea::Object->throw($_message);}
sub setFeature							{Kea::Object->throw($_message);}

sub getLocation							{Kea::Object->throw($_message);}
sub setLocation							{Kea::Object->throw($_message);}

sub getScore							{Kea::Object->throw($_message);}
sub setScore							{Kea::Object->throw($_message);}

sub getOrientation						{Kea::Object->throw($_message);}
sub setOrientation						{Kea::Object->throw($_message);}

sub getFrame							{Kea::Object->throw($_message);}
sub setFrame							{Kea::Object->throw($_message);}
		
sub getAttributes						{Kea::Object->throw($_message);}
sub setAttributes						{Kea::Object->throw($_message);}
		
sub getSequence							{Kea:;Object->throw($_message);}
sub setSequence							{Kea::Object->throw($_message);}
sub hasSequence							{Kea::Object->throw($_message);}

sub getTranslationSequenceCollection	{Kea::Object->throw($_message);}
sub hasTranslations						{Kea::Object->throw($_message);}
	
sub getGffFeatureCollection				{Kea::Object->throw($_message);}
	
sub getCDSFeatureCollection 			{Kea::Object->throw($_message);}

sub getFeatureCollection				{Kea::Object->throw($_message);}

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

