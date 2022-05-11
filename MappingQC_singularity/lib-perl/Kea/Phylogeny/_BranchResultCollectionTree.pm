#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 28/02/2008 16:07:47 
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
package Kea::Phylogeny::_BranchResultCollectionTree;
use Kea::Object;
use Kea::Phylogeny::ITree;
our @ISA = qw(Kea::Object Kea::Phylogeny::ITree);

## Purpose		: 

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use Kea::Phylogeny::NodeFactory;
use Kea::Phylogeny::BranchFactory;

################################################################################

# CLASS FIELDS

################################################################################

#ÊPRIVATE CLASS METHODS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	my $overallId = Kea::Object->check(shift);	
	my $branches = Kea::Object->check(shift);	
	
	my $self = {
		_branches => $branches,
		_overallId => $overallId
		};
	
	bless(
		$self,
		$className
		);
	
	return $self;
	
	} # End of constructor.

################################################################################

# PUBLIC METHODS

sub getOverallId {
	return shift->{_overallId};
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub setOverallId {
	
	my $self = shift;
	my $overallId = $self->check(shift);
	
	# Comment out if too fussy.
	if (exists $self->{_overallId}) {
		$self->warn(
			"Changing tree id from " . $self->{_overallId} . " to $overallId."
			)
		}
	
	$self->{_overallId} = $overallId;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getBranches {
	return shift->{_branches};
	} # End of method.

# TODO - TEMP MEASURE <============================================================================
my $_longestBranch;

#///////////////////////////////////////////////////////////////////////////////

sub getLongestBranch {
	
	my $self = shift;
	
	my $branches = $self->getBranches;
	
	my $longestBranch = $branches->[0];
	foreach my $branch (@$branches) {
		if ($branch->gett > $longestBranch->gett) {
			$longestBranch = $branch;
			}
		}
	
	# TODO - TEMP MEASURE <=========================================================================
	$_longestBranch = $longestBranch;
	
	return $longestBranch;
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self = shift;
	my $longestBranch = $self->getLongestBranch;
	
	my $nodes = $longestBranch->getNodes;
	
	my $node1 = $nodes->[0];
	my $node2 = $nodes->[1];
	
	my $string = "(";
	
	if ($node1->isLeaf) {
		my $branch = $node1->getBranches->[0];
		$string .= $self->nodeText($node1, $branch) . ",";						# Convert node to text here
		}
	else {
		my $children = $node1->getChildren;
		my $nodes = $self->getRelevantNodes($children, $node2);
		$string .= $self->nodesToString($node1, $nodes->[0], $nodes->[1]) . ", ";
		}
	
	# NOTE: ONLY DIFFERENCE WITH nodesToString IS LACK OF PARENT NODE LABELLING.
	if ($node2->isLeaf) {
		my $branch = $node2->getBranches->[0];
		$string .= $self->nodeText($node2, $branch) . ")";						# Convert node to text here
		}
	else {
		my $children = $node2->getChildren;
		my $nodes = $self->getRelevantNodes($children, $node1);
		$string .= $self->nodesToString($node2, $nodes->[0], $nodes->[1]) . ")";
		}
	
	$string .= ";";
	
	return $string;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub nodeText {
	
	my $self 	= shift;
	my $node 	= $self->check(shift, "Kea::Phylogeny::INode");
	my $branch 	= $self->check(shift, "Kea::Phylogeny::IBranch");
	
	my $t = $branch->gett;
	
	# TODO TEMP MEASURE <==============================================================================
	if ($branch->equals($_longestBranch)) {
		$t = $t/2;
		}
	
	return $node->getId . ":" . $t; # . " [" . $branch->getOmega . "]";
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub nodesToString {
	
	my $self 	= shift;
	my $node0 	= $self->check(shift, "Kea::Phylogeny::INode"); # Parent
	my $node1 	= $self->check(shift, "Kea::Phylogeny::INode"); # child1
	my $node2	= $self->check(shift, "Kea::Phylogeny::INode"); # child2
	
	my $branches = $node0->getBranches;
	my $parentBranch = $self->getCorrectBranch($node1, $node2, $branches);
	
	my $string = "(";
	
	if ($node1->isLeaf) {
		my $branch = $node1->getBranches->[0];
		$string .= $self->nodeText($node1, $branch) . ",";						# Convert node to text here
		}
	else {
		my $children = $node1->getChildren;
		my $nodes = $self->getRelevantNodes($children, $node0);
		$string .= $self->nodesToString($node1, $nodes->[0], $nodes->[1]) . ", "; # Recursive function.
		}
	
	if ($node2->isLeaf) {
		my $branch = $node2->getBranches->[0];
		$string .= $self->nodeText($node2, $branch) . ")" . $self->nodeText($node0, $parentBranch);		# Convert node to text here
		}
	else {
		my $children = $node2->getChildren;
		my $nodes = $self->getRelevantNodes($children, $node0);
		$string .= $self->nodesToString($node2, $nodes->[0], $nodes->[1]) . ")" . $self->nodeText($node0, $parentBranch); # Recursive function.
		}
	
	return $string;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getCorrectBranch {
	
	my $self 		= shift;
	my $node1 		= $self->check(shift, "Kea::Phylogeny::INode");
	my $node2 		= $self->check(shift, "Kea::Phylogeny::INode");
	my $branches 	= $self->check(shift);
	
	foreach my $branch (@$branches) {
		if (!$branch->hasNode($node1) && !$branch->hasNode($node2)) {
			return $branch;
			}
		}
	
	$self->throw("No suitable branch could be found.");
	
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub getRelevantNodes {
	
	my $self = shift;
	my $nodes = shift;
	my $exclude = shift;
	
	my @filteredNodes;
	foreach my $node (@$nodes) {
		if ($node->equals($exclude)) {next};
		push(@filteredNodes, $node);
		}
	
	# Just in case...	 
	$self->throw("Too many nodes: " . @filteredNodes . " (was expecting 2).")
		if @filteredNodes != 2; 
	
	return \@filteredNodes;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

