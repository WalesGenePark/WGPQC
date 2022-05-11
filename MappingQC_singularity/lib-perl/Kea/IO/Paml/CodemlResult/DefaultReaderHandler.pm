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
package Kea::IO::Paml::CodemlResult::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::Paml::CodemlResult::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::Paml::CodemlResult::IReaderHandler);

## Purpose		: 

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use Kea::Phylogeny::Paml::_CodemlResult;
use Kea::Phylogeny::Paml::_BadCodemlResult;
use Kea::Phylogeny::Paml::BranchResultCollection;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $branchResultCollection =
		Kea::Phylogeny::Paml::BranchResultCollection->new("null");
	
	my $self = {
		_logLikelihood 			=> undef,
		_kappa 					=> undef,
		_treeLength				=> undef,
		_dNTreeLength			=> undef,
		_dSTreeLength			=> undef,
		_branchResultCollection => $branchResultCollection
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
################################################################################

sub unlabelledTree {
	my $self = shift;
	$self->{_unlabelledTree} = $self->check(shift, "Kea::Phylogeny::ITree");
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub labelledTree {
	my $self = shift;
	$self->{_labelledTree} = $self->check(shift, "Kea::Phylogeny::ITree");
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub logLikelihood {
	my $self = shift;
	$self->{_logLikelihood} = $self->checkIsNumber(shift);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub kappa {
	my $self = shift;
	$self->{_kappa} = $self->checkIsNumber(shift);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub treeLength {
	my $self = shift;
	$self->{_treeLength} = Kea::Arg->checkIsNumber(shift);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub dNTreeLength {
	my $self = shift;
	$self->{_dNTreeLength} = Kea::Arg->checkIsNumber(shift);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub dSTreeLength {
	my $self = shift;
	$self->{_dSTreeLength} = Kea::Arg->checkIsNumber(shift);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub nextBranchResult {

	my $self 			= shift;
	my $branchResult 	= $self->check(shift, "Kea::Phylogeny::Paml::IBranchResult");
	
	$self->{_branchResultCollection}->add($branchResult);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub successful {

	my $self = shift;
	
	if (
	
		defined $self->{_kappa} 					&&
		defined $self->{_branchResultCollection} 	&&
		defined $self->{_logLikelihood} 			&&
		defined $self->{_treeLength} 				&&
		defined $self->{_dNTreeLength} 				&&
		defined $self->{_dSTreeLength}
		
		) {
		return TRUE;
		}
	else {
		return FALSE;
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getCodemlResult {

	my $self = shift;
	
	if ($self->successful) {
	
		return Kea::Phylogeny::Paml::_CodemlResult->new(
		
			-logLikelihood 			=> $self->{_logLikelihood},
			-kappa 					=> $self->{_kappa},
			-branchResultCollection => $self->{_branchResultCollection},
			-unlabelledTree			=> $self->{_unlabelledTree},
			-labelledTree			=> $self->{_labelledTree},
			-treeLength 			=> $self->{_treeLength},
			-dNTreeLength			=> $self->{_dNTreeLength},
			-dSTreeLength			=> $self->{_dSTreeLength}
			
			);
		
		}
	
	else {
		warn "\nWARNING: Unsuccessful codeml.\n\n";
		return Kea::Phylogeny::Paml::_BadCodemlResult->new;
		}
	

	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

=pod
kappa (ts/tv) =  4.54008

dN & dS for each branch

 branch           t        S        N    dN/dS       dN       dS   S*dS   N*dN

   8..9       0.068    107.8    282.2   0.8066   0.0213   0.0263    2.8    6.0
   9..1       0.026    107.8    282.2   0.8066   0.0080   0.0099    1.1    2.3
   9..2       0.039    107.8    282.2   0.8066   0.0122   0.0151    1.6    3.4
   8..10      0.043    107.8    282.2   0.8066   0.0136   0.0168    1.8    3.8
  10..11      0.076    107.8    282.2   0.8066   0.0239   0.0296    3.2    6.7
  11..3       0.044    107.8    282.2   0.8066   0.0137   0.0170    1.8    3.9
  11..4       0.053    107.8    282.2   0.8066   0.0164   0.0204    2.2    4.6
  10..5       0.022    107.8    282.2   0.8066   0.0068   0.0084    0.9    1.9
   8..12      0.123    107.8    282.2   0.8066   0.0383   0.0475    5.1   10.8
  12..6       0.041    107.8    282.2   0.8066   0.0128   0.0158    1.7    3.6
  12..7       0.024    107.8    282.2   0.8066   0.0075   0.0093    1.0    2.1

tree length for dN:      0.17433
tree length for dS:      0.21612

=cut