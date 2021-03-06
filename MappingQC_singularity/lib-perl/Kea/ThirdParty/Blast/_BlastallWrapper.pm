#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 17/02/2008 15:29:37 
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
package Kea::ThirdParty::Blast::_BlastallWrapper;
use Kea::Object;
use Kea::ThirdParty::IWrapper;
our @ISA = qw(Kea::Object Kea::ThirdParty::IWrapper);

use strict;
use warnings;
use Kea::System;

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

#?PRIVATE METHODS

my $privateMethod = sub {
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub run {

	my $self = shift;
	my %args = @_;
	
	my $program 	= $args{-p};
	my $infile		= $self->checkIsFile($args{-i});
	my $database 	= $args{-d};
	my $outfile 	= $args{-o};
	my $format		= $args{-m};
	my $e			= $args{-e} || 10;
	my $b			= $args{-b} || 250;
	my $v 			= $args{-v} || 500;
	my $a			= $args{-a} || 1;
	
	my $commandString = "-p $program -i $infile -d $database -o $outfile -m $format -e $e -b $b -v $v -a $a";
	
	Kea::System->run("blastall", $commandString);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

