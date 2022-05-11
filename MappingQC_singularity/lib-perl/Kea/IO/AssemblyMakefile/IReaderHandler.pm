#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 05/06/2008 10:09:10
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
package Kea::IO::AssemblyMakefile::IReaderHandler;

use strict;
use warnings;
use Kea::Object;

our $_message = "Undefined method.";

################################################################################

sub _primaryAccession	{Kea::Object->throw($_message);}

sub _contigSeparator	{Kea::Object->throw($_message);}

sub _referenceDirectory	{Kea::Object->throw($_message);}

sub _bestReference		{Kea::Object->throw($_message);}

sub _sourceContigFile	{Kea::Object->throw($_message);}

sub _nextPosition		{Kea::Object->throw($_message);}

sub _nextContig			{Kea::Object->throw($_message);}

sub _nextScript 		{Kea::Object->throw($_message);}

sub _outfileName		{Kea::Object->throw($_message);}

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

