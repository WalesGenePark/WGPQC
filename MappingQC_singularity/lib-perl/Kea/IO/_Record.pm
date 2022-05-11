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
package Kea::IO::_Record;
use Kea::Object;
use Kea::IO::IRecord;
our @ISA = qw(Kea::Object Kea::IO::IRecord);

use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";

use Kea::IO::Feature::FeatureCollection;
use Kea::Reference::ReferenceCollection;
use Kea::Sequence::CodonFactory;
use Kea::Utilities::DNAUtility;
use Kea::Sequence::SequenceFactory;

use Kea::Properties;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	my $className = shift;
	
	my %args = @_;
	
	# Obligatory variable.
	my $primaryAccession = Kea::Object->check($args{-primaryAccession});
	
	my $referenceCollection = Kea::Reference::ReferenceCollection->new("");
	
	my $self = {
		_primaryAccession 		=> $primaryAccession,
		_accession 				=> $args{-accession},
		_sequence 				=> $args{-sequence},
		_version 				=> $args{-version} 		|| 1,
		_features 				=>  $args{-features}	|| [],
		_referenceCollection	=> $referenceCollection
		};
	
	bless(
		$self,
		$className
		);
	
	foreach my $feature (@{$self->{_features}}) {
		$feature->setParent($self);
		}
	
	return $self;
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

################################################################################

# PUBLIC METHODS

sub setPrimaryAccession {
	my ($self, $accession) = @_;
	$self->{_primaryAccession} = $accession;
	} # End of method.

