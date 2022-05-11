#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 19/12/2008 16:31:36
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
package Kea::IO::XML::Tair8XML::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::XML::Tair8XML::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::XML::Tair8XML::IReaderHandler);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant UNKNOWN	=> "unknown";
use constant GAP		=> "-";

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
		_record 			=> undef,
		_cdsEnd5			=> undef,
		_cdsEnd3			=> undef,
		_cdsLocations 		=> undef,
		_cdsOrientations	=> undef,
		_utrsLocations 		=> undef,
		_utrsOrientations	=> undef,
		_modelPubLocus			=> undef,
		_translation		=> undef,
		_dnaSequence		=> undef
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

sub _pseudochromosomeStart {
	
	my $self = shift;
	
	$self->throw("Expecting only one record - Record object already defined")
		if (defined $self->{_record});
	
	$self->{_record} =
		Kea::IO::RecordFactory->createRecord(
			-primaryAccession => "blank"
			);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _pseudochromosomeEnd {
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _tuStart {
		
	#my $self = shift;
	#
	#$self->throw("Locations/orientation already defined.")
	#	if (defined $self->{_locations} || defined $self->{_orientations});	
		
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _tuEnd {
	
	my $self 					= shift;
	my $record 					= $self->{_record};
	my $tuLocations 			= $self->{_tuLocations};
	my $tuOrientations 			= $self->{_tuOrientations};
	my $tuPubLocus				= $self->{_tuPubLocus};
	my $isPseudogene			= $self->{_isPseudogene};
	
	
	$self->{_tuLocations}	 	= undef;
	$self->{_tuOrientations} 	= undef;
	$self->{_tuPubLocus} 		= undef;
	$self->{_isPseudogene}		= undef;
	
	
	if (defined $tuLocations) {
	
		my $tuFeature;
	
		if ($isPseudogene) {
			$tuFeature = Kea::IO::Feature::FeatureFactory->createPseudogene(
				-locations 		=> $tuLocations,
				-orientation 	=> $tuOrientations->[0],
				-gene	 		=> $tuPubLocus
				);
			}
		else {
			$tuFeature = Kea::IO::Feature::FeatureFactory->createTU(
				-locations 		=> $tuLocations,
				-orientation 	=> $tuOrientations->[0],
				-gene	 		=> $tuPubLocus
				);
			}	
		
		
	
		$record->addFeature($tuFeature);
		
		}
	

	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextTuIsPseudogene	{
	
	my $self = shift;
	my $isPseudogene = shift;
	
	if ($isPseudogene == 1) {
		$self->{_isPseudogene} = TRUE;
		}
	elsif ($isPseudogene == 0) {
		$self->{_isPseudogene} = FALSE;
		}
	else {
		$self->throw("Unexpected pseudogene value: $isPseudogene.");
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _modelStart	{
	
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _modelEnd {
	
	my $self = shift;
	
	my $cdsLocations 		= $self->{_cdsLocations};
	my $cdsOrientations 	= $self->{_cdsOrientations};
	my $record 				= $self->{_record};
	my $modelPubLocus		= $self->{_modelPubLocus};
	my $dnaSequence			= $self->{_dnaSequence};
	my $translation 		= $self->{_translation};
	
	$self->{_cdsLocations}	 	= undef;
	$self->{_cdsOrientations} 	= undef;
	$self->{_modelPubLocus} 	= undef;
	$self->{_translation}		= undef;
	$self->{_dnaSequence}		= undef;
	
	
	if (!defined $cdsLocations || !defined $translation) {
		$self->warn("Undefined locations for $modelPubLocus and no translation - pseudogene perhaps?");
		
		}
	
	else {
	
		my $cdsOrientation = $cdsOrientations->[0];
		foreach my $current (@$cdsOrientations) {
		
			if ($current eq UNKNOWN) {next;}
			
			elsif ($current ne $cdsOrientation && $cdsOrientation ne UNKNOWN) {
				$self->throw("$modelPubLocus has conflicting orientations: @$cdsOrientations.")
				}
			
			else {
				$cdsOrientation = $current;			
				}
			
			}
		
	
		my $feature = Kea::IO::Feature::FeatureFactory->createCDS(
			-locations 		=> $cdsLocations,
			-orientation 	=> $cdsOrientation,
			-locusTag 		=> $modelPubLocus,
			-proteinId		=> $modelPubLocus,
			-translation	=> $translation,
			-translTable 	=> 1,
			-colour			=> "0 255 0"
			);
		
		
		if ($feature->getSize != length($dnaSequence)) {
		
			my $msg =
				"$modelPubLocus: DNA sequence length (" .
				length($dnaSequence) .
				") does not match expectation (" .
				$feature->getSize .
				")";
		
			$self->warn("$msg.");
			
			$feature->appendToNote($msg);
			$feature->setColour("255 0 0");
			
			}
		$feature->setDNASequence($dnaSequence);
		
		
		if (length($translation)*3+3 != length($dnaSequence) ) {
			$self->throw("Translation length (" . length($translation) . ") does not agree with dna length (" . length($dnaSequence) . ").");
			}
		
		
		
		
		#print $feature->toString() . "\n";
		
		$record->addFeature(
			$feature
			);
		
		}
	
	
	

	
	#===========================================================================
	
	my $exonLocations 			= $self->{_exonLocations};
	my $exonOrientations 		= $self->{_exonOrientations};
	$self->{_exonLocations}	 	= undef;
	$self->{_exonOrientations} 	= undef;
	
	if (defined $exonLocations) {
	
		my $exonFeature = Kea::IO::Feature::FeatureFactory->createExon(
		-locations 		=> $exonLocations,
		-orientation 	=> $exonOrientations->[0],
		-locusTag 		=> $modelPubLocus
		);
	
		$record->addFeature($exonFeature);
		
		}
	

	
	#===========================================================================
	
	my $utrsLocations 			= $self->{_utrsLocations};
	my $utrsOrientations 		= $self->{_utrsOrientations};
	$self->{_utrsLocations}	 	= undef;
	$self->{_utrsOrientations} 	= undef;
	
	if (defined $utrsLocations) {
	
		my $utrsFeature = Kea::IO::Feature::FeatureFactory->createUTRS(
		-locations 		=> $utrsLocations,
		-orientation 	=> $utrsOrientations->[0],
		-colour			=> "0 0 255",
		-locusTag 		=> $modelPubLocus
		);
	
		$record->addFeature($utrsFeature);
		
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _exonStart	{
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _exonEnd {
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _cdsStart {
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _cdsEnd {
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _utrsStart {
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _utrsEnd {
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _tuCoordsetStart {
	
	my $self = shift;
	
	$self->throw("End5/End3 already defined")
		if (defined $self->{_tuEnd5} || defined $self->{_tuEnd3});
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _tuCoordsetEnd {
	
	my $self = shift;
	
	my $end3 = $self->{_tuEnd3};
	my $end5 = $self->{_tuEnd5};
	
	my $location = undef;
	my $orientation = undef;
	
	if ($end5 < $end3) {
		$location = Kea::IO::Location->new($end5, $end3);
		$orientation = SENSE;
		}
	elsif ($end5 > $end3) {
		$location = Kea::IO::Location->new($end3, $end5);
		$orientation = ANTISENSE;
		}
	
	else {
		$location = Kea::IO::Location->new($end5, $end3);
		$orientation = UNKNOWN;
		}
	
	
	
	push(@{$self->{_tuLocations}}, $location);
	push(@{$self->{_tuOrientations}}, $orientation);
	
	
	$self->{_tuEnd3} = undef;
	$self->{_tuEnd5} = undef;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _exonCoordsetStart {
	
	my $self = shift;
	
	$self->throw("End5/End3 already defined")
		if (defined $self->{_exonEnd5} || defined $self->{_exonEnd3});
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _exonCoordsetEnd {
	
	my $self = shift;
	
	my $end3 = $self->{_exonEnd3};
	my $end5 = $self->{_exonEnd5};
	
	my $location = undef;
	my $orientation = undef;
	
	if ($end5 < $end3) {
		$location = Kea::IO::Location->new($end5, $end3);
		$orientation = SENSE;
		}
	elsif ($end5 > $end3) {
		$location = Kea::IO::Location->new($end3, $end5);
		$orientation = ANTISENSE;
		}
	
	else {
		$location = Kea::IO::Location->new($end5, $end3);
		$orientation = UNKNOWN;
		}
	
	
	
	push(@{$self->{_exonLocations}}, $location);
	push(@{$self->{_exonOrientations}}, $orientation);
	
	
	$self->{_exonEnd3} = undef;
	$self->{_exonEnd5} = undef;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _utrsCoordsetStart {
	
	my $self = shift;
	
	$self->throw("End5/End3 already defined")
		if (defined $self->{_utrsEnd5} || defined $self->{_utrsEnd3});
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _utrsCoordsetEnd {
	
	my $self = shift;
	
	my $end3 = $self->{_utrsEnd3};
	my $end5 = $self->{_utrsEnd5};
	
	my $location = undef;
	my $orientation = undef;
	
	if ($end5 < $end3) {
		$location = Kea::IO::Location->new($end5, $end3);
		$orientation = SENSE;
		}
	elsif ($end5 > $end3) {
		$location = Kea::IO::Location->new($end3, $end5);
		$orientation = ANTISENSE;
		}
	
	else {
		$location = Kea::IO::Location->new($end5, $end3);
		$orientation = UNKNOWN;
		}
	
	
	
	push(@{$self->{_utrsLocations}}, $location);
	push(@{$self->{_utrsOrientations}}, $orientation);
	
	
	$self->{_utrsEnd3} = undef;
	$self->{_utrsEnd5} = undef;

	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _cdsCoordsetStart {
	
	my $self = shift;
	
	$self->throw("End5/End3 already defined")
		if (defined $self->{_cdsEnd5} || defined $self->{_cdsEnd3});
	
	 
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _cdsCoordsetEnd {
	
	my $self = shift;
	
	my $end3 = $self->{_cdsEnd3};
	my $end5 = $self->{_cdsEnd5};
	
	my $location = undef;
	my $orientation = undef;
	
	if ($end5 < $end3) {
		$location = Kea::IO::Location->new($end5, $end3);
		$orientation = SENSE;
		}
	elsif ($end5 > $end3) {
		$location = Kea::IO::Location->new($end3, $end5);
		$orientation = ANTISENSE;
		}
	
	else {
		$location = Kea::IO::Location->new($end5, $end3);
		$orientation = UNKNOWN;
		}
	
	
	
	push(@{$self->{_cdsLocations}}, $location);
	push(@{$self->{_cdsOrientations}}, $orientation);
	
	
	$self->{_cdsEnd3} = undef;
	$self->{_cdsEnd5} = undef;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextCdsEnd5 {
	
	my $self = shift;
	my $end5 = shift;
	
	$self->throw("End5 already defined") if (defined $self->{_cdsEnd5});
	
	$self->{_cdsEnd5} = $end5;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextCdsEnd3 {
	
	my $self = shift;
	my $end3 = shift;
	
	$self->throw("End3 already defined") if (defined $self->{_cdsEnd3});
	
	$self->{_cdsEnd3} = $end3;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextUtrsEnd5 {
	
	my $self = shift;
	my $end5 = shift;
	
	$self->throw("End5 already defined") if (defined $self->{_utrsEnd5});
	
	$self->{_utrsEnd5} = $end5;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextUtrsEnd3 {
	
	my $self = shift;
	my $end3 = shift;
	
	$self->throw("End3 already defined") if (defined $self->{_utrsEnd3});
	
	$self->{_utrsEnd3} = $end3;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextExonEnd5 {
	
	my $self = shift;
	my $end5 = shift;
	
	$self->throw("End5 already defined") if (defined $self->{_exonEnd5});
	
	$self->{_exonEnd5} = $end5;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextExonEnd3 {
	
	my $self = shift;
	my $end3 = shift;
	
	$self->throw("End3 already defined") if (defined $self->{_exonEnd3});
	
	$self->{_exonEnd3} = $end3;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextTuEnd5 {
	
	my $self = shift;
	my $end5 = shift;
	
	$self->throw("End5 already defined") if (defined $self->{_tuEnd5});
	
	$self->{_tuEnd5} = $end5;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextTuEnd3 {
	
	my $self = shift;
	my $end3 = shift;
	
	$self->throw("End3 already defined") if (defined $self->{_tuEnd3});
	
	$self->{_tuEnd3} = $end3;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextExonFeatureName {
	
	my $self = shift;
	my $string = shift;
	
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextCdsFeatureName {
	
	my $self = shift;
	my $string = shift;
	
	
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextModelFeatureName {
	
	my $self = shift;
	my $string = shift;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextModelPubLocus {
	
	my $self = shift;
	my $string = shift;
	
	$self->throw(
		"MODEL PubLocus already defined: old=" . $self->{_modelPubLocus} . ", new=$string"
		)
		if (defined $self->{_modelPubLocus});
	
	$self->{_modelPubLocus} = $string;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextTuFeatureName {
	
	my $self = shift;
	my $string = shift;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextTuPubLocus {
	
	my $self = shift;
	my $string = shift;
	
	$self->throw(
		"TU PubLocus already defined: old=" . $self->{_tuPubLocus} . ", new=$string"
		)
		if (defined $self->{_tuPubLocus});
	
	$self->{_tuPubLocus} = $string;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextProteinSequence {
	
	my $self = shift;
	my $translation = shift;
	
	$self->throw("Translation already defined.")
		if (defined $self->{_translation});
	
	$self->{_translation} = $translation;
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextCdsSequence {
	
	my $self = shift;
	my $dnaSequence = shift;
	
	$self->throw("DNA sequence already defined.")
		if (defined $self->{_dnaSequence});
	
	$self->{_dnaSequence} = $dnaSequence;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getRecord {

	my $self = shift;
	my $primaryAccession = shift;
	
	if (!defined $primaryAccession) {
		$self->throw("Expecting primary accession to be provided as string.");
		} 
	
	my $record = $self->{_record};
	$record->setPrimaryAccession($primaryAccession);
	
	return $record;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

