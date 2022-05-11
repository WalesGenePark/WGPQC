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
package Kea::GeneFinder::Glimmer;
use Kea::Object;
our @ISA = qw(Kea::Object);

use strict;
use warnings;

use constant TRUE => 1;
use constant FALSE => 0;

use constant SENSE => "sense";
use constant ANTISENSE => "antisense";

use Kea::GeneFinder::Glimmer::BuildICM; 
use Kea::GeneFinder::Glimmer::Glimmer3;
use Kea::Parsers::Fasta::Parser;
use Kea::Parsers::Glimmer::PredictFile::Parser;
use Kea::IO::Feature::FeatureFactory;
use Kea::IO::RecordFactory;
use Kea::IO::Fasta::WriterFactory;
use Kea::IO::Location;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	my $className = shift;
	
	my %args = @_;
	
	my $self = {
		_strict => $args{-strict} || 0,
		_showInformationMessages => $args{-showInformationMessages} || 0
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

## Purpose		: Sets training data to be used by glimmer.
## Parameter	: SequenceCollection object.
sub setTrainingSet {
	my ($self, $sc) = @_;
	$self->{_trainingSet} = $sc;
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

# Purpose		: Sets sequence data (e.g. one or more contigs) to be analysed.
# Parameter		: SequenceCollection object.
sub setContigs {
	my ($self, $sc) = @_;
	$self->{_contigs} = $sc;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose		: Returns outcome of glimmer analysis as series of embl record objects, one record per contig.
## Return		: Array of Kea::IO::IRecord objects.
sub getRecords {
	return @{shift->{_records}};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose		: Runs glimmer program..
## Returns		: n/a.
## Parameter	: n/a.
## Throws		: n/a.
sub run {
	my $self = shift;
	
	my $trainingSequenceCollection = $self->{_trainingSet} or $self->throw("Training data has not been set.");
	my $contigSequenceCollection = $self->{_contigs} or $self->throw("Genome data to analyse has yet to be set.");
	
	# Construct temp files from supplied data.
	my $trainingFile = "training.tmp";
	open (TRAINING, ">$trainingFile") or die "ERROR: Could not open temp file.";
	my $wf = Kea::IO::Fasta::WriterFactory->new;
	my $writer = $wf->createWriter($trainingSequenceCollection);
	$writer->write(*TRAINING);
	close(TRAINING);
	
	my $icmFile = "icm.tmp";
	
	my $dataFile = "data.tmp";
	open(DATAFILE, ">$dataFile") or die "ERROR: Could not open temp file.";
	$writer = $wf->createWriter($contigSequenceCollection);
	$writer->write(*DATAFILE);
	close(DATAFILE);	
	
	my $buildIcm = Kea::GeneFinder::Glimmer::BuildICM->new;
	$buildIcm->run(
		-outfile => $icmFile,
		-training => $trainingFile
		);
	
	my $glimmer3 = Kea::GeneFinder::Glimmer::Glimmer3->new;
	
	my $tag = "tmp";
	
	$glimmer3->run(
		-in => $dataFile,
		-icm => $icmFile,
		-tag => $tag
		);
	
	open (PROFILE, "$tag.predict") or $self->throw("Could not open temp file $tag.predict.");
	
	# Parse predict file and create Record objects - one for each contig.	
	my $handler = Kea::GeneFinder::Glimmer::_Handler->new(
		$contigSequenceCollection,
		$self->{_showInformationMessages},
		$self->{_strict}
		);
	my $parser = Kea::Parsers::Glimmer::PredictFile::Parser->new;
	$parser->parse(*PROFILE, $handler);
	close(PROFILE);
	
	# Retrive created records from handler.	
	$self->{_records} = $handler->getRecords;
	
	# Delete tmp files.
#	unlink($dataFile);
#	unlink($icmFile);
#	unlink($trainingFile);
#	unlink("$tag.predict");
#	unlink("$tag.detail");
	
	} # End of method.

################################################################################

package Kea::GeneFinder::Glimmer::_Handler;
use strict;
use warnings;
use constant SENSE => "sense";
use constant ANTISENSE => "antisense";
use constant TRUE => 1;
use constant FALSE => 0;
use Kea::Utilities::CDSUtility;
use Kea::Parsers::Glimmer::PredictFile::AbstractHandler;
our @ISA = "Kea::Parsers::Glimmer::PredictFile::AbstractHandler";

sub new {
	my ($class, $contigSequenceCollection, $messages, $strict) = @_;
	my $self = {
		_data => $contigSequenceCollection,
		-showInformationMessages => $messages || 0,
		-strict => $strict || 0
		};
	bless($self, $class);
	return $self;
	}

sub getRecords {
	return shift->{_records};
	} # End of method.

sub nextHeader {
	my (
		$self,
		
		$contigID,		# Contig id, e.g. contig00001
		$length,		# Contig length.
		$numberOfReads	# Number of reads.
		) = @_;
	
	my $contigSequenceCollection = $self->{_data};
	
	$self->{_currentContig} = $contigSequenceCollection->getSequenceStringWithID($contigID);
	$self->{_currentHeader} = $contigID;
	
	# Create record object to represent current contig.
	my $record = Kea::IO::RecordFactory->createRecord($contigID);
	$record->setSequence($self->{_currentContig});
	
	push(@{$self->{_records}}, $record);
	$self->{_currentRecord} = $record;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub nextORF {
	my (
		$self,
		
		$geneID,			# orf code. e.g. orf00001 
		$startPosition,		# Start location within contig.
		$endPosition,		# End position within contig.
		$readingFrame,		# Reading frame: -3, -2, -1, +1, +2, +3
		$rawScore			# Raw score.
		) = @_;
	
	my $header = $self->{_currentHeader};
	my $contig = $self->{_currentContig};
	my $record = $self->{_currentRecord};
	
	# Get cds in sense orientation.
	my @coords = sort {$a <=> $b}($endPosition, $startPosition);
	my $length = $coords[1] - $coords[0] + 1;
	my $seq = substr($contig, $coords[0]-1, $length);
	if ($readingFrame < 0) {
		$seq = Kea::Utilities::CDSUtility->getReverseComplement($seq);
		};
	
	# Convert to aa.
	my $utility = Kea::Utilities::CDSUtility->new(
		-showInformationMessages => $self->{-showInformationMessages}
		);
	
	my $aa = $utility->translate(
		-sequence => $seq,
		-ignoreStopCodon => TRUE,
		-strict => $self->{-strict},
		-isBacterial => TRUE,
		-code => $geneID # Just for information / error messages.
		);
	
	my $orientation = SENSE; 
	my $start = $startPosition;
	my $end = $endPosition;
	if ($startPosition > $endPosition) {
		$start = $endPosition;
		$end = $startPosition;
		$orientation = ANTISENSE;
		}
	
	# Create feature.
	
	my $note = "identified by Glimmer3; putative";

	my $geneFeature = Kea::IO::Feature::FeatureFactory->createGene(
		-parent => $record,
		-gene => $geneID,
		-locusTag => $geneID,
		-locations => [Kea::IO::Location->new($start, $end)],
		-note => $note,
		-orientation => $orientation
		);
	
	# Add feature to current feature collection.
	$record->addFeature($geneFeature);
	
	my $cdsFeature = Kea::IO::Feature::FeatureFactory->createCDS(
		-parent => $record,
		-gene => $geneID,
		-proteinId => $geneID,
		-locusTag => $geneID,
		-locations => [Kea::IO::Location->new($start, $end)],
		-translation => $aa,
		-note => $note,
		-codonStart => 1,
		-translTable => 1,
		-orientation => $orientation
		);
	
	# Add feature to current feature collection.
	$record->addFeature($cdsFeature);
	
	} # End of method.

################################################################################

#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

