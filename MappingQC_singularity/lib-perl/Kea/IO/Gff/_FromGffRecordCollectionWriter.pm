#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 21/04/2008 16:03:34
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
package Kea::IO::Gff::_FromGffRecordCollectionWriter;
use Kea::Object;
use Kea::IO::IWriter;
our @ISA = qw(Kea::Object Kea::IO::IWriter);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant UNKNOWN 	=> "unknown";
use constant GAP		=> "-";

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $gffRecordCollection =
		Kea::Object->check(
			shift,
			"Kea::IO::Gff::GffRecordCollection"
			);
	
	my $self = {
		_gffRecordCollection => $gffRecordCollection
		};
	
	bless(
		$self,
		$className
		);
	
	return $self;
	
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $formatSequence = sub {

	my $self 		= shift;
	my $FILEHANDLE 	= $self->check(shift);
	my $header 		= $self->check(shift);
	my $sequence 	= $self->check(shift);
	
	my $text = ">$header\n";
	
	# Dice sequence into 60 character chunks
		for (my $i = 0; $i < length($sequence); $i = $i + 60) {
			my $block = substr($sequence, $i, 60);
			$text .= $block . "\n";
			}
	
	print $FILEHANDLE $text or $self->throw("Could not print to outfile.");
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub write {

	my $self 				= shift;
	my $FILEHANDLE 			= $self->check(shift);
	my $gffRecordCollection = $self->{_gffRecordCollection};
	
	my $text = "##gff-version\t3\n";
	$text .= "##feature-ontology\t" . $gffRecordCollection->getFeatureOntologyURI . "\n";
	$text .= "##attribute-ontology\t" . $gffRecordCollection->getAttributeOntologyURI . "\n";
	
	print $FILEHANDLE $text or $self->throw("Could not print to outfile.");
	
	
	
	# First print metadata.
	#===========================================================================
	
	for (my $i = 0; $i < $gffRecordCollection->getSize; $i++) {
		my $gffRecord = $gffRecordCollection->get($i);
		
		printf $FILEHANDLE (
			"##sequence-region\t%s\t%d\t%d\n",
			$gffRecord->getPrimaryAccession,
			$gffRecord->getLocation->getStart,
			$gffRecord->getLocation->getEnd
			) or $self->throw("Could not print to outfile.");	
		
		}
	
	#===========================================================================
	
	
	
	# Next print record data.
	#===========================================================================
	
	for (my $i = 0; $i < $gffRecordCollection->getSize; $i++) {
		my $gffRecord = $gffRecordCollection->get($i);
		
		my $orientation = $gffRecord->getOrientation;
		my $strand;
		if ($orientation eq SENSE) {$strand = "+";}
		elsif ($orientation eq ANTISENSE) {$strand = "-";}
		elsif ($orientation eq UNKNOWN) {$strand = ".";}
		else {
			$self->throw("Unrecognised orientation: $orientation.");		
			}
		
		printf $FILEHANDLE (
			"%s\t%s\t%s\t%d\t%d\t%s\t%s\t%s\t%s\n",
			$gffRecord->getPrimaryAccession,
			$gffRecord->getSource,
			$gffRecord->getFeature,
			$gffRecord->getLocation->getStart,
			$gffRecord->getLocation->getEnd,
			$gffRecord->getScore,
			$strand,
			$gffRecord->getFrame,
			$gffRecord->getAttributes->toString
			) or $self->throw("Could not print to outfile.");	
		
		}
	
	#===========================================================================
	
	
	
	
	# Next print feature data.
	#===========================================================================
	
	for (my $i = 0; $i < $gffRecordCollection->getSize; $i++) {
		
		my $gffRecord = $gffRecordCollection->get($i);
		my $gffFeatureCollection = $gffRecord->getGffFeatureCollection;
		
		for (my $j = 0; $j < $gffFeatureCollection->getSize; $j++) {
			my $gffFeature = $gffFeatureCollection->get($j);
			
			my $orientation = $gffFeature->getOrientation;
			my $strand;
			if ($orientation eq SENSE) {$strand = "+";}
			elsif ($orientation eq ANTISENSE) {$strand = "-";}
			elsif ($orientation eq UNKNOWN) {$strand = ".";}
			else {
				$self->throw("Unrecognised orientation: $orientation.");		
				}
			
			printf $FILEHANDLE (
				"%s\t%s\t%s\t%d\t%d\t%s\t%s\t%s\t%s\n",
				$gffRecord->getPrimaryAccession,
				$gffFeature->getSource,
				$gffFeature->getFeature,
				$gffFeature->getLocation->getStart,
				$gffFeature->getLocation->getEnd,
				$gffFeature->getScore,
				$strand,
				$gffFeature->getFrame,
				$gffFeature->getAttributes->toString
				) or $self->throw("Could not print to outfile.");	
			
			}
		
		}
	
	
	print $FILEHANDLE "##FASTA\n" or
		$self->throw("Could not print to outfile.");
	
	#===========================================================================
	
	# Next print translations for features
	#===========================================================================
	
	for (my $i = 0; $i < $gffRecordCollection->getSize; $i++) {
		
		my $gffRecord = $gffRecordCollection->get($i);
		my $sequenceCollection = $gffRecord->getTranslationSequenceCollection;	
		
		for (my $j = 0; $j < $sequenceCollection->getSize; $j++) {
			my $sequence = $sequenceCollection->get($j);
			$self->$formatSequence(
				$FILEHANDLE,
				$sequence->getID,
				$sequence->getSequence
				);
			}
		
		}
	
	#===========================================================================
	
	
	# Finally print dna sequence for records.
	#===========================================================================
	
	for (my $i = 0; $i < $gffRecordCollection->getSize; $i++) {
		my $gffRecord = $gffRecordCollection->get($i);
		
		my $header = $gffRecord->getPrimaryAccession;
		my $sequence = $gffRecord->getSequence;
		
		$self->$formatSequence($FILEHANDLE, $header, $sequence);
		
		}
	
	#===========================================================================
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

