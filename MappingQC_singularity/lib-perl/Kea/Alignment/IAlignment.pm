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
package Kea::Alignment::IAlignment;

use strict;
use warnings;
use Kea::Object;

our $_message = "Undefined method";

################################################################################

sub getOverallId 						{Kea::Object->throw($_message);} 
sub setOverallId 						{Kea::Object->throw($_message);} 
sub hasOverallId 						{Kea::Object->throw($_message);}

sub getRowArrayAt 						{Kea::Object->throw($_message);} 

sub getRowStringAt 						{Kea::Object->throw($_message);} 
sub getSequence 						{Kea::Object->throw($_message);} 
sub getUnalignedSequence 				{Kea::Object->throw($_message);} 

sub getLabel 							{Kea::Object->throw($_message);} 
sub getId 								{Kea::Object->throw($_message);} 

sub getLabels 							{Kea::Object->throw($_message);} 
sub getIds 								{Kea::Object->throw($_message);} 

sub getRowStrings 						{Kea::Object->throw($_message);} 
sub getSequences 						{Kea::Object->throw($_message);} 

sub getSequenceCollection 				{Kea::Object->throw($_message);} 

sub getUnalignedSequenceCollection 		{Kea::Object->throw($_message);} 

sub getIndexForLabel 					{Kea::Object->throw($_message);} 

sub getRowStringWithLabel 				{Kea::Object->throw($_message);} 
sub getSequenceWithId 					{Kea::Object->throw($_message);} 

sub getColumnArrayAt 					{Kea::Object->throw($_message);} 

sub getColumnStringAt 					{Kea::Object->throw($_message);} 

sub getColumnAt 						{Kea::Object->throw($_message);} 
sub getRowAt 							{Kea::Object->throw($_message);} 
sub getRowCollection 					{Kea::Object->throw($_message);} 
sub getColumnCollection 				{Kea::Object->throw($_message);} 
sub setColumnCollection 				{Kea::Object->throw($_message);} 

sub getNumberOfRows 					{Kea::Object->throw($_message);} 
sub getSize 							{Kea::Object->throw($_message);} 

sub getNumberOfColumns 					{Kea::Object->throw($_message);} 
sub getNumberOfIdenticalSites			{Kea::Object->throw($_message);} 
sub getNumberOfDifferentSites			{Kea::Object->throw($_message);}

sub getMatrix							{Kea::Object->throw($_message);}

sub getAlignmentBlock					{Kea::Object->throw($_message);}

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

