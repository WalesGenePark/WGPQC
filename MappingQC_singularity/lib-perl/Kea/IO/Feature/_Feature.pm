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
package Kea::IO::Feature::_Feature;
use Kea::Object;
use Kea::IO::Feature::IFeature; 
our @ISA = qw(Kea::Object Kea::IO::Feature::IFeature);

use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant NULL 		=> "null";

use Kea::IO::Location;

################################################################################

# CLASS FIELDS

our $_counter = 0;

my @_featureList = qw(
	CDS
	RNA
	gene
	source
	exon
	tRNA
	mRNA
	intron
	misc_feature
	UTRS
	TU
	
	Region
	Comment
	rep_origin
	misc_RNA
	rRNA
	gap
	repeat_region
	snp
	misc_binding
	ncRNA
	sig_peptide
	stem_loop
	terminator
	-35_signal
	-10_signal
	variation
	tmRNA
	);

# NOTE snp not an authodox feature	
	
my %_qualifierKey = (
	_colour 				=> "colour",
	_pseudo 				=> "pseudo",
	
	# Synonyms
	_protDesc				=> "prot_desc",
	_geneSyn				=> "gene_syn",
	
	
	
	
	# Qualifiers as specified by
	# http://www.ncbi.nlm.nih.gov/projects/collab/FT/index.html#7.4.1
	_allele					=> "allele",	
	_anticodon				=> "anticodon",
	_bioMaterial			=> "bio_material",
	_boundMoiety			=> "bound_moiety",
	_cellLine				=> "cell_line",
	_cellType				=> "cell_type",
	_chromosome				=> "chromosome",
	_citation				=> "citation",
	_clone					=> "clone",
	_cloneLib				=> "clone_lib",
	_codon					=> "codon",
	_codonStart				=> "codon_start",
	_collectedBy			=> "collected_by",
	_collectionDate			=> "collection_date",
	_compare				=> "compare",
	_country				=> "country",
	_cultivar				=> "cultivar",
	_cultureCollection		=> "culture_collection",
	_dbXref					=> "db_xref",
	_devStage				=> "dev_stage",
	_direction				=> "direction",
	_ECNumber				=> "EC_number",
	_ecotype				=> "ecotype",	
	_estimatedLength		=> "estimated_length",
	_exception				=> "exception",
	_experiment				=> "experiment",
	_frequency				=> "frequency",
	_function				=> "function",
	_gene					=> "gene",
	_geneSynonym			=> "gene_synonym",
	_haplotype				=> "haplotype",
	_host					=> "host",
	_identifiedBy			=> "identified_by",	
	_inference				=> "inference",
	_isolate				=> "isolate",
	_isolationSource		=> "isolation_source",
	_label					=> "label",
	_labHost				=> "lab_host",	
	_latLon					=> "lat_lon",
	_locusTag				=> "locus_tag",
	_map					=> "map",
	_matingType				=> "mating_type",
	_mobileElement			=> "mobile_element",	
	_modBase				=> "mod_base",
	_molType				=> "mol_type",
	_ncRNAClass				=> "ncRNA_class",
	_note					=> "note",
	_number					=> "number",
	_oldLocusTag			=> "old_locus_tag",
	_operon					=> "operon",
	_organelle				=> "organelle",
	_organism				=> "organism",
	_PCRConditions			=> "PCR_conditions",
	_PCRPrimers				=> "PCR_primers",
	_phenotype				=> "phenotype",
	_popVariant				=> "pop_variant",
	_plasmid				=> "plasmid",
	_product				=> "product",
	_proteinId				=> "protein_id",
	_replace				=> "replace",
	_rptFamily				=> "rpt_family",
	_rptType				=> "rpt_type",
	_rptUnitRange			=> "rpt_unit_range",	
	_rptUnitSeq				=> "rpt_unit_range",
	_satellite				=> "satellite",
	_segment				=> "segment",
	_serotype				=> "serotype",
	_serovar				=> "serovar",
	_sex					=> "sex",
	_specimenVoucher		=> "specimen_voucher",
	_standardName			=> "standard_name",
	_strain					=> "strain",
	_subClone				=> "sub_clone",
	_subSpecies				=> "sub_species",
	_subStrain				=> "sub_strain",
	_tagPeptide				=> "tag_peptide",
	_tissueLib				=> "tissue_lib",
	_tissueType				=> "tissue_type",
	_translation			=> "translation",
	_translExcept			=> "transl_except",
	_translTable			=> "transl_table",
	_variety				=> "variety"
	);

