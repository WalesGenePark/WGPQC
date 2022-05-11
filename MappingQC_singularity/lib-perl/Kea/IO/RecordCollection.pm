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
package Kea::IO::RecordCollection;
use Kea::Object;
use Kea::ICollection;
our @ISA = qw(Kea::Object Kea::ICollection);

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use Kea::IO::Feature::FeatureCollection;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	my $className = shift;
	my $self = {
		_array => []
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

sub hasRecordWithPrimaryAccession {
	
	my $self = shift;
	my $primaryAccession = $self->check(shift);
	
	foreach my $record (@{$self->{_array}}) {
		if ($record->getPrimaryAccession eq $primaryAccession) {
			return TRUE;
			}
		}
	
	return FALSE;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getRecordWithPrimaryAccession {
	
	my $self = shift;
	my $primaryAccession = $self->check(shift);
	
	my $records = $self->{_array};
	foreach my $record (@$records) {
		if ($record->getPrimaryAccession eq $primaryAccession) {
			return $record;
			}
		}
	
	my @buffer = $self->getPrimaryAccessions;
	
	foreach (@buffer) {
		print "[$_]\n";
		}
	
	
	$self->throw(
		"Cannot find record with primary accession '" .
		$primaryAccession . "'"
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getPrimaryAccessions {
	
	my $self = shift;
	
	my @records = @{$self->{_array}};
	
	my @accessions;
	foreach my $record (@records) {
		push(
			@accessions,
			$record->getPrimaryAccession
			);
		}
	
	return @accessions;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSize {
	return scalar(@{shift->{_array}});
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub get {
	
	my $self = shift;
	my $i = $self->checkIsInt(shift);
	
	return $self->{_array}->[$i];
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAll {
	return @{shift->{_array}};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub add {

	my $self = shift;
	my $record = $self->check(shift, "Kea::IO::IRecord");
	
	push(@{$self->{_array}}, $record);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# Returns hashmap with key as record primary accession, with array of
# protein_ids as value. 
sub getHashOfProteinIdsByPrimaryAccession {
	
	my $self = shift;
	
	my %hash;
	foreach my $record (@{$self->{_array}}) {
	
		my $primaryAccession = $record->getPrimaryAccession;
		my @proteinIds = $record->getProteinIdList;
	
		$hash{$primaryAccession} = \@proteinIds;
		}
	
	
	return %hash;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# Returns hash with protein_id as key and primary accession as value. 
sub getHashOfPrimaryAccessionsByProteinId {
	
	my $self = shift;
	
	my %proteinIds = $self->getHashOfProteinIdsByPrimaryAccession;
	
	my %primaryAccessions;
	
	# Keep track of total number of protein ids in collection.
	my $n = 0;
	
	foreach my $primaryAccession (keys %proteinIds) {
		my @proteinIds = @{$proteinIds{$primaryAccession}};
		
		$n += @proteinIds;
		
		foreach my $proteinId (@proteinIds) {
			
			if (exists $primaryAccessions{$proteinId}) {
				
				my $old = $primaryAccessions{$proteinId};
				my $new = $primaryAccession;
				
				$self->throw("$proteinId from $new already associated with $old.\n");	
					
				}
			
			
			$primaryAccessions{$proteinId} = $primaryAccession;
			
			}
		
		}
	
	return %primaryAccessions;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# Returns arrays of feature collections corresponding to clusters in cluster
# collection.


sub getFeatureCollections {
	
	my $self = shift;
	my $clusterCollection = $self->check(shift, "Kea::Sequence::ClusterCollection");
	
	if ($clusterCollection->getSize == 0) {
		$self->warn("Empty cluster collection.");
		}
	
	my %hash = $self->getHashOfPrimaryAccessionsByProteinId;
	
	my @featureCollections;
	for (my $i = 0; $i < $clusterCollection->getSize; $i++) { # Collection of clusters
				
		my $cluster = $clusterCollection->get($i);
				
		my $sequenceCollection = $cluster->getSequenceCollection;
		
		my $featureCollection =
			Kea::IO::Feature::FeatureCollection->new($sequenceCollection->getOverallId);
		
		for (my $j = 0; $j < $sequenceCollection->getSize; $j++) { # Work through single cluster.
			
			my $sequence = $sequenceCollection->get($j);
			
			my $record =
				$self->getRecordWithPrimaryAccession(
					$hash{$sequence->getID}
					);
			
			my $feature = $record->getCDSFeatureWithProteinId($sequence->getID);
			
			$featureCollection->add($feature);
			
			
			} #ÊEnd of for - Finished processing single cluster.
		
		push(@featureCollections, $featureCollection);
		
		} # End of for - no more clusters to process.
	
	return @featureCollections;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	my $self = shift;
	
	my $text = "";
	
	my @array = @{$self->{_array}};
	foreach (@array) {
		$text .= $_->toString . "\n";
		}
	
	return $text;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

