#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 21/04/2008 15:17:29
#    Copyright (C) 2008, University of Liverpool.
#    Author: Kevin Ashelford.
#
#    Contact details:
#    Email:   k.ashelford@liv.ac.uk
#    Address: School of Biological Sciences, University of Liverpool, 
#             Biosciences Building, Crown Street, Liverpool, UK. L69 7ZB
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
package Kea::IO::Gff::_GffRecord;
use Kea::Object;
use Kea::IO::Gff::IGffRecord;
our @ISA = qw(Kea::Object Kea::IO::Gff::IGffRecord);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::IO::Gff::GffFeatureCollection;
use Kea::IO::Gff::GffFeatureFactory;
use Kea::IO::Feature::FeatureCollection;
use Kea::IO::Feature::FeatureFactory;
use Kea::Sequence::SequenceCollection;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my %args = @_;
	
	my $featureCollection = Kea::IO::Gff::GffFeatureCollection->new("");
	
	my $translationSequenceCollection =
		Kea::Sequence::SequenceCollection->new("");
	
	my $self = {
		_primaryAccession 				=> $args{-primaryAccession},
		_gffFeatureCollection 			=> $featureCollection,
		_translationSequenceCollection	=> $translationSequenceCollection
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

sub getPrimaryAccession {
	return shift->{_primaryAccession};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setFeatureOntologyURI {
	
	my $self = shift;
	my $featureOntologyURI = $self->check(shift);
	
	$self->{_featureOntologyURI} = $featureOntologyURI;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getFeatureOntologyURI {
	return shift->{_featureOntologyURI};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setAttributeOntologyURI {
	
	my $self = shift;
	my $attributeOntologyURI = $self->check(shift);
	
	$self->{_attributeOntologyURI} = $attributeOntologyURI;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAttributeOntologyURI {
	return shift->{_attributeOntologyURI};
	} # End of method.


#///////////////////////////////////////////////////////////////////////////////

sub getGffFeatureCollection {
	return shift->{_gffFeatureCollection};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSource {
	return shift->{_source};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setSource {
	
	my $self = shift;
	my $source = $self->check(shift);
	
	$self->{_source} = $source;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getFeature {
	return shift->{_feature};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setFeature {
	
	my $self = shift;
	my $feature = $self->check(shift);
	
	$self->{_feature} = $feature;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLocation {
	return shift->{_location};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setLocation {
	
	my $self = shift;
	my $location = $self->check(shift, "Kea::IO::Location");
	
	$self->{_location} = $location;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getScore {
	return shift->{_score};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setScore {
	
	my $self = shift;
	my $score = $self->check(shift);
	
	$self->{_score} = $score;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getOrientation {
	return shift->{_orientation};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setOrientation {
	
	my $self = shift;
	my $orientation = $self->checkIsOrientation(shift);
	
	$self->{_orientation} = $orientation;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getFrame {
	return shift->{_frame};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setFrame {
	
	my $self = shift;
	my $frame = $self->check(shift);
	
	$self->{_frame} = $frame;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAttributes {
	return shift->{_attributes};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setAttributes {
	
	my $self = shift;
	my $attributes = $self->check(shift, "Kea::IAttributes");
	
	$self->{_attributes} = $attributes;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSequence {
	return shift->{_sequence};
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub setSequence {
	
	my $self = shift;
	my $sequence = $self->check(shift);
	
	$self->{_sequence} = $sequence;
	
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasSequence {
	
	if (defined shift->{_sequence}) {
		return TRUE;
		}
	else {
		return FALSE;
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getTranslationSequenceCollection {
	return shift->{_translationSequenceCollection};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasTranslations {
	
	if (shift->{_translationSequenceCollection}->getSize > 1) {
		return TRUE;
		}
	else {
		return FALSE;
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getCDSFeatureCollection {
	
	my $self = shift;
	
	my $recordAttributes = $self->getAttributes;
	my $translTable;
	if ($recordAttributes->has("translation_table")) {
		$translTable = $recordAttributes->get("translation_table");
		}
	else {
		$self->throw(
			"No translation_table value for gff-record" .
			$self->getPrimaryAccession
			);
		}
	
	my %translations;
	my $sequenceCollection = $self->getTranslationSequenceCollection;
	for (my $i = 0; $i < $sequenceCollection->getSize; $i++) {
		my $sequence = $sequenceCollection->get($i);
		$translations{$sequence->getID} = $sequence->getSequence;
		}
	
	# group cds gff-features according to id.
	my $gffFeatureCollection = $self->getGffFeatureCollection;
	my %hash;
	for (my $i = 0; $i < $gffFeatureCollection->getSize; $i++) {
		my $gffFeature = $gffFeatureCollection->get($i);
		next if $gffFeature->getFeature ne "CDS";
		push(
			@{$hash{$gffFeature->getId}},
			$gffFeature
			);
		}
	
	# Next create feature objects from clustered gff-features.
	my @features;
	foreach my $id (keys %hash) {
		my $gffFeatures = $hash{$id};
		
		my $orientation = $gffFeatures->[0]->getOrientation;
		my $translation = $translations{$gffFeatures->[0]->getId};
		
		my @locations;
		
		foreach my $gffFeature (@$gffFeatures) {
			push(@locations, $gffFeature->getLocation);
			if ($orientation ne $gffFeature->getOrientation) {
				$self->throw("Inconsistent orientation.");
				}
			}
		my @sortedLocations = sort {$a->getStart <=> $b->getStart} @locations;
		
		push(
			@features,
			Kea::IO::Feature::FeatureFactory->createCDS(
				-parent 		=> undef,
				-gene 			=> $id,
				-proteinId 		=> $id,
				-locusTag 		=> $id,
				-locations 		=> \@sortedLocations,
				-translation 	=> $translation,
				-note 			=> undef,
				-codonStart 	=> undef,
				-translTable 	=> $translTable,
				-orientation 	=> $orientation,
				-pseudo 		=> undef,
				-colour 		=> undef,
				-product 		=> undef
				)
			);
		}
	
	# Sort feature objects according to location.
	my @sortedFeatures =
		sort {
			$a->getFirstLocation->getStart <=>
			$b->getFirstLocation->getStart
			} @features;
	
	# Store in collection.
	my $featureCollection = Kea::IO::Feature::FeatureCollection->new("");
	foreach my $feature (@sortedFeatures) {
		$featureCollection->add($feature);
		}
	
	# Return.
	return $featureCollection;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $processmRNAFeature = sub {
	
	my $self 			= shift;
	# list of gff-features relating to the same gene feature.
	my $gffFeatures 	= $self->checkIsArrayRef(shift);
		
	# Get id.
	my $id = $gffFeatures->[0]->getId or
		$self->throw("No feature id.");	
		
	# Get orientation.
	my $orientation = $gffFeatures->[0]->getOrientation or
		$self->throw("No orientation: $id.");
	
	# Get sorted locations.
	my @locations;
	foreach my $gffFeature (@$gffFeatures) {
		push(@locations, $gffFeature->getLocation);
		if ($orientation ne $gffFeature->getOrientation) {
			$self->throw("Inconsistent orientation.");
			}
		}
	my @sortedLocations = sort {$a->getStart <=> $b->getStart} @locations;
	
	
	return
		Kea::IO::Feature::FeatureFactory->createmRNA(
		
			-parent 		=> undef,
			-gene 			=> $id,
			-locusTag 		=> $id,
			-locations 		=> \@sortedLocations,
			-note 			=> undef,
			-orientation 	=> $orientation,
			-colour 		=> undef
		
			);
	
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $processtRNAFeature = sub {
	
	my $self 			= shift;
	# list of gff-features relating to the same gene feature.
	my $gffFeatures 	= $self->checkIsArrayRef(shift);
		
	# Get id.
	my $id = $gffFeatures->[0]->getId or
		$self->throw("No feature id.");	
		
	# Get orientation.
	my $orientation = $gffFeatures->[0]->getOrientation or
		$self->throw("No orientation: $id.");
	
	# Get sorted locations.
	my @locations;
	foreach my $gffFeature (@$gffFeatures) {
		push(@locations, $gffFeature->getLocation);
		if ($orientation ne $gffFeature->getOrientation) {
			$self->throw("Inconsistent orientation.");
			}
		}
	my @sortedLocations = sort {$a->getStart <=> $b->getStart} @locations;
	
	
	return
		Kea::IO::Feature::FeatureFactory->createtRNA(
		
			-parent 		=> undef,
			-gene 			=> $id,
			-locusTag 		=> $id,
			-locations 		=> \@sortedLocations,
			-note 			=> undef,
			-orientation 	=> $orientation,
			-colour 		=> undef
		
			);
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $processGeneFeature = sub {
	
	my $self 			= shift;
	# list of gff-features relating to the same gene feature.
	my $gffFeatures 	= $self->checkIsArrayRef(shift);
		
	# Get id.
	my $id = $gffFeatures->[0]->getId or
		$self->throw("No feature id.");	
		
	# Get orientation.
	my $orientation = $gffFeatures->[0]->getOrientation or
		$self->throw("No orientation: $id.");
	
	# Get sorted locations.
	my @locations;
	foreach my $gffFeature (@$gffFeatures) {
		push(@locations, $gffFeature->getLocation);
		if ($orientation ne $gffFeature->getOrientation) {
			$self->throw("Inconsistent orientation.");
			}
		}
	my @sortedLocations = sort {$a->getStart <=> $b->getStart} @locations;
	
	# Construct notes.
	my $note = "";
	
	return
		Kea::IO::Feature::FeatureFactory->createGene(
		
			-parent 		=> undef,
			-gene 			=> $id,
			-locusTag 		=> $id,
			-locations 		=> \@sortedLocations,
			-note 			=> $note,
			-orientation 	=> $orientation,
			-colour 		=> undef
		
			);
	
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $processExonFeature = sub {
	
	my $self 			= shift;
	# list of gff-features relating to the same gene feature.
	my $gffFeatures 	= $self->checkIsArrayRef(shift);
		
	# Get id.
	my $id = $gffFeatures->[0]->getId or
		$self->throw("No feature id.");	
		
	# Get orientation.
	my $orientation = $gffFeatures->[0]->getOrientation or
		$self->throw("No orientation: $id.");
	
	# Get sorted locations.
	my @locations;
	foreach my $gffFeature (@$gffFeatures) {
		push(@locations, $gffFeature->getLocation);
		if ($orientation ne $gffFeature->getOrientation) {
			$self->throw("Inconsistent orientation.");
			}
		}
	my @sortedLocations = sort {$a->getStart <=> $b->getStart} @locations;
	
	
	return
		Kea::IO::Feature::FeatureFactory->createExon(
		
			-parent 		=> undef,
			-gene 			=> $id,
			-locusTag 		=> $id,
			-locations 		=> \@sortedLocations,
			-note 			=> undef,
			-orientation 	=> $orientation,
			-colour 		=> undef
		
			);
	
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $processCDSFeature = sub {
	
	my $self 			= shift;
	# list of gff-features relating to the same cds feature.
	my $gffFeatures 	= $self->checkIsArrayRef(shift);
	my $translations 	= shift;
	
	
	# Get transltable.
	my $translTable = $self->getAttributes->get("translation_table") or 
		$self->throw("No translation_table: " . $self->getPrimaryAccession . ".");
		
	# Get id.
	my $id = $gffFeatures->[0]->getId or
		$self->throw("No feature id.");	
		
	# Get orientation.
	my $orientation = $gffFeatures->[0]->getOrientation or
		$self->throw("No orientation: $id.");
	
	# Get translation.
	my $translation = $translations->{$gffFeatures->[0]->getId} or
		$self->throw("No translation: $id.");
	
	# Get sorted locations.
	my @locations;
	foreach my $gffFeature (@$gffFeatures) {
		push(@locations, $gffFeature->getLocation);
		if ($orientation ne $gffFeature->getOrientation) {
			$self->throw("Inconsistent orientation.");
			}
		}
	my @sortedLocations = sort {$a->getStart <=> $b->getStart} @locations;
	
	# Construct notes.
	my $note = ""; #join("; ", @{$gffFeatures->[0]->getAttributes->toArray});
	
	# Record Attributes
	#	ID=apidb|VIIb;
	#	Name=VIIb;
	#	description=VIIb;
	#	size=5023822;
	#	web_id=VIIb;
	#	molecule_type=dsDNA;
	#	organism_name=Toxoplasma gondii;
	#	translation_table=11;
	#	topology=linear;
	#	localization=nuclear;
	#	Dbxref=ApiDB_ToxoDB:VIIb,taxon:5811
	
	# CDS feature Attributes
	#	ID=apidb|cds_645.m00686-1;
	# 	Name=cds;
	#	Parent=apidb|rna_645.m00686-1;
	# 	description=.;
	#	size=723  <=========== UNRELIABLE??!
	
	return
		Kea::IO::Feature::FeatureFactory->createCDS(
			-parent 		=> undef,
			-gene 			=> $id,
			-proteinId 		=> $id,
			-locusTag 		=> $id,
			-locations 		=> \@sortedLocations,
			-translation 	=> $translation,
			-note 			=> $note,
			-codonStart 	=> undef,
			-translTable 	=> $translTable,
			-orientation 	=> $orientation,
			-pseudo 		=> undef,
			-colour 		=> undef,
			-product 		=> undef
			);
	
	}; # End of method.
	
#///////////////////////////////////////////////////////////////////////////////

sub getFeatureCollection {
	
	my $self = shift;
	
	#ÊGet gff feature collection to convert.
	my $gffFeatureCollection = $self->{_gffFeatureCollection};
	
	#ÊGroup gff-features according to shared id.
	my %featureHash;
	for (my $i = 0; $i < $gffFeatureCollection->getSize; $i++) {
		
		my $gffFeature 	= $gffFeatureCollection->get($i);
		my $type 		= $gffFeature->getFeature;
		my $id 			= $gffFeature->getId;
	
		# Ignore numerical suffix (important when processing exons).
		$id =~ s/-\d+$//;
	
		# Store gff-feature against id.
		push(@{$featureHash{$id}->{$type}}, $gffFeature);
		
		}
	
	
	# Get translations (necessary for cds features).
	my %translations;
	my $sequenceCollection = $self->getTranslationSequenceCollection;
	for (my $i = 0; $i < $sequenceCollection->getSize; $i++) {
		my $sequence = $sequenceCollection->get($i);
		$translations{$sequence->getID} = $sequence->getSequence;
		}
	
	
	# create separate feature each id.
	my @features;
	foreach my $id (keys %featureHash) {
		my $typeHash = $featureHash{$id};
		
		foreach my $type (%$typeHash) {
			my $gffFeatures = $typeHash->{$type};
			
			# Known feature types:
			# 	CDS
			# 	exon
			# 	gene
			# 	mRNA
			# 	tRNA
			# 	supercontig
			if ($type eq "CDS") {
				push(
					@features,
					$self->$processCDSFeature($gffFeatures, \%translations)
					);
				}
			
			elsif ($type eq "mRNA") {
				push(
					@features,
					$self->$processmRNAFeature($gffFeatures)
					);
				}
			
			elsif ($type eq "tRNA") {
				push(
					@features,
					$self->$processtRNAFeature($gffFeatures)
					);
				}
			
			elsif ($type eq "gene") {
				push(
					@features,
					$self->$processGeneFeature($gffFeatures)
					);
				}
			
			elsif ($type eq "exon") {
				push(
					@features,
					$self->$processExonFeature($gffFeatures)
					);
				}
			
			}
		
		}
	
	# Sort feature objects according to location.
	my @sortedFeatures =
		sort {
			$a->getFirstLocation->getStart <=>
			$b->getFirstLocation->getStart
			} @features;
	
	# Store in collection.
	my $featureCollection = Kea::IO::Feature::FeatureCollection->new("");
	foreach my $feature (@sortedFeatures) {
		$featureCollection->add($feature);
		}
	
	# Return.
	return $featureCollection;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self = shift;
	
	my $id 			= $self->getPrimaryAccession;
	my $source 		= $self->getSource;
	my $feature 	= $self->getFeature;
	my $location 	= $self->getLocation;
	my $score 		= $self->getScore;
	my $orientation = $self->getOrientation;
	my $frame 		= $self->getFrame;
	my $attributes 	= $self->getAttributes->toString;
	
	my $text = sprintf(
		"%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s",
		$id,
		$source,
		$feature,
		$location->getStart,
		$location->getEnd,
		$score,
		$orientation,
		$frame,
		$attributes
		);
	
	return $text;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

