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
package Kea::IO::Paml::PairwiseCodemlResult::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::Paml::PairwiseCodemlResult::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::Paml::PairwiseCodemlResult::IReaderHandler);

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use Kea::Phylogeny::Paml::_Result;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;

	my $self = {
		_logLikelihood 	=> undef,
		_kappa 			=> undef,
		_omega 			=> undef,
		_t 				=> undef,
		_S 				=> undef,
		_N 				=> undef,
		_dN				=> undef,
		_dS				=> undef,
		_SxdS			=> undef,
		_NxdN			=> undef
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

sub _logLikelihood {
	
	my $self = shift;
	my $logLikelihood = $self->checkIsNumber(shift);
	$self->{_logLikelihood} = $logLikelihood;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _kappa {
	
	my $self = shift;
	my $kappa = $self->checkIsNumber(shift);
	$self->{_kappa} = $kappa;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _omega {
	
	my $self = shift;
	my $omega = $self->checkIsNumber(shift);
	$self->{_omega} = $omega;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _t {
	
	my $self = shift;
	my $t = $self->checkIsNumber(shift);
	$self->{_t} = $t;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _S {
	
	my $self = shift;
	my $S = $self->checkIsNumber(shift);
	$self->{_S} = $S;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _N {
	
	my $self = shift;
	my $N = $self->checkIsNumber(shift);
	$self->{_N} = $N;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _dN {
	
	my $self = shift;
	my $dN = $self->checkIsNumber(shift);
	$self->{_dN} = $dN;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _dS {
	
	my $self = shift;
	my $dS = $self->checkIsNumber(shift);
	$self->{_dS} = $dS;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////
	
sub getResult {
	
	my $self = shift;
	
	my $omega 			= $self->check($self->{_omega});
	my $kappa			= $self->{_kappa};
	my $t 				= $self->check($self->{_t});
	my $S 				= $self->check($self->{_S});
	my $N 				= $self->check($self->{_N});
	my $dN				= $self->check($self->{_dN});
	my $dS				= $self->check($self->{_dS});
	my $logLikelihood 	= $self->check($self->{_logLikelihood});
	
	return Kea::Phylogeny::Paml::_Result->new(
		-omega 			=> $omega,
		-kappa			=> $kappa,
		-t 				=> $t,
		-S 				=> $S,
		-N 				=> $N,
		-dN				=> $dN,
		-dS				=> $dS,
		-logLikelihood 	=> $logLikelihood
		);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;