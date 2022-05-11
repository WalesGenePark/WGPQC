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
package Kea::OrthologFinder::_OrthomclOutfileProcessor;

## Purpose		: 

use strict;
use warnings;
use Cwd "abs_path";
use Carp;
use File::Copy;


use constant TRUE => 1;
use constant FALSE => 0;

use constant SENSE => "sense";
use constant ANTISENSE => "antisense";

use constant FASTA => "fasta";
use constant EMBL => "embl";
use constant UNKNOWN => "unknown";

use Kea::Sequence::SequenceCollection;
use Kea::Sequence::SequenceFactory;
use Kea::IO::Fasta::WriterFactory;
use Kea::IO::Orthomcl::ReaderFactory;
use Kea::IO::Orthomcl::DefaultReaderHandler;
use Kea::OrthologFinder::Orthomcl::ClusterCollection;
use Kea::IO::Feature::FeatureCollection;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

## Purpose		: Constructor.
## Parameter	: n/a.
## Throws		: n/a.
sub new {
	my $className = shift;
	my %args = @_;
	
	my $clusterfile = $args{-clusterfile};
	my $recordCollection = $args{-records};
	
	# Create Clusters.
	#===========================================================================
	my $rf = Kea::IO::Orthomcl::ReaderFactory->new;
	my $reader = $rf->createReader;
	my $handler = Kea::IO::Orthomcl::DefaultReaderHandler->new;
	
	open(IN, $clusterfile)
		or confess "\nERROR: Could not open $clusterfile";
		
	$reader->read(*IN, $handler);
	close(IN);
	#===========================================================================
	
	my $self = {
		_handler => $handler,
		_recordCollection => $recordCollection
		};
	bless(
		$self,
		$className
		);
	
	return $self;
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

################################################################################

# PUBLIC METHODS

sub getClusterCollection  {
	my $self = shift;
	return $self->{_handler}->getClusterCollection;
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub getClusters  {
	my $self = shift;
	return $self->{_handler}->getClusters;
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub getClustersAsFeatureCollections {
	my $self = shift;
	
	my @clusters = $self->getClusters;
	my $recordCollection = $self->{_recordCollection};
	
	my @featureCollections;
	foreach my $cluster (@clusters) {
	
		my $clusterId = $cluster->getId;
		
		my $featureCollection = Kea::IO::Feature::FeatureCollection->new(
			$clusterId
			);
		my %hash = $cluster->getProteinIdHash;
		foreach my $primaryAccession (keys %hash) {
			my $record = $recordCollection->getRecordWithPrimaryAccession($primaryAccession);
			my $proteinIds = $hash{$primaryAccession};
			foreach my $proteinId (@$proteinIds) {
				$featureCollection->add(
					$record->getCDSFeatureWithProteinId($proteinId)
					);
				} # End of foreach - no more protein ids.
			} # End of foreach - No more primary accessions. 
			
		push(@featureCollections, $featureCollection);
			
		} # End of foreach - no more clusters.
	
	return @featureCollections;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;