################################################################################

# CONSTRUCTOR

sub new {
	my ($className, %args) = @_;
	
	# Object counter.
	$_counter++;
	
	# Generate unique id for feature.
	my $id = "id_$_counter";
	if (exists $args{-uniqueId}) {
		$id = $args{-uniqueId};
		}
	
	
	#ÊThrow exception if name not recognised.
	if (!defined $args{-name}) {
		Kea::Object->throw("No value asigned to -name flag.");
		}
		
	# Check that provided feature name is valid.
	#======================================================================
	my $featureName = undef;
	foreach my $value (@_featureList) {
	
		if ($value eq $args{-name}) {
			$featureName = $value;
			last;
			}
		}
	
	if (!defined $featureName) {
		Kea::Object->throw("Unrecognised feature name: '$args{-name}'.");
		}
	
	#=======================================================================
	
	my $self = {
		_uniqueId 		=> $id,
		_parent 		=> $args{-parent},
		_name 			=> $featureName,
		_orientation 	=> $args{-orientation},
		_dnaSequence 	=> $args{-dnaSequence},
		
		# Qualifiers (not specifed by ncbi)
		_colour 		=> $args{-colour},
		_pseudo 		=> $args{-pseudo},
		# Synonyms (non-standard?)
		_protDesc		=> $args{-protDesc}, # Synonym for product
		_geneSyn		=> $args{-geneSyn}, # Synonymn for gene_synonym ?
		
		
		
		# Qualifiers as specified by
		# http://www.ncbi.nlm.nih.gov/projects/collab/FT/index.html#7.4.1
		_allele				=> $args{-allele},	
		_anticodon			=> $args{-anticodon},
		_bioMaterial			=> $args{-bioMaterial},
		_boundMoiety			=> $args{-boundMoiety},
		_cellLine			=> $args{-cellLine},
		_cellType			=> $args{-cellType},
		_chromosome			=> $args{-chromosome},
		_citation			=> $args{-citation},
		_clone				=> $args{-clone},
		_cloneLib			=> $args{-cloneLib},
		_codon				=> $args{-codon},
		_codonStart			=> $args{-codonStart},
		_collectedBy			=> $args{-collectedBy},
		_collectionDate			=> $args{-collectionDate},
		_compare			=> $args{-compare},
		_country			=> $args{-country},
		_cultivar			=> $args{-cultivar},
		_cultureCollection		=> $args{-cultureCollection},
		_dbXref				=> $args{-dbXref},
		_devStage			=> $args{-devStage},
		_direction			=> $args{-direction},
		_ECNumber			=> $args{-ECNumber},
		_ecotype			=> $args{-ecotype},	
		_estimatedLength		=> $args{-estimatedLength},
		_exception			=> $args{-exception},
		_experiment			=> $args{-experiment},
		_frequency			=> $args{-frequency},
		_function			=> $args{-function},
		_gene				=> $args{-gene},
		_geneSynonym			=> $args{-geneSynonym},
		_haplotype			=> $args{-haplotype},
		_host				=> $args{-host},
		_identifiedBy			=> $args{-identifiedBy},	
		_inference			=> $args{-inference},
		_isolate			=> $args{-isolate},
		_isolationSource		=> $args{-isolationSource},
		_label				=> $args{-label},
		_labHost			=> $args{-labHost},	
		_latLon				=> $args{-latLon},
		_locusTag			=> $args{-locusTag},
		_map				=> $args{-map},
		_matingType			=> $args{-matingType},
		_mobileElement			=> $args{-mobileElement},	
		_modBase			=> $args{-modBase},
		_molType			=> $args{-molType},
		_ncRNAClass			=> $args{-ncRNAClass},
		_note				=> $args{-note},
		_number				=> $args{-number},
		_oldLocusTag			=> $args{-oldLocusTag},
		_operon				=> $args{-operon},
		_organelle			=> $args{-organelle},
		_organism			=> $args{-organism},
		_PCRConditions			=> $args{-PCRConditions},
		_PCRPrimers			=> $args{-PCRPrimers},
		_phenotype			=> $args{-phenotype},
		_popVariant			=> $args{-popVariant},
		_plasmid			=> $args{-plasmid},
		_product			=> $args{-product},
		_proteinId			=> $args{-proteinId},
		_replace			=> $args{-replace},
		_rptFamily			=> $args{-rptFamily},
		_rptType			=> $args{-rptType},
		_rptUnitRange			=> $args{-rptUnitRange},	
		_rptUnitSeq			=> $args{-rptUnitRange},
		_satellite			=> $args{-satellite},
		_segment			=> $args{-segment},
		_serotype			=> $args{-serotype},
		_serovar			=> $args{-serovar},
		_sex				=> $args{-sex},
		_specimenVoucher		=> $args{-specimenVoucher},
		_standardName			=> $args{-standardName},
		_strain				=> $args{-strain},
		_subClone			=> $args{-subClone},
		_subSpecies			=> $args{-subSpecies},
		_subStrain			=> $args{-subStrain},
		_tagPeptide			=> $args{-tagPeptide},
		_tissueLib			=> $args{-tissueLib},
		_tissueType			=> $args{-tissueType},
		_translation			=> $args{-translation},
		_translExcept			=> $args{-translExcept},
		_translTable			=> $args{-translTable},
		_variety			=> $args{-variety}
		};
	
	
	
	
	bless(
		$self,
		$className
		);
	
	# Add locations separately as these will require full checking.
	# (Location objects should only be added via this method.)
	if (exists $args{-locations}) {
		$self->setLocations($args{-locations});
		} 
	
	return $self;
	} # End of constructor.

