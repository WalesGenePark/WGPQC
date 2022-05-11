#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 14/02/2008 17:58:15 
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
package Kea::IO::Orthomcl::DefaultReaderHandler2;
use Kea::Object;
use Kea::IO::Orthomcl::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::Orthomcl::IReaderHandler);

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use Kea::Sequence::ClusterFactory;
use Kea::Sequence::ClusterCollection;
use Kea::Sequence::SequenceFactory;
use Kea::Sequence::SequenceCollection;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $clusterCollection =
		Kea::Sequence::ClusterCollection->new(-id => "unknown");
	
	my $self = {
		_clusterCollection => $clusterCollection
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

sub nextLine {

	my (
		$self,
		$clusterNumber,
		$clusterSize,
		$taxaInCluster,
		$proteinIds, # ref to array of protein ids
		$primaryAccessions,	# ref to array of genome ids
		$proteinIdHash # ref to hash with protein id arrays associates with genome id keys.
		) = @_;

	my $sequenceCollection =
		Kea::Sequence::SequenceCollection->new($clusterNumber);
	
	my $sequenceFactory = Kea::Sequence::SequenceFactory->new;
	
	# Create sequence object from each cluster item.
	foreach my $id (@$proteinIds) {
		$sequenceCollection->add(
			$sequenceFactory->createSequence( 
				-id => $id
				)
			);
		}
	
	my $cluster = Kea::Sequence::ClusterFactory->createCluster(
		-id 				=> $clusterNumber,
		-sequenceCollection => $sequenceCollection
		);
	
	$self->{_clusterCollection}->add($cluster);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////


sub getClusterCollection {
	return shift->{_clusterCollection};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

