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
package Kea::ORF::Glimmer::_Glimmer3Iterated;
use Kea::Object;
use Kea::ORF::Glimmer::IGlimmer;
our @ISA = qw(Kea::Object Kea::ORF::Glimmer::IGlimmer);

use strict;
use warnings;

use constant TRUE 			=> 1;
use constant FALSE 			=> 0;
use constant SENSE 			=> "sense";
use constant ANTISENSE 		=> "antisense";

use constant TEMP_FILE 		=> "TMP_glimmer.fas";
use constant OUTFILE_TAG	=> "TMP_glimmer";

use Kea::IO::Fasta::WriterFactory;
use Kea::IO::Glimmer::PredictFile::DefaultReaderHandler;
use Kea::IO::Glimmer::PredictFile::ReaderFactory;
use Kea::IO::Glimmer::ORFCollection;
use Kea::IO::Glimmer::ORF;
use Kea::ThirdParty::Glimmer::_Glimmer3IteratedWrapper;
use Kea::IO::Feature::FeatureFactory;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className 	= shift;
	my $record 		= Kea::Object->check(shift, "Kea::IO::IRecord");
	
	my $self = {_record => $record};
	
	bless(
		$self,
		$className
		);
	
	return $self;
	
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $getAccessionSuffix = sub {
	
	my $self = shift;
	my $accession = shift;
	
	# Return numerical end of accession number, if exists.
	if ($accession =~ /(\d+)$/) {
		return $1;
		}
	# Otherwise just return original accession.  also warn, as might not be
	# expecting this.
	else {
		
		$self->warn(
			"Numerical suffix could not be extracted from accession " .
			"'$accession'."
			);
	
		return $accession;
		}
	
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $nextORF = sub {

	my $self 		= shift;
	my $orf  		= $self->check(shift, "Kea::IO::Glimmer::ORF");
	my $orfNumber 	= $self->check(shift);
	
	
	# convert number to fixed 4 digit number.
	$orfNumber = sprintf("%04d", $orfNumber);

	my $record 			= $self->{_record};
	my $locusTagPrefix 	= $record->getLocusTagPrefix || "ORF";
	my $accession	 	= $record->getPrimaryAccession;
	
	# 02/03/2009 - new code added to explicitly state transltable value on
	# initially generating record objects prior to orf calling.  Decided to
	# enforce use of this value hence new exception message below - may need to
	# reassess if breaks too much code!
	my $translTable	= $record->getTranslTable ||
		$self->throw("transl_table not registered with record object.");
	
	# Attempt to use only accession numerical suffix if available, otherwise
	# use full accession.
	$accession = $self->$getAccessionSuffix($accession);
	
	# Create unique locus tag for orf (used by gene and CDS feature).
	my $locusTag = "$locusTagPrefix\_$accession$orfNumber";
	
	my $note =
		"$locusTag identified by Glimmer3 with a raw score of " . $orf->getRawScore . ".";
	
	my $cds = $record->getSubsequenceAt($orf->getLocation, $orf->getOrientation);
	
	if ($cds =~ /NNNNN/) { # TODO - improve this? - assumes all NNNNN due to contig-separator - may not be true!
		$note = $note . " and incomplete (located at contig end)";
		}
	
	
	# Convert to aa.
	my $utility = Kea::Utilities::CDSUtility->new(
		-showInformationMessages => FALSE
		);
	
	my $aa = $utility->translate(
		-sequence 			=> $cds,
		-ignoreStopCodon 	=> TRUE,
		-strict 			=> FALSE,
		-isBacterial 		=> TRUE,
		-code 				=> $locusTag # Just for information / error messages.
		);
	
	# Create feature.
	
	
	
	
	# Add feature to current feature collection.
	$record->addFeature(
		Kea::IO::Feature::FeatureFactory->createGene(
			#-gene 			=> $locusTag,	# For now, no gene id.
			-locusTag 		=> $locusTag, 
			-locations 		=> [Kea::IO::Location->new($orf->getStart, $orf->getEnd)],
			-note 			=> $note,
			-orientation	=> $orf->getOrientation
			)
		);
	
	
	
	
	# HARDCODING DBNAME (ashliver)!  MUST CHANGE IF CODE USED BY OTHERS.
	my $proteinId = "gnl|ashliver|$locusTag";
	
	print "Creating feature - $proteinId...\n";
	
	# Add feature to current feature collection.
	$record->addFeature(Kea::IO::Feature::FeatureFactory->createCDS(
			-proteinId		=> $proteinId,	
			-locusTag		=> $locusTag,  # Add locus_tag to link with gene, but shouldn't be displayed in genbank-compliant outfiles.
			-locations		=> [Kea::IO::Location->new($orf->getStart, $orf->getEnd)],
			-translation	=> $aa,
			-note 			=> $note,
			-codonStart 	=> 1,
			-translTable 	=> $translTable,
			-orientation 	=> $orf->getOrientation,
			-inference		=> "ab initio prediction:Glimmer:3"
			)
		);
	
	
	
	
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub run {

	my $self 	= shift;
	my $record = $self->{_record};
	
	# First create tmp fasta file for script.
	open (TMP , ">" . TEMP_FILE) or $self->throw("Could not create " . TEMP_FILE);
	my $writer = Kea::IO::Fasta::WriterFactory->createWriter($record);
	$writer->write(*TMP);
	close(TMP) or $self->throw("Could not close tmp file.");
	
	
	
	# Run g3-iterated.csh script.
	#===========================================================================
	
	my $glimmer = Kea::ThirdParty::Glimmer::_Glimmer3IteratedWrapper->new;
	$glimmer->run(
		TEMP_FILE,
		OUTFILE_TAG
		);
	
	#===========================================================================

	# Parse outfile
	
	my @orfCollections = Kea::IO::Glimmer::ORFCollection->new();
	# predict file only produced if orfs found therefore need to check first.
	my $predictFile = OUTFILE_TAG . ".predict";
	if (-e $predictFile) {
		open (IN, OUTFILE_TAG . ".predict") or
			$self->throw("Could not open " . OUTFILE_TAG . ".predict");
		my $handler = Kea::IO::Glimmer::PredictFile::DefaultReaderHandler->new;
		my $rf = Kea::IO::Glimmer::PredictFile::ReaderFactory->new;
		my $reader = $rf->createReader;
		$reader->read(*IN, $handler);
		close(IN) or $self->throw("Could not close predict file.");
		@orfCollections = $handler->getORFCollections;
		} 
	
	
	
	# Just in case.
	if (@orfCollections > 1) {
		$self->throw(
			"Method assumes a single orf collection, yet " .
			@orfCollections . " have been found"
			);
		}
	
	
	# Incorporate message into comments line of record object.
	my $comment = "";
	if ($record->hasComment) {
		$comment = $record->getComment;
		}
	
	if ($orfCollections[0]->getSize > 0) {
	
		my $numberOfOrfsDiscovered = $orfCollections[0]->getSize;
	
		$comment .= " $numberOfOrfsDiscovered ORFs were identified with glimmer3.";
		}
	else {
		$comment .= " No ORFs could be identified with glimmer3."
		}
	$record->setComment($comment);
	
	
	# write details to record object.
	for (my $i= 0; $i < $orfCollections[0]->getSize; $i++) {
		# Object representing identified orf:
		my $orf = $orfCollections[0]->get($i);
		# Write to outfile:
		$self->$nextORF(
			$orf,		# ORF object
			$i			# ORF number
			);
		}
	
	# Tidy up.
	unlink(TEMP_FILE);
	unlink(OUTFILE_TAG . ".predict");
	unlink(OUTFILE_TAG . ".detail");
	unlink(OUTFILE_TAG . ".motif");
	unlink(OUTFILE_TAG . ".coords");
	unlink(OUTFILE_TAG . ".run1.detail");
	unlink(OUTFILE_TAG . ".run1.predict");
	unlink(OUTFILE_TAG . ".upstream");
	unlink(OUTFILE_TAG . ".icm");
	unlink(OUTFILE_TAG . ".longorfs");
	unlink(OUTFILE_TAG . ".train");

	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

