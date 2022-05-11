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

#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////

# CLASS NAME
package Kea::Utilities::DirUtility;

## Purpose		: Encapsulates useful directory-related methods.

use strict;
use warnings;
use Carp;
use Cwd;
use Cwd 'abs_path';
use Kea::Arg;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant FASTA 		=> "fasta";
use constant EMBL 		=> "embl";
use constant UNKNOWN 	=> "unknown";
use constant HASH 		=> "HASH";
use constant ARRAY 		=> "ARRAY";

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

## Purpose		: Constructor.
## Parameter	: n/a.
## Throws		: n/a.
sub new {
	my $className = shift;
	
	my $self = {};
	
	bless(
		$self,
		$className
		);
	
	return $self;
	
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $privateMethod = sub {
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

## Purpose		: Returns number of files within directory.
## Returns		: n/a.
## Parameter	: n/a.
## Throws		: n/a.
sub countFiles {

	my $self 	= shift;
	my $dir 	= Kea::Arg->checkIsDir(shift);
	
	opendir(DIR, $dir) or confess "\nERROR: Could not open $dir.\n\n";
	my @contents = readdir(DIR);
	closedir(DIR) or confess "\nERROR: Could not close $dir.\n\n";
	
	my $count = 0;
	foreach (@contents) {
		if (/^\.+$/) {next;}
		if (!(-d $_)) {$count++;print "$_\n";}
		}
	
	return $count;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

