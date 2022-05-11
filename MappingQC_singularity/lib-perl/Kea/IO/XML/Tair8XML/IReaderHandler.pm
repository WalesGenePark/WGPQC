#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 19/12/2008 16:37:25
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
package Kea::IO::XML::Tair8XML::IReaderHandler;

use strict;
use warnings;
use Kea::Object;

our $_message = "Undefined method.";

################################################################################

sub _pseudochromosomeStart	{Kea::Object->throw($_message);}

sub _pseudochromosomeEnd	{Kea::Object->throw($_message);}

sub _tuStart				{Kea::Object->throw($_message);}

sub _tuEnd					{Kea::Object->throw($_message);}

sub _modelStart				{Kea::Object->throw($_message);}

sub _modelEnd				{Kea::Object->throw($_message);}

sub _exonStart				{Kea::Object->throw($_message);}

sub _exonEnd				{Kea::Object->throw($_message);}

sub _cdsStart				{Kea::Object->throw($_message);}

sub _cdsEnd					{Kea::Object->throw($_message);}

sub _utrsStart				{Kea::Object->throw($_message);}

sub _utrsEnd				{Kea::Object->throw($_message);}

sub _cdsCoordsetStart		{Kea::Object->throw($_message);}

sub _cdsCoordsetEnd			{Kea::Object->throw($_message);}

sub _utrsCoordsetStart		{Kea::Object->throw($_message);}

sub _utrsCoordsetEnd		{Kea::Object->throw($_message);}

sub _exonCoordsetStart		{Kea::Object->throw($_message);}

sub _exonCoordsetEnd		{Kea::Object->throw($_message);}

sub _tuCoordsetStart		{Kea::Object->throw($_message);}

sub _tuCoordsetEnd			{Kea::Object->throw($_message);}

sub _nextCdsEnd5			{Kea::Object->throw($_message);}

sub _nextCdsEnd3			{Kea::Object->throw($_message);}

sub _nextUtrsEnd5			{Kea::Object->throw($_message);}

sub _nextUtrsEnd3			{Kea::Object->throw($_message);}

sub _nextExonEnd5			{Kea::Object->throw($_message);}

sub _nextExonEnd3			{Kea::Object->throw($_message);}

sub _nextTuEnd5				{Kea::Object->throw($_message);}

sub _nextTuEnd3				{Kea::Object->throw($_message);}

sub _nextExonFeatureName	{Kea::Object->throw($_message);}

sub _nextCdsFeatureName		{Kea::Object->throw($_message);}

sub _nextModelFeatureName	{Kea::Object->throw($_message);}

sub _nextModelPubLocus		{Kea::Object->throw($_message);}

sub _nextTuFeatureName		{Kea::Object->throw($_message);}

sub _nextTuPubLocus			{Kea::Object->throw($_message);}

sub _nextProteinSequence	{Kea::Object->throw($_message);}

sub _nextCdsSequence		{Kea::Object->throw($_message);}

sub _nextTuIsPseudogene		{Kea::Object->throw($_message);}

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

