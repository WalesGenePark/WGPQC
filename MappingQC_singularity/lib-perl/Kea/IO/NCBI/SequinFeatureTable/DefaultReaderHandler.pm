#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 12/02/2009 11:00:30
#    Copyright (C) 2009, University of Liverpool.
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
package Kea::IO::NCBI::SequinFeatureTable::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::NCBI::SequinFeatureTable::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::NCBI::SequinFeatureTable::IReaderHandler);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use constant GENE			=> "gene";
use constant LOCUS_TAG		=> "locus_tag";
use constant CODON_START	=> "codon_start";	
use constant PROTEIN_ID		=> "protein_id";
use constant PRODUCT		=> "product";
use constant NOTE			=> "note";
use constant NUMBER			=> "number";
use constant PSEUDO			=> "pseudo";
use constant TRANSL_TABLE	=> "transl_table";
use constant MOL_TYPE		=> "mol_type";
use constant DB_XREF		=> "db_xref";
use constant PUBMED			=> "PubMed";
use constant PROT_DESC		=> "prot_desc";

use Kea::IO::RecordFactory;
use Kea::IO::Feature::FeatureFactory;
use Kea::IO::Location;


################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $self = {
		_record 		=> undef,
		_currentFeature	=> undef
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

sub _nextHeader {
	
	my $self = shift;
	my $seqId = $self->check(shift);
	my $tableName = shift || undef;
	
	# Yet to accommodate table_name info in record therefore throw exception:
	if (defined $tableName) {
		$self->throw(
			"Feature table includes table_name '$tableName' in header - " .
			"yet to code for this!"
			);
		}
	
	
	if (defined $self->{_record}) {
		$self->throw("
			Trying to create record for $seqId but a " .
			"record object already exists."
			);
		}
	
	$self->{_record} = Kea::IO::RecordFactory->createRecord($seqId);
	
	} # End of method. 

#///////////////////////////////////////////////////////////////////////////////

sub _nextFeature {
	
	my $self = shift;
	
	my $arrow = shift || undef;
	my $start = shift;
	my $end = shift;
	my $featureName = shift;
	
	if (defined $arrow) {$self->warn("Yet to code for '$arrow'.");}
	
	my $feature = undef;
	
	my $location;
	my $orientation;
	if ($start <= $end) {
		$orientation = SENSE;
		$location = Kea::IO::Location->new($start, $end);
		}
	else {
		$orientation = ANTISENSE;
		$location = Kea::IO::Location->new($end, $start);
		}
	
	
	if ($featureName eq "REFERENCE") {
		$self->warn("Encountered feature REFERENCE, but yet to code for this.");
		return;
		}
	
	else {
		$feature = Kea::IO::Feature::FeatureFactory->create(
			-name 			=> $featureName,
			-locations 		=> [$location],
			-orientation 	=> $orientation
			);	
		}
	
			
	$self->{_currentFeature} = $feature;
	$self->{_record}->addFeature($feature);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextQualifier {
	
	my $self = shift;
	
	my $key = shift;
	my $value = shift;
	
	# Warn if qualifier already registered with current feature (qulaifiers
	# such as gene_syn may occur more than once per feature - however, since
	# this is not a problem likely to be faced in the short term, better to
	# merely warn of occurence rather than spend time on possibly redundant
	# coding...).
	if ($self->{_currentFeature}->hasQualifier($key)) {
		$self->warn(
			"Current feature already has a value for qualifier '$key' - "
			#. "new value: '$value'."
			);
		}
	
	
	$self->{_currentFeature}->setQualifier($key, $value);
	
	
	#
	#if 	  ($key eq PRODUCT) 		{$self->{_currentFeature}->setProduct($value);}
	#elsif ($key eq PSEUDO) 			{$self->{_currentFeature}->setPseudo($value);}
	#elsif ($key eq LOCUS_TAG) 		{$self->{_currentFeature}->setLocusTag($value);}
	#elsif ($key eq PROTEIN_ID) 		{$self->{_currentFeature}->setProteinId($value);}
	#elsif ($key eq CODON_START)		{$self->{_currentFeature}->setCodonStart($value);}	
	#elsif ($key eq TRANSL_TABLE) 	{$self->{_currentFeature}->setTranslTable($value);}
	#elsif ($key eq MOL_TYPE)		{$self->{_currentFeature}->setMolType($value);}
	#elsif ($key eq DB_XREF) 		{$self->{_currentFeature}->setDbXref($value);}
	#elsif ($key eq GENE)			{$self->{_currentFeature}->setGene($value);}
	#elsif ($key eq NOTE)			{$self->{_currentFeature}->setNote($value);}
	#elsif ($key eq NUMBER)			{$self->{_currentFeature}->setNumber($value);} 
	#elsif ($key	eq PROT_DESC)		{$self->{_currentFeature}->setProtDesc($value);}
	#
	#elsif ($key eq PUBMED) 		{$self->warn("Yet to code for PubMed entry ($value).");}
	#
	#else {
	#	$self->throw("Unexpected key: '$key'.");
	#	}
		
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextOffset {
	
	my $self = shift;
	my $offset = $self->checkIsInt(shift);
	
	$self->throw("Yet to code for offset ($offset).");
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextLocation {
	
	my $self = shift;
	my $start = $self->checkIsInt(shift);
	my $end = $self->checkIsInt(shift);
	
	my $location = undef;
	my $orientation = undef;
	if ($start <= $end) {
		$location = Kea::IO::Location->new($start, $end);
		$orientation = SENSE;
		} 
	else {
		$location = Kea::IO::Location->new($end, $start);
		$orientation = ANTISENSE;
		}	
			
	my $feature = $self->{_currentFeature};
	
	if ($feature->getOrientation ne $orientation) {
		$self->throw(
			$feature->getFeatureName .
			" feature has conflicting orientations."
			);
		}
	
	my @locations = $feature->getLocations;
	
	push(@locations, $location);
	@locations = sort {$a->getStart <=> $b->getStart} @locations;
	
	$feature->setLocations(\@locations);
			
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getRecord {
	
	my $self = shift;
	my $record = $self->{_record};
	
	return $record unless !defined $record;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