################################################################################

# PUBLIC METHODS

# Generate id unique to this feature.
sub getUniqueId {
	return shift->{_uniqueId};
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getParent {
	my $self = shift;
	my $parent = $self->{_parent};
	return $parent;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setParent {

	my $self = shift;
	my $parent = $self->check(shift, "Kea::IO::IRecord");
	
	# COMMENTED OUT WARNING FOR WHEN PARENT ALREADY DEFINED. 
	#if (defined $self->{_parent}) {
	#	my $text = sprintf(
	#		"Parent of feature '%s' has changed from '%s' to '%s'.",
	#		$self->{_proteinId},
	#		$self->{_parent}->getPrimaryAccession,
	#		$parent->getPrimaryAccession
	#		);
	#	$self->warn($text);
	#	}
	
	$self->{_parent} = $parent;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub isPseudo {
	return shift->{_pseudo};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setPseudo {
	
	my $self = shift;
	my $pseudo = $self->check(shift);
	
	$self->{_pseudo} = $pseudo;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getProduct {
	return shift->{_product};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setProduct {
	
	my $self = shift;
	my $product = $self->check(shift);
	
	$self->{_product} = $product;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getOrientation {
	return shift->{_orientation};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setOrientation {
	
	my $self = shift;
	my $orientation = $self->check(shift);
	
	$self->{_orientation} = $orientation;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getEstimatedLength {
	return shift->{_estimatedLength};
	} # End of method.

sub setEstimatedLength {
	
	my $self = shift;
	my $estimatedLength = $self->checkIsInt(shift);
	
	$self->{_estimatedLength} = $estimatedLength;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getRptFamily {
	return shift->{_rptFamily};
	} # End of method.

sub setRptFamily {
	
	my $self = shift;
	my $rptFamily = $self->check(shift);
	
	$self->{_rptFamily} = $rptFamily;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub reverseOrientation {
	
	my $self = shift;
	
	my $oldOrientation = $self->{_orientation};
	
	if ($oldOrientation eq SENSE) {
		$self->{_orientation} = ANTISENSE;
		}
	else {
		$self->{_orientation} = SENSE;
		}
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getName {
	return shift->{_name};
	} # End of method.

sub setName {
	
	my $self = shift;
	my $name = $self->check(shift);
	
	$self->{_name} = $name;

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getTranslation {
	return shift->{_translation};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setTranslation {
	
	my $self = shift;
	my $translation = $self->check(shift);
	
	$self->{_translation} = $translation;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setDNASequence {
	
	my $self = shift;
	my $sequence = $self->check(shift);
	
	$self->{_dnaSequence} = $sequence;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getDNASequence {

	my $self = shift;
	
	$self->throw("Feature created without DNA sequence")
		if !defined $self->{_dnaSequence};
	
	return $self->{_dnaSequence};
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasDNASequence {
	return TRUE if defined shift->{_dnaSequence};
	return FALSE;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getGene {return shift->{_gene};} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setGene {
	
	my $self = shift;
	my $gene = $self->check(shift);
	
	$self->{_gene} = $gene;
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getFirstStart {
	
	my $self = shift;	
	
	my @locations = @{$self->{_locations}};
	return $locations[0]->getStart;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLastEnd {
	
	my $self = shift;
	
	my @locations = @{$self->{_locations}};
	return $locations[@locations-1]->getEnd;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getStart {
	
	my $self = shift;
	my $i = $self->checkIsInt(shift);
	
	my $locations = $self->{_locations};
	
	$self->warn("DEPRECATED: this method is deprecated - use getLocations");
	
	# If user has provided an index for the start array, return corresponding
	# start position.
	if (defined $i) {
		return $$locations[$i]->getStart;
		}
	
	# If reach this point assume user is expecting only one start.
	if (scalar(@$locations) > 1) {
		
		print $self->getLocusTag . ") " . @$locations . "\n";
		
		# More than one start found - be strict and throw exception rather than
		# silently select first.
		$self->throw(
			"More than one start position - use getStartArray() method"
			);
		}
	
	return $$locations[0]->getStart;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setStart {

	my $self = shift;
	my $start = $self->checkIsInt(shift);
	
	$self->warn("DEPRECATED: this method is deprecated - use setLocations");
	
	if (scalar(@{$self->{_locations}}) > 1) {
		$self->throw("Expecting more than one start position");
		}
	
	$self->{_locations}->[0]->setStart($start);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getEnd {

	my $self = shift;
	my $i = $self->checkIsInt(shift);
	
	$self->warn("DEPRECATED: this method is deprecated - use getLocations");
	
	my $locations = $self->{_locations};
	
	if (defined $i) {
		return $locations->[$i]->getEnd;
		}
	
	if (scalar(@$locations) > 1) {
		$self->throw("More than one end position");
		}
	
	return $$locations[0]->getEnd;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setEnd {
	my $self = shift;
	my $end = $self->checkIsInt(shift);
	
	$self->warn("DEPRECATED: this method is deprecated - use setLocations");
	
	if (scalar(@{$self->{_locations}}) > 1) {
		$self->throw("Expecting more than one start position");
		}
	
	$self->{_locations}->[0]->setEnd($end);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasMultipleStartPositions {

	my $locations = shift->{_locations};
	if (scalar(@{$locations}) > 1) {return TRUE;} else {return FALSE;}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getStartArray {
	
	my $self = shift;

	my $locations = $self->{_locations};
	
	$self->warn("DEPRECATED: this method is deprecated - use getLocations");
	
	my @startArray;
	foreach my $location (@$locations) {
		push(@startArray, $location->getStart);
		}
	
	return @startArray;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getEndArray {

	my $self = shift;

	my $locations = $self->{_locations};
	
	$self->warn("DEPRECATED: this method is deprecated - use getLocations");
	
	my @endArray;
	foreach my $location (@$locations) {
		push(@endArray, $location->getEnd);
		} 
	
	return @endArray;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setLocations {

	my $self = shift;
	my $locations = $self->check(shift);
	
	# Just in case...
	foreach my $location (@$locations) {
		$self->check($location, "Kea::IO::Location");
		}
	
	# Enforce ascending order - could silently re-order here but better to fail
	# here to ensure correct ordering from the outset.
	if (@$locations > 1) {
		my $midpoint = $locations->[0]->getMidpoint;
		for (my $i = 1; $i < @$locations; $i++) {
			if ($locations->[$i]->getMidpoint < $midpoint) {
			
				foreach my $location (@$locations) {
					print "==>" . $location->toString . "\n";
					}
			
				$self->throw(
					"Location objects do not appear to be ordered " .
					"for feature " .
					$self->{_proteinId} . 
					"."
					);
				}
			$midpoint = $locations->[$i]->getMidpoint;
			}
		} 
	
	
	$self->{_locations} = $locations;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub addLocation {

	my $self = shift;
	my $location = $self->check(shift, "Kea::IO::Location");
	
	# But must enforce ordered lacations - could sort here but bugs less likely
	# if enforce sorting prior to addition - more transparent.
	# setLocations() should be the only method which adds locations to feature:
	my $locations  = $self->{_locations};
	push(@$locations, $location);
	$self->setLocations($locations); # Will check fo ordering.
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLocations {

	my $self = shift;
	 
	$self->throw("No location(s) registered with object.")
		if (!exists $self->{_locations});

	return @{$self->{_locations}};
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getFirstLocation {
	
	my $self = shift;
	my @locations = $self->getLocations;
	return $locations[0];
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLastLocation	{
	
	my $self = shift;
	my @locations = $self->getLocations;
	return $locations[@locations-1];
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSize {
	
	my $self = shift;
	my @locations = $self->getLocations;
	
	my $size = 0;
	foreach my $location (@locations) {
		$size += $location->getLength;
		}
	
	return $size;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLocation {
	
	my $self = shift;
	my @locations = $self->getLocations;
	
	if (@locations > 1) {
		$self->throw(
			"Method should not be used with multiple locations (" .
			@locations . 
			")."
			);
		}
	
	return $locations[0];
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getColour {
	
	my $self = shift;
	my $colour = $self->{_colour};

	# Uncomment to be strict - WARNING: other classes will require updating.
	#if (!defined $colour) {
	#	$self->throw("No colour defined.");
	#	}
	
	return $colour;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setColour {
	
	my $self = shift;
	my $colour = $self->check(shift);
	
	$self->{_colour} = $colour;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasColour {
	
	my $self = shift;
	my $colour = $self->{_colour};
	
	if (defined $colour) {
		return TRUE;
		}
	else {
		return FALSE;
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasNote {
	if (defined shift->{_note}) {return TRUE;} else {return FALSE;} 
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getNote {
	return shift->{_note};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setNote {

	my $self = shift;
	my $note = $self->check(shift);

	$self->{_note} = $note;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub appendToNote {
	
	my $self = shift;
	my $note = $self->check(shift);
	
	if ($self->{_note}) {
		$self->{_note} = $self->{_note} . "$note";
		}
	else {
		$self->{_note} = $note;
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getCodonStart {
	return shift->{_codonStart};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setCodonStart {
	
	my $self = shift;
	my $codonStart = $self->check(shift);
	
	$self->{_codonStart} = $codonStart;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getTranslTable {
	return shift->{_translTable};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setTranslTable {
	
	my $self = shift;
	my $translTable = $self->check(shift);
	
	$self->{_translTable} = $translTable;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getInference {
	return shift->{_inference};
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub setInference {
	
	my $self = shift;
	my $inference = $self->check(shift);
	
	$self->{_inference} = $inference;	
		
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getException {
	return shift->{_exception};	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setException {
	
	my $self = shift;
	my $exception = $self->check(shift);
	
	$self->{_exception} = $exception;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getProteinId {
	return shift->{_proteinId};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setProteinId {
	
	my $self = shift;
	my $proteinId = $self->check(shift);
	
	$self->{_proteinId} = $proteinId;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLocusTag {
	return shift->{_locusTag};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setLocusTag {
	
	my $self = shift;
	my $locusTag = $self->check(shift);
	
	$self->{_locusTag} = $locusTag;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getMolType {
	return shift->{_molType};
	} # End of method.

sub setMolType {
	
	my $self = shift;
	my $molType = $self->check(shift);
	
	$self->{_molType} = $molType;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getDbXref {
	return shift->{_dbXref};
	} # End of method.

sub setDbXref {
	
	my $self = shift;
	my $dbXref = $self->check(shift);
	
	$self->{_dbXref} = $dbXref;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getOrganism {
	return shift->{_organism};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getStrain {
	return shift->{_strain};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getNumber {
	return shift->{_number};
	} # End of method.

sub setNumber {
	
	my $self = shift;
	my $number = $self->checkIsInt(shift);
	$self->{_number} = $number;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getProtDesc {
	return shift->{_protDesc};
	} # End of method.

sub setProtDesc {
	
	my $self = shift;
	my $protDesc = $self->check(shift);
	
	$self->{_protDesc} = $protDesc;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# Returns all qualifiers registered with feature, with recognised qualifier
# names as keys.

sub getAllQualifiersAsMap {
	
	my $self = shift;
	
	my %map;

	foreach my $key (keys %$self) {
		
		if (exists $_qualifierKey{$key} && defined $self->{$key}) {
			$map{$_qualifierKey{$key}} = $self->{$key};
			}
			
		}
	
	return \%map;


	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setQualifier {
	
	my $self			= shift;
	my $qualifier		= $self->check(shift); # e.g. 'note'
	my $value			= $self->check(shift); # e.g. 'some text'.
	
	my $internalKey = $self->_getQualifierKeyFromValue($qualifier);
	$self->{$internalKey} = $value;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _getQualifierKeyFromValue {
	
	my $self 		= shift;
	my $qualifier 	= $self->check(shift);
	
	foreach my $internalKey (keys %_qualifierKey) {
		
		if ($_qualifierKey{$internalKey} eq $qualifier) {
			return $internalKey;
			}
	
		}
	
	$self->throw("No not recognise qualifier '$qualifier'.");
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasQualifier {
	
	my $self 		= shift;
	my $qualifier 	= $self->check(shift);
	
	my $internalKey = $self->_getQualifierKeyFromValue($qualifier);
	
	if (defined $self->{$internalKey}) {
		return TRUE;
		}
	
	else {
		return FALSE;
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self = shift;
	
	my $parent = NULL;
	if (defined $self->{_parent}) {
		$parent = $self->{_parent}->getPrimaryAccession;
		}
	
	my $locations = "";
	if (defined $self->getLocations) {
		my @locations = $self->getLocations;
		foreach (@locations) {
			$locations .= $_->toString . " "
			}
		}
	
	
	return sprintf(
	
		"%15s =\t%s\n" .
		"%15s =\t%s\n" .
		"%15s =\t%s\n" .
		"%15s =\t%s\n" .
		"%15s =\t%s\n" .
		"%15s =\t%s\n" .
		"%15s =\t%s\n" .
		"%15s =\t%s\n" .
		"%15s =\t%s\n" .
		"%15s =\t%s\n" .
		"%15s =\t%s\n" .
		"%15s =\t%s\n",
		
		"Feature",			$self->{_name} || NULL,
		"Unique id",		$self->{_uniqueId} || NULL,
		"Parent",			$parent,
		"protein_id",		$self->{_proteinId} || NULL,
		"locus_tag",		$self->{_locusTag} || NULL,
		"gene",				$self->{_gene} || NULL,
		"orientation",		$self->{_orientation} || NULL,
		"colour",			$self->{_colour} || NULL,
		"product",			$self->{_product} || NULL,
		"note",				$self->{_note} || NULL,
		"location(s)",		$locations,
		"has dna",			$self->hasDNASequence,
		"translation",		$self->getTranslation || NULL
		);
		
	} # End of method.

################################################################################
		
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;