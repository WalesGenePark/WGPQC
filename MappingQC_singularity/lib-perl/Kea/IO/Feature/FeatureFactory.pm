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
package Kea::IO::Feature::FeatureFactory;
use Kea::Object;
our @ISA = qw(Kea::Object);

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;
use constant SENSE 	=> "sense";
use constant ANTISENSE 	=> "antisense";

use Kea::IO::Feature::_Feature;

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

my $privateMethod = sub {
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub create {
	
	my $self = shift;
	my %args = @_;
	
	return Kea::IO::Feature::_Feature->new(
	
		-parent 	=> $args{-parent},
		-name 		=> $args{-name},
		-orientation 	=> $args{-orientation},
		-dnaSequence 	=> $args{-dnaSequence},
		-locations 	=> $args{-locations},
		
		
		# Qualifiers (not specifed by ncbi)
		-colour 	=> $args{-colour},
		-pseudo 	=> $args{-pseudo},
		# Synonyms (non-standard?)
		-protDesc	=> $args{-protDesc}, # Synonym for product
		-geneSyn	=> $args{-geneSyn}, # Synonymn for gene_synonym ?
		
		
		
		# Qualifiers as specified by
		# http://www.ncbi.nlm.nih.gov/projects/collab/FT/index.html#7.4.1
		-allele			=> $args{-allele},	
		-anticodon				=> $args{-anticodon},
		-bioMaterial			=> $args{-bioMaterial},
		-boundMoiety			=> $args{-boundMoiety},
		-cellLine				=> $args{-cellLine},
		-cellType				=> $args{-cellType},
		-chromosome				=> $args{-chromosome},
		-citation				=> $args{-citation},
		-clone					=> $args{-clone},
		-cloneLib				=> $args{-cloneLib},
		-codon					=> $args{-codon},
		-codonStart				=> $args{-codonStart},
		-collectedBy			=> $args{-collectedBy},
		-collectionDate			=> $args{-collectionDate},
		-compare				=> $args{-compare},
		-country				=> $args{-country},
		-cultivar				=> $args{-cultivar},
		-cultureCollection		=> $args{-cultureCollection},
		-dbXref					=> $args{-dbXref},
		-devStage				=> $args{-devStage},
		-direction				=> $args{-direction},
		-ECNumber				=> $args{-ECNumber},
		-ecotype				=> $args{-ecotype},	
		-estimatedLength		=> $args{-estimatedLength},
		-exception				=> $args{-exception},
		-experiment				=> $args{-experiment},
		-frequency				=> $args{-frequency},
		-function				=> $args{-function},
		-gene					=> $args{-gene},
		-geneSynonym			=> $args{-geneSynonym},
		-haplotype				=> $args{-haplotype},
		-host					=> $args{-host},
		-identifiedBy			=> $args{-identifiedBy},	
		-inference				=> $args{-inference},
		-isolate				=> $args{-isolate},
		-isolationSource		=> $args{-isolationSource},
		-label					=> $args{-label},
		-labHost				=> $args{-labHost},	
		-latLon					=> $args{-latLon},
		-locusTag				=> $args{-locusTag},
		-map					=> $args{-map},
		-matingType				=> $args{-matingType},
		-mobileElement			=> $args{-mobileElement},	
		-modBase				=> $args{-modBase},
		-molType				=> $args{-molType},
		-ncRNAClass				=> $args{-ncRNAClass},
		-note					=> $args{-note},
		-number					=> $args{-number},
		-oldLocusTag			=> $args{-oldLocusTag},
		-operon					=> $args{-operon},
		-organelle				=> $args{-organelle},
		-organism				=> $args{-organism},
		-PCRConditions			=> $args{-PCRConditions},
		-PCRPrimers				=> $args{-PCRPrimers},
		-phenotype				=> $args{-phenotype},
		-popVariant				=> $args{-popVariant},
		-plasmid				=> $args{-plasmid},
		-product				=> $args{-product},
		-proteinId				=> $args{-proteinId},
		-replace				=> $args{-replace},
		-rptFamily				=> $args{-rptFamily},
		-rptType				=> $args{-rptType},
		-rptUnitRange			=> $args{-rptUnitRange},	
		-rptUnitSeq				=> $args{-rptUnitRange},
		-satellite				=> $args{-satellite},
		-segment				=> $args{-segment},
		-serotype				=> $args{-serotype},
		-serovar				=> $args{-serovar},
		-sex					=> $args{-sex},
		-specimenVoucher		=> $args{-specimenVoucher},
		-standardName			=> $args{-standardName},
		-strain					=> $args{-strain},
		-subClone				=> $args{-subClone},
		-subSpecies				=> $args{-subSpecies},
		-subStrain				=> $args{-subStrain},
		-tagPeptide				=> $args{-tagPeptide},
		-tissueLib				=> $args{-tissueLib},
		-tissueType				=> $args{-tissueType},
		-translation			=> $args{-translation},
		-translExcept			=> $args{-translExcept},
		-translTable			=> $args{-translTable},
		-variety				=> $args{-variety}
		
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createCDS {
	my ($self, %args) = @_;
	return Kea::IO::Feature::_Feature->new(
		
		-parent 		=> $args{-parent},
		-colour 		=> $args{-colour},
		-orientation 	=> $args{-orientation},
		
		-name 			=> "CDS",
		
		-gene 			=> $args{-gene},
		-proteinId 		=> $args{-proteinId},
		-locusTag 		=> $args{-locusTag},
		-locations 		=> $args{-locations},
		-translation 	=> $args{-translation},
		-note 			=> $args{-note},
		-codonStart 	=> $args{-codonStart},
		-translTable 	=> $args{-translTable},
		-pseudo 		=> $args{-pseudo},
		-product 		=> $args{-product},
		-inference		=> $args{-inference},
		-exception 		=> $args{-exception}
		);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createGene {
	my ($self, %args) = @_;
	return Kea::IO::Feature::_Feature->new(
		-parent 		=> $args{-parent},
		-name 			=> "gene",
		-gene 			=> $args{-gene},
		-locusTag 		=> $args{-locusTag},
		-locations 		=> $args{-locations},
		-note 			=> $args{-note},
		-orientation 	=> $args{-orientation},
		-colour 		=> $args{-colour},
		-pseudo 		=> $args{-pseudo}
		);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createExon {
	
	my $self = shift;
	my %args = @_;
	
	return Kea::IO::Feature::_Feature->new(
		-parent 		=> $args{-parent},
		-name 			=> "exon",
		-gene 			=> $args{-gene},
		-locations 		=> $args{-locations},
		-locusTag 		=> $args{-locusTag},
		-colour 		=> $args{-colour},
		-note 			=> $args{-note},
		-orientation 	=> $args{-orientation}
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createtRNA {
	
	my $self = shift;
	my %args = @_;
	
	return Kea::IO::Feature::_Feature->new(
		-parent 		=> $args{-parent},
		-name 			=> "tRNA",
		-gene 			=> $args{-gene},
		-locations 		=> $args{-locations},
		-locusTag 		=> $args{-locusTag},
		-colour 		=> $args{-colour},
		-note 			=> $args{-note},
		-orientation 	=> $args{-orientation},
		-product 		=> $args{-product}
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createmRNA {
	
	my $self = shift;
	my %args = @_;
	
	return Kea::IO::Feature::_Feature->new(
		-parent 		=> $args{-parent},
		-name 			=> "mRNA",
		-gene 			=> $args{-gene},
		-locations 		=> $args{-locations},
		-locusTag 		=> $args{-locusTag},
		-colour 		=> $args{-colour},
		-note 			=> $args{-note},
		-orientation 	=> $args{-orientation},
		-product 		=> $args{-product}
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createrRNA {
	
	my $self = shift;
	my %args = @_;
	
	return Kea::IO::Feature::_Feature->new(
		-parent 		=> $args{-parent},
		-name 			=> "rRNA",
		-gene 			=> $args{-gene},
		-locations 		=> $args{-locations},
		-locusTag 		=> $args{-locusTag},
		-colour 		=> $args{-colour},
		-note 			=> $args{-note},
		-orientation 	=> $args{-orientation},
		-product 		=> $args{-product}
		);
	
	} # End of method.
			
#///////////////////////////////////////////////////////////////////////////////

sub createMiscRNA {
	
	my $self = shift;
	my %args = @_;
	
	return Kea::IO::Feature::_Feature->new(
		-parent 		=> $args{-parent},
		-name 			=> "misc_RNA",
		-gene 			=> $args{-gene},
		-locations 		=> $args{-locations},
		-locusTag 		=> $args{-locusTag},
		-colour 		=> $args{-colour},
		-note 			=> $args{-note},
		-orientation 	=> $args{-orientation},
		-product 		=> $args{-product}
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createMisc {
	
	my ($self, %args) = @_;
	
	return Kea::IO::Feature::_Feature->new(
		-parent 	=> $args{-parent},
		-name 		=> "misc_feature",
		-gene 		=> $args{-gene},
		-locations 	=> $args{-locations},
		-colour 	=> $args{-colour},
		-note 		=> $args{-note},
		-orientation 	=> $args{-orientation}
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createGap {
	
	my $self = shift;
	my %args = @_;
	
	return Kea::IO::Feature::_Feature->new(
		-parent 			=> $args{-parent},
		-name 				=> "gap",
		-estimatedLength	=> $args{-estimatedLength},
		-locations 			=> $args{-locations},
		-colour 			=> $args{-colour},
		-note 				=> $args{-note}
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createRepeatRegion {
	
	my $self = shift;
	my %args = @_;
	
	return Kea::IO::Feature::_Feature->new(
		-parent 	=> $args{-parent},
		-name 		=> "repeat_region",
		-rptFamily	=> $args{-rptFamily},
		-locations 	=> $args{-locations},
		-colour 	=> $args{-colour},
		-note 		=> $args{-note},
		-orientation 	=> $args{-orientation}
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createSnp {
	
	my $self = shift;
	my %args = @_;
	
	return Kea::IO::Feature::_Feature->new(
		-parent 			=> $args{-parent},
		-name 				=> "snp",
		-locations 			=> $args{-locations},
		-colour 			=> $args{-colour},
		-note 				=> $args{-note}
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createUTRS {
	
	my $self = shift;
	my %args = @_;
	
	return Kea::IO::Feature::_Feature->new(
		-parent 		=> $args{-parent},
		-name 			=> "UTRS",
		-gene 			=> $args{-gene},
		-locations 		=> $args{-locations},
		-colour 		=> $args{-colour},
		-note 			=> $args{-note},
		-orientation 	=> $args{-orientation}
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createTU {
	
	my $self = shift;
	my %args = @_;
	
	return Kea::IO::Feature::_Feature->new(
		-parent 		=> $args{-parent},
		-name 			=> "TU",
		-gene 			=> $args{-gene},
		-locations 		=> $args{-locations},
		-colour 		=> $args{-colour},
		-note 			=> $args{-note},
		-orientation 	=> $args{-orientation}
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createPseudogene {
	
	my $self = shift;
	my %args = @_;
	
	return Kea::IO::Feature::_Feature->new(
		-parent 	=> $args{-parent},
		-name 		=> "pseudo",
		-gene 		=> $args{-gene},
		-locations 	=> $args{-locations},
		-colour 	=> $args{-colour},
		-note 		=> $args{-note},
		-orientation 	=> $args{-orientation}
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createSource {
	my ($self, %args) = @_;
	
	return Kea::IO::Feature::_Feature->new(
		-parent 		=> $args{-parent},
		-name 			=> "source",
		-organism 		=> $args{-organism},
		-locations 		=> $args{-locations},
		-strain 		=> $args{-strain},
		-molType 		=> $args{-molType},
		-note 			=> $args{-note},
		-dbXref 		=> $args{-dbXref},
		-colour 		=> $args{-colour}
		);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createRepOrigin {
	
	my $self = shift;
	my %args = @_;
	
	return Kea::IO::Feature::_Feature->new(
		-parent 		=> $args{-parent},
		-name 			=> "rep_origin",
		-locations 		=> $args{-locations},
		-note 			=> $args{-note},
		-colour 		=> $args{-colour},
		-direction		=> $args{-direction},
		-standardName	=> $args{-standardName}
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createIntron {
	
	my $self = shift;
	my %args = @_;
	
	return Kea::IO::Feature::_Feature->new(
		-parent 		=> $args{-parent},
		-name 			=> "intron",
		-locations 		=> $args{-locations},
		-note 			=> $args{-note},
		-colour 		=> $args{-colour},
		-gene			=> $args{-gene},
		-number			=> $args{-number}
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createMiscBinding {
		
	my $self = shift;
	my %args = @_;
	
	return Kea::IO::Feature::_Feature->new(
		-parent 		=> $args{-parent},
		-name 			=> "misc_binding",
		-locations 		=> $args{-locations},
		-boundMoiety	=> $args{-boundMoiety},
		-note 			=> $args{-note}
		);
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createNcRNA {
	
	my $self = shift;
	my %args = @_;
	
	return Kea::IO::Feature::_Feature->new(
		-parent 		=> $args{-parent},
		-name 			=> "ncRNA",
		-locations 		=> $args{-locations},
		-ncRNAClass		=> $args{-ncRNAClass},
		-note 			=> $args{-note},
		-locusTag		=> $args{-locusTag}
		);
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub createSigPeptide {
	
	my $self = shift;
	my %args = @_;
	
	return Kea::IO::Feature::_Feature->new(
		-parent 	=> $args{-parent},
		-name 		=> "sig_peptide",
		-locations 	=> $args{-locations},
		-orientation 	=> $args{-orientation},
		-note 		=> $args{-note}
		);
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub createStemLoop {
	
	my $self = shift;
	my %args = @_;
	
	return Kea::IO::Feature::_Feature->new(
		-parent 	=> $args{-parent},
		-name 		=> "stem_loop",
		-orientation 	=> $args{-orientation},
		-locations 	=> $args{-locations}
		);
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub  createTerminator {
	
	my $self = shift;
	my %args = @_;
	
	return Kea::IO::Feature::_Feature->new(
		-parent 	=> $args{-parent},
		-name 		=> "terminator",
		-note 		=> $args{-note},
		-orientation 	=> $args{-orientation},
		-locations 	=> $args{-locations}
		);
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub  createTmRNA {
	
	my $self = shift;
	my %args = @_;
	
	return Kea::IO::Feature::_Feature->new(
		-name 		=> "tmRNA",
		-parent 	=> $args{-parent},
		-gene 		=> $args{-gene},
		-product	=> $args{-product},
		-locusTag	=> $args{-locusTag},
		-note 		=> $args{-note},
		-orientation 	=> $args{-orientation},
		-locations 	=> $args{-locations}
		);
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub  createMinus35Signal {
	
	my $self = shift;
	my %args = @_;
	
	return Kea::IO::Feature::_Feature->new(
		-parent 	=> $args{-parent},
		-name 		=> "-35_signal",
		-orientation 	=> $args{-orientation},
		-locations 	=> $args{-locations}
		);
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub  createMinus10Signal {
	
	my $self = shift;
	my %args = @_;
	
	return Kea::IO::Feature::_Feature->new(
		-parent 	=> $args{-parent},
		-name 		=> "-10_signal",
		-orientation 	=> $args{-orientation},
		-locations 	=> $args{-locations}
		);
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub  createVariation {
	
	my $self = shift;
	my %args = @_;
	
	return Kea::IO::Feature::_Feature->new(
		-parent 		=> $args{-parent},
		-name 			=> "variation",
		-locations 		=> $args{-locations},
		-locusTag		=> $args{-locusTag},
		-note 			=> $args{-note},
		-experiment		=> $args{-experiment}
		);
	
	} #ÊEnd of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

