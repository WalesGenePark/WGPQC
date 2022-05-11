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
package Kea::Phylogeny::Paml::_BadCodemlResult;

# Inherits from
use base qw(Kea::Phylogeny::Paml::ICodemlResult);


## Purpose		: 

use strict;
use warnings;
use Carp;
use Kea::Arg;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

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

sub getId {
	return shift->{_id} or confess "\nERROR: Id has not been set.\n\n";
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setId {
	
	my $self 	= shift;
	my $id 		= Kea::Arg->check(shift);
	
	$self->{_id} = $id;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getKappa {
	confess "\nERROR: Paml analysis was unsuccessful - always use isSuccessful method to check.\n\n";
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getBranchResultCollection {
	confess "\nERROR: Paml analysis was unsuccessful - always use isSuccessful method to check.\n\n";
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getMaxOmega {
	confess "\nERROR: Paml analysis was unsuccessful - always use isSuccessful method to check.\n\n";
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getMinOmega {
	confess "\nERROR: Paml analysis was unsuccessful - always use isSuccessful method to check.\n\n";
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getMeanOmega {
	confess "\nERROR: Paml analysis was unsuccessful - always use isSuccessful method to check.\n\n";
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLogLikelihood {
	confess "\nERROR: Paml analysis was unsuccessful - always use isSuccessful method to check.\n\n";
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub isSuccessful {
	return FALSE;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	confess "\nERROR: Paml analysis was unsuccessful - always use isSuccessful method to check.\n\n";
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

