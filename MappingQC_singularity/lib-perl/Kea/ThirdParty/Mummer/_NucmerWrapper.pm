#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 16/02/2008 17:48:49 
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
package Kea::ThirdParty::Mummer::_NucmerWrapper;
use Kea::Object;
use Kea::ThirdParty::IWrapper;
our @ISA = qw(Kea::Object Kea::ThirdParty::IWrapper);

use strict;
use warnings;
use File::Copy;
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

#ÊPRIVATE METHODS

my $privateMethod = sub {
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub run {

	my $self = shift;
	my %args = @_;	
		
	# Get arguments
	my $referenceInfile = $self->checkIsFile($args{-referenceInfile});;
	my $queryInfile 	= $self->checkIsFile($args{-queryInfile});
	my $deltaOutfile 	= $self->check($args{-deltaOutfile});
	my $clusterOutfile 	= $self->check($args{-clusterOutfile});
	my $coordsOutfile 	= $self->check($args{-coordsOutfile});
	
	# Construct command.
	my $commandArgs = "--coords $referenceInfile $queryInfile";
	
	Kea::System->run("nucmer", $commandArgs);
	
	# NUCmer generates out.cluster out.delta and out.coords.  These need to be renamed.
	move("out.delta", $deltaOutfile);
	move("out.cluster", $clusterOutfile);
	move("out.coords", $coordsOutfile);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

