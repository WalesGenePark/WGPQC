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
package Kea::IO::IRecord;

use strict;
use warnings;
use Kea::Object;

our $_message = "Undefined method";

################################################################################

sub setPrimaryAccession 		{Kea::Object->throw($_message);} 
sub getPrimaryAccession 		{Kea::Object->throw($_message);}

sub getAccession			{Kea::Object->throw($_message);}
sub setAccession			{Kea::Object->throw($_message);}

sub hasAccessionNumericalSuffix		{Kea::Object->throw($_message);}
sub getAccessionNumericalSuffix		{Kea::Object->throw($_message);}

sub getVersion  			{Kea::Object->throw($_message);} 
sub setVersion 				{Kea::Object->throw($_message);} 
	
sub getTopology 			{Kea::Object->throw($_message);} 
sub setTopology 			{Kea::Object->throw($_message);}
sub hasTopology 			{Kea::Object->throw($_message);}

sub getMoleculeType 			{Kea::Object->throw($_message);} 
sub setMoleculeType 			{Kea::Object->throw($_message);}
sub hasMoleculeType			{Kea::Object->throw($_message);}

sub getDescription			{Kea::Object->throw($_message);}
sub setDescription			{Kea::Object->throw($_message);}
sub hasDescription			{Kea::Object->throw($_message);}

# Use description instead
#sub getDefinition						{Kea::Object->throw($_message);}
#sub setDefinition						{Kea::Object->throw($_message);}
#sub hasDefinition						{Kea::Object->throw($_message);}

sub getComment							{Kea::Object->throw($_message);}
sub setComment							{Kea::Object->throw($_message);}
sub hasComment							{Kea::Object->throw($_message);}

sub getSource							{Kea::Object->throw($_message);}
sub setSource							{Kea::Object->throw($_message);}
sub hasSource							{Kea::Object->throw($_message);}

sub getSourcePhylogeny					{Kea::Object->throw($_message);}
sub setSourcePhylogeny					{Kea::Object->throw($_message);}
sub hasSourcePhylogeny					{Kea::Object->throw($_message);}

sub getProjectId						{Kea::Object->throw($_message);}
sub setProjectId						{Kea::Object->throw($_message);}
sub hasProjectId						{Kea::Object->throw($_message);}

sub getKeywords							{Kea::Object->throw($_message);}
sub setKeywords							{Kea::Object->throw($_message);}
sub hasKeywords							{Kea::Object->throw($_message);}

sub getLocusTagPrefix					{Kea::Object->throw($_message);}
sub setLocusTagPrefix					{Kea::Object->throw($_message);}

sub getLocusTags						{Kea::Object->throw($_message);}
sub getNextAvailableLocusTag			{Kea::Object->throw($_message);}
sub getNextAvailableLocusTagNumber		{Kea::Object->throw($_message);}

# Embl specific
sub getDataClass 						{Kea::Object->throw($_message);} 
sub setDataClass 						{Kea::Object->throw($_message);}
sub hasDataClass						{Kea::Object->throw($_message);}

sub getTranslTable						{Kea::Object->throw($_message);}
sub setTranslTable						{Kea::Object->throw($_message);}

sub getTaxonomicDivision 				{Kea::Object->throw($_message);}  
sub setTaxonomicDivision 				{Kea::Object->throw($_message);}
sub hasTaxonomicDivision 				{Kea::Object->throw($_message);}
		
sub getExpectedLength 					{Kea::Object->throw($_message);} 
sub setExpectedLength 					{Kea::Object->throw($_message);} 
		
sub getSequence 						{Kea::Object->throw($_message);}  
sub setSequence 						{Kea::Object->throw($_message);}

sub getSequenceObject 					{Kea::Object->throw($_message);}

sub getDNASequenceAtLocations			{Kea::Object->throw($_message);}

sub getReferenceCollection				{Kea::Object->throw($_message);}

#sub getLocation 						{Kea::Object->throw($_message);}
#sub setLocation						{Kea::Object->throw($_message);}

sub convertToReverseComplement			{Kea::Object->throw($_message);}						

sub getCodonAt 							{Kea::Object->throw($_message);} 
sub getSubsequenceAt 					{Kea::Object->throw($_message);}  
sub getLength 							{Kea::Object->throw($_message);}  

sub addFeature 							{Kea::Object->throw($_message);} 

sub setFeatures 						{Kea::Object->throw($_message);} 	

sub getFeatures 						{Kea::Object->throw($_message);}

sub getSortedFeatures					{Kea::Object->throw($_message);}

#ÊNote that cds features and gene features are joined in different ways.
sub joinCDSFeatures	 					{Kea::Object->throw($_message);}  
sub joinGeneFeatures					{Kea::Object->throw($_message);}

sub getGeneFeatureCorrespondingToCDS 	{Kea::Object->throw($_message);}  
sub getFeaturesWithPosition 			{Kea::Object->throw($_message);} 
sub getFeatureIndex 					{Kea::Object->throw($_message);}  
sub deleteFeature 						{Kea::Object->throw($_message);}  
sub hasFeature 							{Kea::Object->throw($_message);}  
sub getFeature 							{Kea::Object->throw($_message);}



sub getNumberOfFeatures 		{Kea::Object->throw($_message);}  
sub getCDSFeatureWithProteinId 	        {Kea::Object->throw($_message);}  
sub getAllCDSFeatures 			{Kea::Object->throw($_message);}  
sub getCDSFeatures 			{Kea::Object->throw($_message);}
sub getFeatureColection			{Kea::Object->throw($_message);}
sub setFeatureCollection		{Kea::Object->throw($_message);}
sub getCDSFeatureCollection 		{Kea::Object->throw($_message);} 
sub getProteinIdList 			{Kea::Object->throw($_message);}  

sub equals 				{Kea::Object->throw($_message);}
sub toString 				{Kea::Object->throw($_message);}  

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

