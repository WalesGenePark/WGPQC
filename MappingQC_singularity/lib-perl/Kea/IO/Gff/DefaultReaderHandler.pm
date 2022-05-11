#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 21/04/2008 14:26:49
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
package Kea::IO::Gff::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::Gff::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::Gff::IReaderHandler);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant UNKNOWN	=> "unknown";
use constant GAP		=> "-";

use Kea::IO::Location;
use Kea::IO::Gff::GffRecordCollection;
use Kea::IO::Gff::GffRecordFactory;
use Kea::IO::Gff::GffFeatureFactory;
use Kea::AttributesFactory;
use Kea::Sequence::SequenceFactory;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	
	my $className = shift;
	
	my $gffRecordCollection = Kea::IO::Gff::GffRecordCollection->new("");
	
	my $self = {
		
		_gffRecordCollection 	=> $gffRecordCollection,
	
		_recordHash				=> {},
		_featureHash 			=> {},
		
		_version	 			=> undef,
		_featureOntologyURI 	=> undef,
		_attributeOntologyURI	=> undef
		};
	bless(
		$self,
		$className
		);
	return $self;
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $processLineAsRecord = sub {
	
	my $self 		= shift;
	my $gffRecord 	= $self->check(shift, "Kea::IO::Gff::IGffRecord");
	my $location 	= $self->check(shift, "Kea::IO::Location");
	my $orientation = $self->checkIsOrientation(shift);
	my $attributes 	= $self->check(shift, "Kea::IAttributes");
	
	my $source 		= shift;
	my $feature 	= shift;
	my $score 		= shift;
	my $frame 		= shift;
	
	$gffRecord->setSource($source);
	$gffRecord->setFeature($feature);
	$gffRecord->setScore($score);
	$gffRecord->setOrientation($orientation);
	$gffRecord->setFrame($frame);
	$gffRecord->setAttributes($attributes);
	
	# Check that location agrees with what is already stored.
	if (!$gffRecord->getLocation->equals($location)) {
		$self->throw(
			"Location (" . $location->toString . 
			") does not agree with earlier (" .
			$gffRecord->getLocation->toString . 
			") for '" .
			$gffRecord->getPrimaryAccession . 
			"'."
			);
		}
	
	$self->{_gffRecordCollection}->add($gffRecord);
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $processLineAsFeature = sub {
	
	my $self 		= shift;
	my $id 			= $self->check(shift);
	my $gffRecord 	= $self->check(shift, "Kea::IO::Gff::IGffRecord");
	my $location 	= $self->check(shift, "Kea::IO::Location");
	my $orientation = $self->checkIsOrientation(shift);
	my $attributes 	= $self->check(shift, "Kea::IAttributes");
	
	my $source 		= shift;
	my $feature 	= shift;
	my $score 		= shift;
	my $frame 		= shift;
	
	my $gffFeature = Kea::IO::Gff::GffFeatureFactory->createGffFeature(
		-id => $id 
		);
	
	# Store in temp hash for later rapid access.
	push(
		@{$self->{_featureHash}->{$id}},
		$gffFeature
		);
	
	$gffFeature->setLocation($location);
	$gffFeature->setParent($gffRecord);
	$gffFeature->setSource($source);
	$gffFeature->setFeature($feature);
	$gffFeature->setScore($score);
	$gffFeature->setOrientation($orientation);
	$gffFeature->setFrame($frame);
	$gffFeature->setAttributes($attributes);
	
	$gffRecord->getGffFeatureCollection->add($gffFeature);
	
	
	}; # end of method.

################################################################################

# PUBLIC METHODS

sub _version {
	
	my $self 	= shift;
	my $version = $self->checkIsInt(shift);
	
	$self->{_version} = $version;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _featureOntology {
	
	my $self 				= shift;
	my $featureOntologyURI 	= shift;
	
	$self->{_featureOntologyURI} = $featureOntologyURI;
	
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub _attributeOntology {
	
	my $self 					= shift;
	my $attributeOntologyURI 	= shift;
	
	$self->{_attributeOntologyURI} = $attributeOntologyURI;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextSequenceRegion {
	
	my $self 				= shift;
	my $primaryAccession 	= shift;
	my $start 				= shift;
	my $end 				= shift;
	
	my $gffRecord = Kea::IO::Gff::GffRecordFactory->createGffRecord(
		-primaryAccession => $primaryAccession
		);
	
	$gffRecord->setFeatureOntologyURI($self->{_featureOntologyURI});
	$gffRecord->setAttributeOntologyURI($self->{_attributeOntologyURI});
	
	$gffRecord->setLocation(Kea::IO::Location->new($start, $end));
	
	# Store in temp hash for later rapid access.
	$self->{_recordHash}->{$primaryAccession} = $gffRecord;
		
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextLine {

	my (
		$self,
		$primaryAccession,		# seqname
		$source,				# source
		$feature, 				# feature
		$start,					# start
		$end,					# end
		$score,					# score
		$strand,				# strand
		$frame,					# frame
		$attributesString		# flexible list of key-value pairs separated by semicolons
		) = @_;
	
	# Process further...
	#===========================================================================
	
	my $attributes = Kea::AttributesFactory->createAttributes($attributesString);
	
	my $id;
	if ($attributes->has("ID")) {
		$id = $attributes->get("ID");
		}
	else {
		$self->throw("Could not locate ID attribute for '$primaryAccession'.");
		}
	
	my $location = Kea::IO::Location->new($start, $end);
	
	my $orientation;
	if ($strand eq "+") {
		$orientation = SENSE;
		}
	elsif ($strand eq "-") {
		$orientation = ANTISENSE;
		}
	elsif ($strand eq ".") {
		$orientation = UNKNOWN;
		}
	else {
		$self->throw("Unrecognised character: $strand.");
		}
	
	#===========================================================================
	
	
	
	# Get record object associated with line.
	my $gffRecord = $self->{_recordHash}->{$primaryAccession};
	
	if (!defined $gffRecord) {
		$self->throw("No record available for primary accession: $primaryAccession.\n");
		}
	
	#ÊDecide whether line refers to a feature object within the record or the
	# record itself.
	#===========================================================================
	
	# Firstly, does location match that of record?
	if ($gffRecord->getLocation->equals($location)) {
		
		# Looks like next line DOES refer to record but check attributes to make
		# sure.
		if ($id eq $primaryAccession) {
			# Process as record.
			$self->$processLineAsRecord(
			
				$gffRecord,
				$location,
				$orientation,
				$attributes,
				
				$source,
				$feature,
				$score,
				$frame
				);
			}
		else {
			$self->throw(
				"Location [" . $location->toString . 
				"] suggests line refers to gff record ' . $primaryAccession . 
				', yet id '" . $id . 
				"' does not agree."
				);
			}
		
		}
	# Location suggests a feature within the record.
	elsif (
		$location->getStart >= $gffRecord->getLocation->getStart &&
		$location->getEnd <= $gffRecord->getLocation->getEnd
		) {
		# Process as feature.
		$self->$processLineAsFeature(
			
			$id,
			$gffRecord,
			$location,
			$orientation,
			$attributes,
	
			$source,
			$feature,
			$score,
			$frame
			
			);
		} 
	else {
		$self->throw(
			"'$id' appears to be a feature of record '$primaryAccession' yet " .
			"its location (" . $location->toString . 
			") does not agree with record location (" .
			$gffRecord->getLocation->toString . 
			")."
			);
		}
	
	
	#===========================================================================
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextHeader {
	
	my $self = shift;
	my $header = $self->check(shift);
	
	$self->{_currentHeader} = $header;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextSequence {
	
	my $self = shift;
	
	my $sequence = $self->check(shift);
	my $header = $self->{_currentHeader};
	
	my $recordHash = $self->{_recordHash};
	my $featureHash = $self->{_featureHash};
	
	if (exists $recordHash->{$header}) {
		my $gffRecord = $recordHash->{$header};
		$gffRecord->setSequence($sequence);
		}
	
	elsif (exists $featureHash->{$header}) {
		
		my $gffFeature = $featureHash->{$header}->[0];
		my $gffRecord = $gffFeature->getParent;
		
		
		# Remove any stop codons '*'
		$sequence =~ s/\*$//;
		
		$gffRecord->getTranslationSequenceCollection->add(
			Kea::Sequence::SequenceFactory->createSequence(
				-id => $header,
				-sequence => $sequence
				)
			);
		
		}
	else {
		$self->throw("No record or feature found for id '$header'.");
		}
	
	# Just in case...
	$self->{_currentHeader} = undef;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////

sub getGffRecord {
	
	my $self = shift;
	
	my @recordArray = keys %{$self->{_recordHash}};
	
	if (@recordArray > 1) {
		$self->throw(
			"Expecting single gff record but found " . @recordArray. "."
			);
		}
	
	return $self->{_recordHash}->{$recordArray[0]};
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getGffRecordCollection {
	
	my $self = shift;
	
	my $gffRecordCollection = $self->{_gffRecordCollection};

	my $version	 				= $self->{_version};
	my $featureOntologyURI		= $self->{_featureOntologyURI};
	my $attributeOntologyURI	= $self->{_attributeOntologyURI};
	


	$gffRecordCollection->setVersion($version) 
		if (defined $version);
	
	$gffRecordCollection->setFeatureOntologyURI($featureOntologyURI)
		if (defined $featureOntologyURI);

	$gffRecordCollection->setAttributeOntologyURI($attributeOntologyURI)
		if (defined $attributeOntologyURI);
	
	
	
	return $gffRecordCollection;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

