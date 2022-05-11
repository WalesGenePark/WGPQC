#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 20/02/2008 21:02:47 
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
package Kea::Alignment::Pairwise::IStatistics;

use strict;
use warnings;
use Kea::Object;

our $_message = "Undefined method.";

################################################################################

sub n			{Kea::Object->throw($_message);}

sub TT			{Kea::Object->throw($_message);}
sub TC 			{Kea::Object->throw($_message);}
sub TA 			{Kea::Object->throw($_message);}
sub TG 			{Kea::Object->throw($_message);}

sub CT 			{Kea::Object->throw($_message);}
sub CC 			{Kea::Object->throw($_message);}
sub CA 			{Kea::Object->throw($_message);}
sub CG 			{Kea::Object->throw($_message);}

sub AT 			{Kea::Object->throw($_message);}
sub AC 			{Kea::Object->throw($_message);}
sub AA 			{Kea::Object->throw($_message);}
sub AG 			{Kea::Object->throw($_message);}

sub GT 			{Kea::Object->throw($_message);}
sub GC 			{Kea::Object->throw($_message);}
sub GA 			{Kea::Object->throw($_message);}
sub GG 			{Kea::Object->throw($_message);}

sub freqTT 		{Kea::Object->throw($_message);}
sub freqTC 		{Kea::Object->throw($_message);}
sub freqTA 		{Kea::Object->throw($_message);}
sub freqTG 		{Kea::Object->throw($_message);}

sub freqCT 		{Kea::Object->throw($_message);}
sub freqCC 		{Kea::Object->throw($_message);}
sub freqCA 		{Kea::Object->throw($_message);}
sub freqCG 		{Kea::Object->throw($_message);}

sub freqAT 		{Kea::Object->throw($_message);}
sub freqAC 		{Kea::Object->throw($_message);}
sub freqAA 		{Kea::Object->throw($_message);}
sub freqAG 		{Kea::Object->throw($_message);}

sub freqGT 		{Kea::Object->throw($_message);}
sub freqGC 		{Kea::Object->throw($_message);}
sub freqGA 		{Kea::Object->throw($_message);}
sub freqGG 		{Kea::Object->throw($_message);}


sub sumFreqTi 	{Kea::Object->throw($_message);}
sub sumFreqCi 	{Kea::Object->throw($_message);}
sub sumFreqAi 	{Kea::Object->throw($_message);}
sub sumFreqGi 	{Kea::Object->throw($_message);}

sub sumFreqTj 	{Kea::Object->throw($_message);}
sub sumFreqCj 	{Kea::Object->throw($_message);}
sub sumFreqAj 	{Kea::Object->throw($_message);}
sub sumFreqGj 	{Kea::Object->throw($_message);}

sub meanFreqT 	{Kea::Object->throw($_message);}
sub meanFreqC 	{Kea::Object->throw($_message);}
sub meanFreqA 	{Kea::Object->throw($_message);}
sub meanFreqG 	{Kea::Object->throw($_message);}
	
sub meanFreqY 	{Kea::Object->throw($_message);}
sub meanFreqR 	{Kea::Object->throw($_message);}


# Proportion of sites with transitional differences. 
sub S 			{Kea::Object->throw($_message);}

# Proportion of sites with transversional differences.
sub V 			{Kea::Object->throw($_message);}

sub S1 			{Kea::Object->throw($_message);}
sub S2 			{Kea::Object->throw($_message);}
	
sub toString 	{Kea::Object->throw($_message);}

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