sub getPrimaryAccession {

	my $self = shift;
	$self->throw("Unused variable.") if (!exists $self->{_primaryAccession});
	return $self->{_primaryAccession};
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAccessionNumericalSuffix {
	
	my $self = shift;
	my $accession = $self->getPrimaryAccession;
	
	if ($accession =~ /(\d+)$/) {
		return $1;
		}
	
	else {
		$self->throw("Accession does not have a numerical suffix.");
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasAccessionNumericalSuffix {
	
	my $self = shift;
	my $accession = $self->getPrimaryAccession;
	
	if ($accession =~ /\d+$/) {
		return TRUE;
		}
	else {
		return FALSE;
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

##ÊPurpose		: Returns version as listed in ID section.
sub getVersion  {

	my $self = shift;
	$self->throw("Unused variable.") if (!exists $self->{_version});
	return $self->{_version};
	
	} # End of method.

sub setVersion {
	my $self = shift;
	my $version = $self->check(shift);
	
	$self->{_version} = $version;
	}

#///////////////////////////////////////////////////////////////////////////////

## Purpose		: Returns topology as listed in ID section.
sub getTopology {
	
	my $self = shift;
	$self->throw("Unused variable.") if (!exists $self->{_topology});
	return $self->{_topology};
	
	} # End of method.

sub setTopology {
	
	my $self 		= shift;
	my $topology 	= $self->check(shift);
	
	$self->{_topology} = $topology;
	}


sub hasTopology {

	my $self = shift;
	
	if (defined $self->{_topology}) {
		return TRUE;
		}
	else {
		return FALSE;
		}

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose		: Returns taxonomic division as listed in ID section.
sub getTaxonomicDivision {
	
	my $self = shift;
	$self->throw("Unused variable.") if (!exists $self->{_taxonomicDivision});
	return $self->{_taxonomicDivision};
	
	} # End of method.

sub setTaxonomicDivision {
	
	my $self = shift;
	my $taxonomicDivision = $self->check(shift);
	
	$self->{_taxonomicDivision} = $taxonomicDivision;
	} 

sub hasTaxonomicDivision {

	my $self = shift;
	
	if (defined $self->{_taxonomicDivision}) {
		return TRUE;
		}
	else {
		return FALSE;
		}

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub convertToReverseComplement {
	
	my $self = shift;
	
	# 1. Reverse complement sequence.
	my $sequence = $self->getSequence;
	$self->setSequence(
		Kea::Utilities::DNAUtility->getReverseComplement($sequence)
		);
	
	# 2. Foreach feature (not source):
	my $featureCollection = $self->getFeatureCollection;
	my $n = $self->getLength;
	for (my $i = 0; $i < $featureCollection->getSize; $i++) {
		
		my $feature = $featureCollection->get($i);
		
		next if ($feature->getName eq "source");
	
		
		# 2.1. Reverse orientation.
		$feature->reverseOrientation;
		#Ê2.2. Alter locations
		my @locations = $feature->getLocations;
		foreach my $location (@locations) {
			my $start = $location->getStart;
			my $end = $location->getEnd;
			$location->setStart($n - $end + 1);
			$location->setEnd($n - $start + 1);
			}
		}
		
		
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getDescription {
	
	my $self = shift;
	$self->throw("Unused variable.") if (!exists $self->{_description});
	return $self->{_description};
	
	} #ÊEnd of method.

sub setDescription {
	
	my $self 		= shift;
	my $description = $self->check(shift);
	
	$self->{_description} = $description;
	
	} # End of method.

sub hasDescription {

	my $self = shift;
	
	if (defined $self->{_description}) {
		return TRUE;
		}
	else {
		return FALSE;
		}

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# Use description instead.
#sub getDefinition {
#	
#	my $self = shift;
#	$self->throw("Unused variable.") if (!exists $self->{_definition});
#	return $self->{_definition};
#	
#	} #ÊEnd of method.
#
#sub setDefinition {
#	
#	my $self 		= shift;
#	my $definition	= $self->check(shift);
#	
#	$self->{_definition} = $definition;
#	
#	} # End of method.
#
#sub hasDefinition {
#
#	my $self = shift;
#	
#	if (defined $self->{_definition}) {
#		return TRUE;
#		}
#	else {
#		return FALSE;
#		}
#
#	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getKeywords {
	
	my $self = shift;
	$self->throw("Unused variable.") if (!exists $self->{_keywords});
	return @{$self->{_keywords}};
	
	} #ÊEnd of method.

sub setKeywords {
	
	my $self = shift;
	my @keywords = @_;
	
	$self->{_keywords} = \@keywords;
	
	} # End of method.

sub hasKeywords {

	my $self = shift;
	
	if (defined $self->{_keywords}) {
		return TRUE;
		}
	else {
		return FALSE;
		}

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getProjectId {
	
	my $self = shift;
	$self->throw("Unused variable.") if (!exists $self->{_projectId});
	return $self->{_projectId};
	
	} #ÊEnd of method.

sub setProjectId {
	
	my $self = shift;
	my $projectId = $self->check(shift);
	
	$self->{_projectId} = $projectId;
	
	} # End of method.

sub hasProjectId {

	my $self = shift;
	
	if (defined $self->{_projectId}) {
		return TRUE;
		}
	else {
		return FALSE;
		}

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getComment {
	
	my $self = shift;
	$self->throw("Unused variable.") if (!exists $self->{_comment});
	return $self->{_comment};
	
	} #ÊEnd of method.

sub setComment {
	
	my $self = shift;
	my $comment = $self->check(shift);
	
	$self->{_comment} = $comment;
	
	} #ÊEnd of method.

sub hasComment {

	my $self = shift;
	
	if (defined $self->{_comment}) {
		return TRUE;
		}
	else {
		return FALSE;
		}

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSource {
	
	my $self = shift;
	$self->throw("Unused variable.") if (!exists $self->{_source});
	return $self->{_source};
	
	} # End of method.

sub setSource {
	
	my $self = shift;
	my $source = $self->check(shift);
	
	$self->{_source} = $source;
	
	} # End of method.

sub hasSource {

	my $self = shift;
	
	if (defined $self->{_source}) {
		return TRUE;
		}
	else {
		return FALSE;
		}

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSourcePhylogeny {
	
	my $self = shift;
	$self->throw("Unused variable.") if (!exists $self->{_sourcePhylogeny});
	return $self->{_sourcePhylogeny};
	
	} # End of method.

sub setSourcePhylogeny {
	
	my $self = shift;
	my $sourcePhylogeny = $self->check(shift);
	
	$self->{_sourcePhylogeny} = $sourcePhylogeny;
	
	} #ÊEnd of method.

sub hasSourcePhylogeny {

	my $self = shift;
	
	if (defined $self->{_sourcePhylogeny}) {
		return TRUE;
		}
	else {
		return FALSE;
		}

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAllLocusTags {
	
	my $self = shift;
	my $featureCollection = $self->getFeatureCollection;
	
	my %map;
	for (my $i = 0 ; $i < $featureCollection->getSize; $i++) {
		my $feature = $featureCollection->get($i);
		
		next if ($feature->getName eq "source" || $feature->getName eq "misc_feature");
		
		my $locusTag = $feature->getLocusTag;
		
		# Just in case haven't accounted for all scenarios.
		if ($locusTag eq "" || !defined $locusTag) {
			$self->throw("Unexpected absence of locus-tag: " . $feature->toString);
			}
		
		$map{$locusTag}++;
		}
	
	return keys %map;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getNextAvailableLocusTagNumber {
	
	my $self = shift;
	
	# Tag number is constructed from accession numerical suffix (e.g. 000001 of
	# contig000001).
	my $accession = $self->getPrimaryAccession;
	
	#ÊBe strict - 
	if (!$self->hasAccessionNumericalSuffix) {
		$self->throw(
			"Unable to generate locus tag - accession does not have a " .
			"numerical suffix that can be extracted."
			);
		}
	
	my $accNo = $self->getAccessionNumericalSuffix;
	
	
	# Get locus_tags already registered with record.
	my @locusTags = $self->getAllLocusTags;
	
	# Method only works if following expected pattern - be strict here: check
	# all existing locus tags.
	my $prefix = undef;
	my %suffixes;
	foreach my $locusTag (@locusTags) {
		
	
		
		if ($locusTag =~/^(\S+)\_$accNo(\d+)$/) {
			
			
			
			# prefix
			$prefix = $1 if (!defined $prefix);
			$self->throw("Prefixes don't match: $prefix vs $1.") if ($prefix ne $1);
			
			# suffixes
			$suffixes{$2}++;
			}
		else {
			
			$self->throw(
				"Can't use method - stored locus tag '$locusTag' does not " .
				"conform to required pattern."
				
				);
			
			}
			
		
		}
	
	my @sortedSuffixes = sort {$b <=> $a} keys %suffixes;
	
	if (@sortedSuffixes == 0) {push(@sortedSuffixes, -1);}

	
	my $newTagNumber = sprintf(
		"%05d%04d",
		$accNo,
		($sortedSuffixes[0]+1)
		);
	
	
	# Ugly temporary hack! Whole code needs rethink - problem is code is
	# attempting to extract prefix info from existing locus_tags to avoid
	# need for separate input - however, if no locus_tags yet exist no
	# prefix will be found.  As temporary measure, the following code is
	# invoked, the assumption being that prefix has been defined already -
	# not necessarily the case...
	if (!defined $prefix) {$prefix = $self->getLocusTagPrefix;}
	
	my $newTag = "$prefix\_$newTagNumber";
	
	# Check doesn't aready exist.
	foreach my $locusTag (@locusTags) {
		$self->throw("$locusTag already exists!") if $newTag eq $locusTag;
		}
	
	return $newTagNumber;
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getNextAvailableLocusTag {

	my $self = shift;
	
	return
		$self->getLocusTagPrefix . "_" .  
		$self->getNextAvailableLocusTagNumber;

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# Not a good variable as not normally retained by embl/genbank documents.

sub getLocusTagPrefix {
	
	my $self = shift;
	
	# Get locus_tags already registered with record.
	my @locusTags = $self->getAllLocusTags;
	
	# If locus tags already present, check against recorded prefix, if present
	# otherwise return prefix found.
	if (@locusTags > 1) {
		my $prefix = undef;
		my %suffixes;
		foreach my $locusTag (@locusTags) {
			
			if ($locusTag =~/^(\S+)\_\D*(\d+)$/) {
				# prefix
				$prefix = $1 if (!defined $prefix);
				$self->throw("Prefixes don't match: $prefix vs $1.") if ($prefix ne $1);
				
				}
			else {
				
				$self->throw(
					"locus_tag '$locusTag' does not conform to required pattern."
					);
				
				}
				
			
			}
		
		if (!defined $self->{_locusTagPrefix}) {
			return $prefix;
			}
		else {
			if ($self->{_locusTagPrefix} eq $prefix) {
				return $prefix;
				}
			else {
				$self->throw(
					"Conflicting locus_tag prefices: $prefix vs " .
					$self->{_locusTagPrefix} . "."
					);
				}
			}
		}
	
	
	$self->throw("Unused variable.") if (!exists $self->{_locusTagPrefix});
	return $self->{_locusTagPrefix};
	
	} # End of method.


sub setLocusTagPrefix {
	
	my $self = shift;
	my $locusTagPrefix = $self->check(shift);
	
	$self->throw(
		"Locus_tag prefix already defined: " . $self->{_locusTagPrefix} . "."
		)
		if (defined $self->{_locusTagPrefix});
	
	$self->{_locusTagPrefix} = $locusTagPrefix;
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose		: Returns molecule type as listed in ID section.
sub getMoleculeType {
	
	my $self = shift;
	$self->throw("Unused variable.") if (!exists $self->{_moleculeType});
	return $self->{_moleculeType};
	
	} # End of method.

sub setMoleculeType {
	
	my $self = shift;
	my $moleculeType = $self->check(shift);
	
	$self->{_moleculeType} = $moleculeType;
	} 

sub hasMoleculeType {

	my $self = shift;
	
	if (defined $self->{_moleculeType}) {
		return TRUE;
		}
	else {
		return FALSE;
		}

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose		: Returns data class as listed in ID section.
sub getDataClass {
	
	my $self = shift;
	$self->throw("Unused variable.") if (!exists $self->{_dataClass});
	return $self->{_dataClass};
	
	} # End of method.

sub setDataClass {

	my $self = shift;
	my $dataClass = $self->check(shift);
	
	$self->{_dataClass} = $dataClass;
	}

sub hasDataClass {

	my $self = shift;
	
	if (defined $self->{_dataClass}) {
		return TRUE;
		}
	else {
		return FALSE;
		}

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getTranslTable {
	
	my $self = shift;
	$self->throw("Unused variable.") if (!exists $self->{_translTable});
	return $self->{_translTable};
	
	} # End of method

sub setTranslTable {
	
	my $self = shift;
	my $translTable = $self->check(shift);
	
	$self->{_translTable} = $translTable;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose		: Returns length as listed in ID section.
sub getExpectedLength {
	
	my $self = shift;
	$self->throw("Unused variable.") if (!exists $self->{_expectedLength});
	return $self->{_expectedLength};
	
	} # End of method.

sub setExpectedLength {
	
	my $self = shift;
	my $expectedLength = $self->check(shift);
	
	$self->{_expectedLength} = $expectedLength;
	}

#///////////////////////////////////////////////////////////////////////////////

## Purpose		: Set accession number for record.
## Parameter	: Accession number string.
sub setAccession {

	my $self 		= shift;
	my $accession 	= $self->check(shift);

		$self->{_accession} = $accession;
	} # end of method

## Purpose		: Returns accession number.
## Return		: String.
sub getAccession {
	
	my $self = shift;
	$self->throw("Unused variable.") if (!exists $self->{_accession});
	return $self->{_accession};
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

##ÊPurpose		: Set dna sequence string for record.
## Parameter	: Sequence string.
sub setSequence {

	my $self 		= shift;
	my $sequence 	= $self->check(shift);
	
	$self->{_sequence} = $sequence;
	} # End of method.


## Purpose		: Returns dna sequence.
## Return		: String.
sub getSequence {
	
	my $self = shift;
	$self->throw("Unused variable.") if (!exists $self->{_sequence});
	return $self->{_sequence};
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSequenceObject {
	
	my $self = shift;

	return Kea::Sequence::SequenceFactory->createSequence(
		-sequence => $self->{_sequence},
		-id => $self->{_accession}
		);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getCodonAt {

	my $self 		= shift;
	my $location 	= $self->check(shift, "Kea::IO::Location");
	my $orientation = $self->check(shift);
	
	my $sequence = $self->{_sequence};
	
	my $subSeq = substr(
			$sequence,
			$location->getStart-1,
			$location->getLength
			);
	
	if ($orientation eq ANTISENSE) {
		$subSeq = Kea::Utilities::DNAUtility->getReverseComplement($subSeq);
		}
	
	return Kea::Sequence::CodonFactory->createCodon($subSeq);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getDNASequenceAtLocations {
	
	my $self = shift;
	my $locations = $self->checkIsArrayRef(shift);
	
	my $sequence = "";
	foreach my $location (@$locations) {
		$sequence .= $self->getSubsequenceAt($location, SENSE);
		}
	
	return $sequence;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSubsequenceAt {

	my $self 		= shift;
	my $location 	= $self->check(shift, "Kea::IO::Location");
	my $orientation = $self->check(shift);
	
	my $sequence = $self->{_sequence};
	my $subSeq =
		substr($sequence, $location->getStart-1, $location->getLength) or
			$self->throw(
				"substr failure - location:" . $location->toString .
				", length=" . $location->getLength . "."
				);
	
	if ($orientation eq ANTISENSE) {
		$subSeq = Kea::Utilities::DNAUtility->getReverseComplement($subSeq);	
		}
	
	return $subSeq;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLength {
	
	my $self = shift;
	$self->throw("Unused variable.") if (!exists $self->{_sequence});
	
	return length($self->{_sequence});
	
	} #ÊEnd of method.



#///////////////////////////////////////////////////////////////////////////////

#sub getLocation {
#	
#	my $self = shift;
#	 if (defined $self->{_location}) {
#		return $self->{_location};
#		}
#	 else {
#		$self->throw("No Location set.");
#		}
#	
#	} # End of method.
#
##///////////////////////////////////////////////////////////////////////////////
#
#sub setLocation {
#	
#	my $self = shift;
#	my $location = $self->check(shift, "Kea::IO::Location");
#	
#	$self->{_location} = $location;
#	
#	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getReferenceCollection {

	my $self = shift;
	$self->throw("Unused variable.") if (!exists $self->{_referenceCollection});
	return $self->{_referenceCollection};
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# NOTE: use add feature rather than getFeatureCollection to add new features
# due to current internal structure - NEEDS CHANGING!  See reference collection
# (above) for better design.
sub addFeature {

	my $self 	= shift;
	my $feature = $self->check(shift, "Kea::IO::Feature::IFeature");
	
	$feature->setParent($self);
	
	
	# Check locus_tag is unique. WON'T WORK - gen and CDS features will share
	# locus_tags.
	#my @locusTags = $self->getLocusTags;
	#my $newTag = $feature->getLocusTag;
	#foreach my $locusTag (@locusTags) {
	#	$self->throw("locus_tag '$newTag' already exists!")
	#		if ($newTag eq $locusTag);
	#	}
	
	push(@{$self->{_features}}, $feature);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose		: Adds an array of IFeature objects to record.
## Parameter	: Array of IFeature objects.
sub setFeatures {
	
	my $self 		= shift;
	my @features 	= @_;
	
	# Check array.
	foreach my $feature (@features) {
		$self->check($feature, "Kea::IO::Feature::IFeature");
		}
	
	$self->{_features} = \@features;
	
	#ÊRegister parent with each feature. 
	foreach my $feature (@features) {
		$feature->setParent($self);
		}
	}

#///////////////////////////////////////////////////////////////////////////////

sub setFeatureCollection {
	
	my $self = shift;
	
	my $featureCollection =
		$self->check(shift, "Kea::IO::Feature::FeatureCollection");
	
	$self->setFeatures($featureCollection->getAll);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

##ÊPurpose		: Returns array of IFeature objects stored in record.
##ÊReturns		: Array of Feature objects.
## Parameter	: n/a.
## Throws		: Dies if no features present.
sub getFeatures {
	
	my $self = shift;
	
	my @features = @{$self->{_features}};
		
	if (Kea::Properties->getProperty("warnings") ne "off") {
		$self->warn("No features stored in record " . $self->{_primaryAccession})
			if !@features;
		}
	
	return @features;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSortedFeatures {
	
	my $self = shift;
	
	my @features = $self->getFeatures;
	
	my @sortedFeatures =
		sort {
			$a->getFirstLocation->getStart
			<=>
			$b->getFirstLocation->getStart
			}
		@features;
	
	# Post process ordering to ensure source feature is first.
	my @final;
	
	my $counter = 0;
	foreach my $feature (@sortedFeatures) {
		
		if ($feature->getName ne "source") {
			push(@final, $feature);
			}
		
		elsif ($feature->getName eq "source" && $counter == 0) {
			unshift(@final, $feature);
			$counter++;
			}
		
		else {
			$self->throw("Record appears to have multiple source features.");	
			}
			
		}
	
	
	return @final;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getFeatureCollection {
	
	my $self = shift;
	my @features = $self->getFeatures;
	
	my $featureCollection = Kea::IO::Feature::FeatureCollection->new("");
	
	foreach my $feature (@features) {
		$featureCollection->add(
			$feature
			);
		}
	
	return $featureCollection;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# joins supplied features together to form join.
sub joinCDSFeatures {

	my ($self, %args) = @_;
	
	my $features 	= $args{-joinFeatures} or $self->check("No feature array provided");
	my $locusTag 	= $args{-locusTag};
	my $proteinId 	= $args{-proteinId}; 
	my $gene 		= $args{-gene};
	my $note 		= $args{-note};
	my $product 	= $args{-product};
	my $pseudo 		= $args{-pseudo}; 
	my $colour 		= $args{-colour};
	my $exception 	= $args{-exception};
	
	# Throw exception if only one feature provided.
	if (@$features < 2) {
		$self->throw("Attempting to join " . @$features . " features.");	
		}
	
	# Check features exist in record and that are CDS features. 
	foreach my $cdsFeature (@$features) {
	
		if ($cdsFeature->getName ne "CDS") {
			$self->throw(
				"Trying to jon non-CDS feature: " .
				$cdsFeature->toString
				);
			}
	
		if (!$self->hasFeature($cdsFeature)) {
			$self->throw(
				"Following feature does not exist in record: " .
				$cdsFeature->toString
				);
			}
		
		}
	
	# Convert first feature into joined feature 
	my $joinedFeature = shift(@$features);
	
	# Change contents of feature if alternatives provided.
	if ($locusTag) {
		$joinedFeature->setLocusTag($locusTag);
		}
	
	if ($proteinId) {
		$joinedFeature->setProteinId($proteinId);
		}
	
	if ($gene) {
		$joinedFeature->setGene($gene);
		}
	
	if ($note) {
		$joinedFeature->setNote($note);
		}
	
	if ($product) {
		$joinedFeature->setProduct($product);
		}
	
	if ($pseudo) {
		$joinedFeature->setPseudo($pseudo);	
		}
	
	if ($colour) {
		$joinedFeature->setColour($colour);
		}
	
	if ($exception) {
		$joinedFeature->setException($exception);
		}
	
	# Decide what to do with translation and associated dna sequence????
	
	
	# Construct complete location object array reflecting multi-interval nature
	# of resulting joined CDS feature.
	foreach my $feature (@$features) {
		
		# Should only have one location
		my @locations = $feature->getLocations;
		$self->throw(
			"Was only expecting one location object not " . @locations
			)
			if @locations > 1;
			
		$joinedFeature->addLocation($locations[0]);
		
		}
	
	# Delete the remainder from record.
	foreach my $feature (@$features) {
		$self->deleteFeature($feature);
		}
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub joinGeneFeatures {

	my ($self, %args) = @_;
	
	my $features 	= $args{-joinFeatures} or $self->check("No feature array provided");
	my $locusTag 	= $args{-locusTag};
	my $gene 		= $args{-gene};
	my $note 		= $args{-note};
	my $colour 		= $args{-colour};
	
	# Throw exception if only one feature provided.
	if (@$features < 2) {
		$self->throw("Attempting to join " . @$features . " features.");	
		}
	
	# Check features exist in record and that are gene features. 
	foreach my $geneFeature (@$features) {
	
		if ($geneFeature->getName ne "gene") {
			$self->throw(
				"Trying to jon non-gene feature: " .
				$geneFeature->toString
				);
			}
	
		if (!$self->hasFeature($geneFeature)) {
			$self->throw(
				"Following feature does not exist in record: " .
				$geneFeature->toString
				);
			}
		
		}
	
	# Convert first feature into joined feature 
	my $joinedFeature = shift(@$features);
	
	# Change contents of feature if alternatives provided.
	if ($locusTag) {
		$joinedFeature->setLocusTag($locusTag);
		}
	
	if ($gene) {
		$joinedFeature->setGene($gene);
		}
	
	if ($note) {
		$joinedFeature->setNote($note);
		}
	
	if ($colour) {
		$joinedFeature->setColour($colour);
		}
		
	
	# Ensure location of new joined feature is represented by a single location
	# object - gene features must not have multiple intervals.
	
	# First check (this code probably unnecessary but left over from earlier
	# code, and, well, it's doing no harm...).
	foreach my $feature (@$features) {
		
		# Should only have one location
		my @locations = $feature->getLocations;
		$self->throw(
			"Was only expecting one location object not " . @locations
			)
			if @locations > 1;
		}
	
	# joined gene feature to start from start position of first gene feature and
	# enf at end position of last gene feature.
	my $location = $joinedFeature->getFirstLocation;
	$location->setEnd($features->[@$features-1]->getFirstLocation->getEnd);
	
	# Delete the remainder from record.
	foreach my $feature (@$features) {
		$self->deleteFeature($feature);
		}
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getGeneFeatureCorrespondingToCDS {
	
	my $self 		= shift;
	my $cdsFeature 	= $self->check(shift, "Kea::IO::Feature::IFeature");
	
	# Gene feature is deemed to correspond to supplied CDS feature if is shares
	# the same start and end positions (most reliable approach - probably not
	# wise to rely on shared locus_tags ??).
	
	my $start = $cdsFeature->getFirstStart; # This method as may be joined feature
	my $end = $cdsFeature->getLastEnd;
	
	my @features = @{$self->{_features}};
	my @buffer;
	foreach my $feature (@features) {
		if (
			$feature->getFirstStart == $start &&
			$feature->getLastEnd == $end &&
			$feature->getName eq "gene"
			) {
			push(@buffer, $feature);
			}
		}
	
	# Just in case...
	if (@buffer > 1) {
		$self->throw(
			"More than one gene feature encountered which corresponds to " .
			"cds feature."
			);
		}
	
	return $buffer[0];
	
	# Be strict - can be commented out but take precautions with client code.
	$self->throw(
		"No gene feature could be found corresponding to '" .
		$cdsFeature->getId . "'"
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getFeaturesWithPosition {

	my $self 	= shift;
	my $start 	= $self->checkIsInt(shift);
	my $end 	= $self->checkIsInt(shift);
	
	my @features = @{$self->{_features}};
	
	my @buffer;
	foreach my $feature (@features) {
		if ($feature->getFirstStart == $start && $feature->getLastEnd == $end) {
			push(@buffer, $feature);
			}
		}
	
	# Be strict - can be commented out but take precautions with client code.
	if (!@buffer) {
		$self->throw("No features could be found at position $start..$end");
		}
	
	return @buffer;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getFeatureIndex {

	my $self 	= shift;
	my $query 	= $self->check(shift, "Kea::IO::Feature::IFeature");
	
	my @features = @{$self->{_features}};
	
	for (my $i = 0; $i < @features; $i++) {
		if ($features[$i] == $query) {return $i;}
		}
	
	$self->throw(
		"Attempting to obtain index of faeture that doesn't exist in record: " .
		$query->toString
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub deleteFeature {

	my $self 	= shift;
	my $feature = $self->check(shift, "Kea::IO::Feature::IFeature");
	
	if (!$self->hasFeature($feature)) {
		$self->throw(
			"Attempting to delete feature that doesn't exist in record: " .
			$feature->toString
			);
		}
	
	my $index = $self->getFeatureIndex($feature);
	
	splice(
		@{$self->{_features}},
		$index,
		1
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasFeature {

	my $self = shift;
	my $query = $self->check(shift, "Kea::IO::Feature::IFeature");
	
	my @features = @{$self->{_features}};
	
	foreach my $subject (@features) {
	
		#ÊDebugging purposes...
		$self->check($subject, "Kea::IO::Feature::IFeature");
	
		if ($query == $subject) {return TRUE;}
		}
	return FALSE;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getFeature {

	my $self 	= shift;
	my $i 		= $self->checkIsInt(shift);

	return $self->{_features}->[$i];
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getNumberOfFeatures {
	return scalar(@{shift->{_features}});
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getCDSFeatureWithLocusTag {
	
	my $self = shift;
	my $locusTag = $self->check(shift);
	
	my @cdsFeatures = $self->getAllCDSFeatures;
	foreach my $feature (@cdsFeatures) {
		return $feature if $feature->getLocusTag eq $locusTag;
		}
	
	# Be strict (can be commented out but extra care required with client code)
	$self->throw(
		"CDS feature with locus_tag '$locusTag' could not be found in " .
		"record " .	$self->getPrimaryAccession . "."
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getCDSFeatureWithProteinId{
	
	my $self = shift;
	my $proteinId = $self->check(shift);
	
	my @cdsFeatures = $self->getAllCDSFeatures;
	foreach my $feature (@cdsFeatures) {
		return $feature if $feature->getProteinId eq $proteinId;
		}
	
	# Be strict (can be commented out but extra care required with client code)
	$self->throw(
		"CDS feature with protein_id '$proteinId' could not be found in " .
		"record " .	$self->getPrimaryAccession . "."
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# includes cds features marked as pseudo
sub getAllCDSFeatures {
	
	my $self = shift;
	
	my @cdsFeatures;
	foreach my $feature (@{$self->{_features}}) {
		if ($feature->getName eq "CDS") {
			push(@cdsFeatures, $feature);
			}
		}
	return @cdsFeatures;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getCDSFeatures {
	
	my $self = shift;
	
	my @cdsFeatures;
	foreach my $feature (@{$self->{_features}}) {
		if ($feature->getName eq "CDS") {
		
			# Don't add pseudo CDS.
			if ($feature->isPseudo) {
			
				if (Kea::Properties->getProperty("warnings") ne "off") {
					$self->warn(
						"A pseudo CDS has been encountered within record " .
						$self->{_primaryAccession} .
						".  This will not be considered in the subsequent analysis."
						);
					}
				
				
				next;
				} 
		
			push(@cdsFeatures, $feature);
			}
		}
	
	return @cdsFeatures;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getCDSFeatureCount {
	
	my $self = shift;
	
	my $counter = 0;
	foreach my $feature (@{$self->{_features}}) {
		if ($feature->getName eq "CDS") {
		
			# Don't include pseudo CDS.
			if (!$feature->isPseudo) {
				$counter++;
				} 
		
			}
		}
	
	return $counter;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getProteinIdList {
	
	my $self = shift;
	
	my $featureCollection = $self->getCDSFeatureCollection;
	
	my @list;
	for (my $i = 0; $i < $featureCollection->getSize; $i++) {
		my $feature = $featureCollection->get($i);
		push(
			@list,
			# WHY LOCUS TAG HERE????
			#$feature->getLocusTag
			$feature->getProteinId
			);
		}
	
	return @list;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getCDSFeatureCollection {

	my $self = shift;
	
	my $featureCollection = Kea::IO::Feature::FeatureCollection->new;
	foreach my $feature (@{$self->{_features}}) {
		if ($feature->getName eq "CDS") {
		
			# Don't add pseudo CDS.
			if ($feature->isPseudo) {
			
				if (Kea::Properties->getProperty("warnings") ne "off") {
				
					$self->warn(
						"A pseudo CDS has been encountered within record " .
						$self->{_primaryAccession} .
						".  This will not be considered in the subsequent analysis."
						);
					
					}
			
				
				next;
				} 
		
			$featureCollection->add($feature);
			}
		}
	
	return $featureCollection;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub equals {
	
	my $self 	= shift;
	my $record 	= $self->check(shift, "Kea::IO::IRecord");
	
	if ($self->getPrimaryAccession eq $record->getPrimaryAccession) {
		return TRUE;
		}
	else {
		return FALSE;
		}
		
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self = shift;
	
	my $primaryAccession 	= $self->{_primaryAccession};
	my $sequence 			= $self->{_sequence};
	my @cdsFeatures 		= $self->getCDSFeatures;
	
	my $text =
		"Primary accession = '$primaryAccession'\n" .
		"Number of CDS = " . @cdsFeatures . "\n" . 
		"Sequence length = " . length($sequence) . "\n" .
		"First 50 bases = '" . substr($sequence, 0, 50)  . "'\n";
	return $text;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

