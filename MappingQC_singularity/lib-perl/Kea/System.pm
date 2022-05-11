#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 16/02/2008 18:10:10 
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

# CLASS NAME
package Kea::System;
use Kea::Object;
our @ISA = qw(Kea::Object);

use strict;
use warnings;
use Term::ANSIColor;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

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

sub run {
	
	my $self 	= shift;
	my $program = $self->check(shift);
	my $args	= $self->check(shift);
	
	#ÊCheck program exists
	
	
	my $command = "$program $args";
	
	eval {
		
		print color "green";
		print
			"\n".
			"\t---------------------------\n".
			"\t Running $program  \n".
			"\t---------------------------\n".
			"\n";
		print "$command\n";	
		system($command);
		if ($? == -1) {
			$self->throw("$program failed with message $?\n");
			}
		print
			"\n".
			"\t---------------------------\n".
			"\t $program finished \n".
			"\t---------------------------\n".
			"\n";
		print color "reset";
		
		};
	$self->throw($@) if $@;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

