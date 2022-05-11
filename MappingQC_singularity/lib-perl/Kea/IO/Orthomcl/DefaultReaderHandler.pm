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
package Kea::IO::Orthomcl::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::Orthomcl::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::Orthomcl::IReaderHandler);

use strict;
use warnings;

use constant TRUE => 1;
use constant FALSE => 0;

use Kea::OrthologFinder::Orthomcl::Cluster;
use Kea::OrthologFinder::Orthomcl::ClusterCollection;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	my $className = shift;
	
	Kea::Object->throw("DEPRECATED - use DefaultReaderHandler2.");
	
	my $self = {
		_clusters => []
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
	
	push(
		@{$self->{_clusters}},
		Kea::OrthologFinder::Orthomcl::Cluster->new(
			-id => $clusterNumber,
			-numberOfProteins => $clusterSize,
			-numberOfGenomes => $taxaInCluster,
			-proteinIds => $proteinIds,
			-primaryAccessions => $primaryAccessions,
			-proteinIdHash => $proteinIdHash
			)
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getClusters {
	return @{shift->{_clusters}};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getClusterCollection {
	my $clusters = shift->{_clusters};
	return Kea::OrthologFinder::Orthomcl::ClusterCollection->new($clusters);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

