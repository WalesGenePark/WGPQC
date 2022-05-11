#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 29/02/2008 11:02:48 
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
package Kea::Phylogeny::_PamlBranch;
use Kea::Object;
use Kea::Phylogeny::IBranch;
our @ISA = qw(Kea::Object Kea::Phylogeny::IBranch);

## Purpose		: 

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className 	= shift;
	
	my %args = @_;
	
	my $nodes = Kea::Object->check($args{-nodes});
	
	if (@$nodes != 2) {
		Kea::Object->throw(
			"Wrong number of nodes associated with branch: " .
			@$nodes . "."
			);
		}
	
	my $t 		= Kea::Object->check($args{-t});
	my $N 		= Kea::Object->check($args{-N});
	my $S 		= Kea::Object->check($args{-S});
	my $omega	= Kea::Object->check($args{-omega});
	my $dN		= Kea::Object->check($args{-dN});
	my $dS		= Kea::Object->check($args{-dS});
	my $SxdS	= Kea::Object->check($args{-SxdS});
	my $NxdN	= Kea::Object->check($args{-NxdN});
	
	my $self = {
	
		_isRootBranch	=> FALSE,
		_leadingNode 	=> undef,
		
		_nodes 			=> $nodes,
		_t 				=> $t,
		_N				=> $N,
		_S				=> $S,
		_omega			=> $omega,
		_dN				=> $dN,
		_dS				=> $dS,
		_SxdS			=> $SxdS,
		_NxdN			=> $NxdN
		
		};
	
	bless(
		$self,
		$className
		);
	
	
	foreach my $node (@$nodes) {
		# Further check.
		Kea::Object->check($node, "Kea::Phylogeny::INode");
		# And register branch with node.
		$node->addBranch($self);
		}
	
	return $self;
	
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $privateMethod = sub {
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub getNodes {
	return shift->{_nodes};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasNode {
	
	my $self = shift;
	my $query = $self->check(shift, "Kea::Phylogeny::INode");
	
	my $nodes = $self->getNodes;
	
	foreach my $node (@$nodes) {
		if ($query->equals($node)) {
			return TRUE;
			}
		}
	
	return FALSE;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setLeadingNode {
	
	my $self = shift;
	my $node = $self->check(shift, "Kea::Phylogeny::INode");
	
	if (!$self->hasNode($node)) {
		$self->throw(
			"Node '" . $node->getId .
			"' not associated with branch '" .
			$self->getBranchString . "'"
			)
		}
	
	if ($self->isRootBranch) {
		$self->throw(
			"Branch '" . $self->getBranchString . 
			"' is root branch; cannot set '" . $node->getId . 
			"' as leading node."
			);
		}
	
	$self->{_leadingNode} = $node;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLeadingNode {
	
	my $self = shift;
	
	if (!$self->hasLeadingNode) {
		$self->throw(
			"Branch '" . $self->getBranchString .
			"' doesn't have a leading node."
			);
		}
	
	return $self->{_leadingNode};
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasLeadingNode {
	
	my $self = shift;
	
	if (defined $self->{_leadingNode}) {
		return TRUE;
		}
	else {
		return FALSE;
		}
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub isLeadingNode	{
	
	my $self 	= shift;
	my $query 	= $self->check(shift, "Kea::Phylogeny::INode");
	
	my $node = $self->getLeadingNode;
	
	if ($query.equals($node)) {return TRUE;}
	else {return FALSE;}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setRootBranch	{
	
	my $self = shift;
	my $bool = $self->checkIsBoolean(shift);
	
	$self->{_isRootBranch} = $bool;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub isRootBranch	{
	return shift->{_isRootBranch};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getBranchString {

	my $self 	= shift;
	my $nodes 	= $self->getNodes;
	
	return $nodes->[0]->getId . ".." . $nodes->[1]->getId;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getOmega {
	return shift->{_omega};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub gett {
	return shift->{_t};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getS {
	return shift->{_S};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getN {
	return shift->{_N};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getdN {
	return shift->{_dN};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getdS {
	return shift->{_dS};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSxdS {
	return shift->{_SxdS};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getNxdN {
	return shift->{_NxdN};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub equals {
	
	my $self 	= shift;
	my $query 	= $self->check(shift, "Kea::Phylogeny::IBranch");
	
	if (
		$self->getBranchString 	eq $query->getBranchString 	&&
		$self->getOmega			eq $query->getOmega 		&&
		$self->gett				eq $query->gett				&&
		$self->getS				eq $query->getS				&&
		$self->getN				eq $query->getN				&&
		$self->getdN			eq $query->getdN			&&
		$self->getdS			eq $query->getdS			&&
		$self->getSxdS			eq $query->getSxdS			&&
		$self->getNxdN			eq $query->getNxdN
		) {
		return TRUE;
		}
	
	return FALSE;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {

	my $self = shift;
	
	my $branch 	= $self->getBranchString;
	my $omega 	= $self->getOmega;
	my $t 		= $self->gett;
	my $S 		= $self->getS;
	my $N 		= $self->getN;
	my $dN		= $self->getdN;
	my $dS 		= $self->getdS;
	my $SxdS 	= $self->getSxdS;
	my $NxdN 	= $self->getNxdN;
	
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

