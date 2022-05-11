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

# CLASS NAME
package Kea::Phylogeny::Paml::_BranchResult;
use Kea::Object;
use Kea::Phylogeny::Paml::IBranchResult;
our @ISA = qw(Kea::Object Kea::Phylogeny::Paml::IBranchResult);

use strict;
use warnings;

use constant TRUE	=> 1;
use constant FALSE	=> 0;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	my %args = @_;
	
	my $self = {
		_branch	=> Kea::Object->check($args{-branch}),
		_omega 	=> Kea::Object->check($args{-omega}),
		_t 		=> Kea::Object->check($args{-t}),
		_S 		=> Kea::Object->check($args{-S}),
		_N 		=> Kea::Object->check($args{-N}),
		_dN		=> Kea::Object->check($args{-dN}),
		_dS		=> Kea::Object->check($args{-dS}),
		_SxdS	=> Kea::Object->check($args{-SxdS}),
		_NxdN	=> Kea::Object->check($args{-NxdN})
		};
	
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

sub getBranchString {
	return shift->{_branch};
	} # End of method.

sub getOmega {
	return shift->{_omega};
	} # End of method.

sub gett {
	return shift->{_t};
	} # End of method.

sub getS {
	return shift->{_S};
	} # End of method.

sub getN {
	return shift->{_N};
	} # End of method.

sub getdN {
	return shift->{_dN};
	} # End of method.

sub getdS {
	return shift->{_dS};
	} # End of method.

sub getSxdS {
	return shift->{_SxdS};
	} # End of method.

sub getNxdN {
	return shift->{_NxdN};
	} # End of method.

sub toString {
	my $self = shift;
	
	my $branch = $self->getBranchString;
	my $omega = $self->getOmega;
	my $t = $self->gett;
	my $S = $self->getS;
	my $N = $self->getN;
	my $dN = $self->getdN;
	my $dS = $self->getdS;
	my $SxdS = $self->getSxdS;
	my $NxdN = $self->getNxdN;
	
	
	
	return sprintf (
		"%10s %8s %8s %8s %12s %9s %9s %8s %8s",
		$branch,
		$t,
		$N,
		$S,
		$omega,
		$dN,
		$dS,
		$NxdN,
		$SxdS
		);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

