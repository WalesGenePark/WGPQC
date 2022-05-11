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
package Kea::Phylogeny::TreeFactory;
use Kea::Object;
our @ISA = qw(Kea::Object);

## Purpose		: 

use strict;
use warnings;

use constant TRUE	=> 1;
use constant FALSE	=> 0;

use Kea::Phylogeny::_BranchResultCollectionTree;
use Kea::Phylogeny::_SimpleTree;

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

my $getBranches = sub {

	my $self = shift;

	my $branchResultCollection =
		Kea::Object->check(shift, "Kea::Phylogeny::Paml::BranchResultCollection");
				
	my @branches;
	my %nodeHash;	
	my $nodeFactory = Kea::Phylogeny::NodeFactory->new;
	my $branchFactory = Kea::Phylogeny::BranchFactory->new;
		
	for (my $i = 0; $i < $branchResultCollection->getSize; $i++) {
		my $branchResult = $branchResultCollection->get($i);
		my $branchString = $branchResult->getBranchString;
		
		# Process branch string
		#=======================================================================
		
		if ($branchString =~ /^(.+)\.\.(.+)$/) {
			my @nodeLabels = ($1, $2);
			
			# Create node objects, if not already existing.
			foreach my $nodeLabel (@nodeLabels) {
				if (!exists $nodeHash{$nodeLabel}) {
					$nodeHash{$nodeLabel} = $nodeFactory->createNode($nodeLabel);
					}
				}
			
			
			
			my $branch =
				$branchFactory->createBranch(
					$nodeHash{$nodeLabels[0]},
					$nodeHash{$nodeLabels[1]},
					$branchResult
					);
			
			push(@branches, $branch);
			
			}
		else {
			Kea::Object->throw(
				"Branch string could not be matched with regex: $branchString."
				);
			}
		
		#=======================================================================
		
		} # End of for loop - no more branch results.
		
	return \@branches;
	
	
	}; # End of method.


################################################################################

# PUBLIC METHODS

sub createTree {

	my $self = shift;
	my $arg = $self->check(shift);
	
	if (ref($arg) eq "Kea::Phylogeny::Paml::BranchResultCollection") {
		return Kea::Phylogeny::_BranchResultCollectionTree->new(
			$arg->getOverallId,
			$self->$getBranches($arg)
			);
		}
	# Backwards compatibility - assume arg is a newick string and pass to _SimpleTree
	else {
		return Kea::Phylogeny::_SimpleTree->new($arg);
		}
	

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////



################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

