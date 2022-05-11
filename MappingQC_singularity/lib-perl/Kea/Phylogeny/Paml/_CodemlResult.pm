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
package Kea::Phylogeny::Paml::_CodemlResult;
use Kea::Object;
use Kea::Phylogeny::Paml::ICodemlResult;
our @ISA = qw(Kea::Object Kea::Phylogeny::Paml::ICodemlResult);

use strict;
use warnings;

use constant TRUE => 1;
use constant FALSE => 0;

use Kea::Statistics::DescriptiveStatistics;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className	= shift;
	my %args 		= @_;
	
	my $logLikelihood 			= Kea::Object->checkIsNumber($args{-logLikelihood});
	my $kappa 					= Kea::Object->checkIsNumber($args{-kappa});
	my $branchResultCollection 	= Kea::Object->check($args{-branchResultCollection}, "Kea::Phylogeny::Paml::BranchResultCollection");
	my $unlabelledTree			= Kea::Object->check($args{-unlabelledTree}, "Kea::Phylogeny::ITree");
	my $labelledTree			= Kea::Object->check($args{-labelledTree}, "Kea::Phylogeny::ITree");
	my $treeLength				= Kea::Object->checkIsNumber($args{-treeLength});
	my $dNTreeLength			= Kea::Object->checkIsNumber($args{-dNTreeLength});
	my $dSTreeLength			= Kea::Object->checkIsNumber($args{-dSTreeLength});
	
	my @omegas;
	for (my $i = 0; $i < $branchResultCollection->getSize; $i++) {
		my $branchResult = $branchResultCollection->get($i);
		push(
			@omegas,
			$branchResult->getOmega
			);
		}
	
	my $stats = Kea::Statistics::DescriptiveStatistics->new(-data => \@omegas);
	
	
	my $self = {
		_logLikelihood 			=> $logLikelihood,
		_kappa 					=> $kappa,
		_branchResultCollection => $branchResultCollection,
		_maxOmega 				=> $stats->getMaximum,
		_minOmega 				=> $stats->getMinimum,
		_meanOmega 				=> $stats->getArithmeticMean,
		_unlabelledTree 		=> $unlabelledTree,
		_labelledTree 			=> $labelledTree,
		_treeLength				=> $treeLength,
		_dNTreeLength			=> $dNTreeLength,
		_dSTreeLength			=> $dSTreeLength
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

sub getId {
	
	my $self = shift;
	
	if (exists $self->{_id}) {
		return $self->{_id};	
		}
	else {
		$self->throw("Id has not been set.");
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasId {
	
	my $self = shift;
	
	if (exists $self->{_id}){return TRUE;} else {return FALSE;}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setId {
	
	my $self 	= shift;
	my $id 		= $self->check(shift);
	
	$self->{_id} = $id;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getUnlabelledTree {
	return shift->{_unlabelledTree};
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLabelledTree {
	return shift->{_labelledTree};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getKappa {
	return shift->{_kappa};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getTreeLength {
	return shift->{_treeLength};
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getdNTreeLength {
	return shift->{_dNTreeLength};
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getdSTreeLength {
	return shift->{_dSTreeLength};
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getBranchResultCollection {
	return shift->{_branchResultCollection};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getMaxOmega {
	return shift->{_maxOmega};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getMinOmega {
	return shift->{_minOmega};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getMeanOmega {
	return shift->{_meanOmega};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLogLikelihood {
	return shift->{_logLikelihood};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub isSuccessful {
	
	my $self = shift;
	
	if (
		defined $self->{_kappa} &&
		defined $self->{_branchResultCollection} &&
		defined $self->{_logLikelihood}
		) {
		return TRUE;
		}
	else {
		return FALSE;
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	my $self = shift;
	
	my $id = "no id";
	if ($self->hasId) {$id = $self->getId};
	my $unlabelledTree 			= $self->getUnlabelledTree->toString;
	my $labelledTree			= $self->getLabelledTree->toString;
	my $kappa 					= $self->getKappa;
	my $branchResultCollection 	= $self->getBranchResultCollection;
	my $maxOmega				= $self->getMaxOmega;
	my $minOmega				= $self->getMinOmega;
	my $omega					= $self->getMeanOmega;
	my $logLikelihood			= $self->getLogLikelihood;
	
	my $text = sprintf(
		"%-15s: %-10s\n" .
		"%-15s: %-10s\n" .
		"%-15s: %-10s\n" .
		"%-15s: %-10s\n" .
		"%-15s: %-10s\n" .
		"%-15s: %-10s\n" .
	#	"%-15s: %-10s\n" .
	#	"%-15s: %-10s\n" .
		"\n",
		"Id", 				$id,
	#	"Unlabelled tree", 	$unlabelledTree,
	#	"Labelled tree", 	$labelledTree,
		"Kappa (k)", 		$kappa,
		"Omega (w)", 		$omega,
		"Min omega", 		$minOmega,
		"Max omega", 		$maxOmega,
		"Log likelihood", 	$logLikelihood
		);
	
	$text .= $branchResultCollection->toString . "\n";
	
	return $text;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

