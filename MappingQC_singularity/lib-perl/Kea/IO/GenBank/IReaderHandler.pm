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
package Kea::IO::GenBank::IReaderHandler;

use Kea::Object;
use strict;
use warnings;


our $_message = "Undefined method.";

################################################################################

sub _nextIDLine 					{Kea::Object->throw($_message);}

sub _nextDefinition					{Kea::Object->throw($_message);}

sub _nextAccessionLine 				{Kea::Object->throw($_message);}

sub _nextVersionLine				{Kea::Object->throw($_message);}

sub _nextProjectIdLine				{Kea::Object->throw($_message);}

sub _nextKeywordsLine 				{Kea::Object->throw($_message);}

sub _nextSequence 					{Kea::Object->throw($_message);}

sub _nextSourceOrganismLine			{Kea::Object->throw($_message);}

sub _nextSourcePhylogeny			{Kea::Object->throw($_message);}

sub _nextComment					{Kea::Object->throw($_message);}

sub _nextReferenceNumberLine		{Kea::Object->throw($_message);}

sub _nextReferenceTitle				{Kea::Object->throw($_message);} 

sub _nextReferenceJournal			{Kea::Object->throw($_message);} 

sub _nextReferenceAuthors			{Kea::Object->throw($_message);}

sub _nextFeatureObject 				{Kea::Object->throw($_message);}

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

