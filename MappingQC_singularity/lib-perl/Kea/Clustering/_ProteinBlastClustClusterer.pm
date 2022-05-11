#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 15/02/2008 16:55:52 
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


#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////

# CLASS NAME
package Kea::Clustering::_ProteinBlastClustClusterer;
use Kea::Object;
use Kea::Clustering::IClusterer;
our @ISA = qw(Kea::Object Kea::Clustering::IClusterer);

## Purpose		: 

use strict;
use warnings;
use Term::ANSIColor;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use Kea::ThirdParty::Blast::_BlastClustWrapper;
use Kea::Sequence::SequenceCollection;
use Kea::IO::Fasta::WriterFactory;
use Kea::IO::BlastClust::DefaultReaderHandler;
use Kea::IO::BlastClust::ReaderFactory;

use constant TMP_INFILE => "TMP_blastclust_infile.fas";
use constant TMP_OUTFILE => "TMP_blastclust_outfile.txt";

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

################################################################################

# PUBLIC METHODS

sub run {

	my $self = shift;
	my %args = @_;
	
	# Will cluster all cds.
	my $recordCollection =
		$self->check($args{-recordCollection}, "Kea::IO::RecordCollection");

	# Defined if copy of outfile required.	
	my $outfile = TMP_OUTFILE;
	if (exists $args{-outfile}) {
		$outfile = $args{-outfile};
		}
	
	#	Clustering protein only.
	my $protein = TRUE;

	
	#	-b <T|F> require coverage as specified by -L and -S on both (T) or
	#    only one (F) sequence of a pair (default = TRUE)
	my $bothStrands = TRUE;
	if (exists $args{-b}) {
		$bothStrands = $self->checkIsBoolean($args{-b});
		}
	
	#	 -S <threshold> similarity threshold
	#    if <3 then the threshold is set as a BLAST score density
	#    (0.0 to 3.0; default = 1.75)
	my $similarityThreshold = "1.75";
	if (exists $args{-S}) {
		$similarityThreshold = $self->checkIsNumberInRange($args{-S}, 0.0, 3.0);
		}
	
	#	-L <threshold> minimum length coverage (0.0 to 1.0; default = 0.9)
	my $minLengthCoverage = "0.9";
	if (exists $args{-L}) {
		$minLengthCoverage = $self->checkIsNumberInRange($args{-L}, 0.0, 1.0);
		}
	
	# Create single protein fasta file from cds features in record objects.
	#===========================================================================
	
	my $translations = Kea::Sequence::SequenceCollection->new("tmp");
	my $sf = Kea::Sequence::SequenceFactory->new;
	
	for (my $i = 0; $i < $recordCollection->getSize; $i++) {
		my $record = $recordCollection->get($i);
		my @features = $record->getCDSFeatures;
		
		foreach my $feature (@features) {
			$translations->add(
				$sf->createSequence(
					-id => $feature->getLocusTag,
					-sequence => $feature->getTranslation
					)
				);
			} # NO more features.
		
		} # End of record collection.
	
	my $infile = TMP_INFILE;
	open (OUT, ">$infile") or $self->throw("Could not write data to $infile.");
	my $writer = Kea::IO::Fasta::WriterFactory->createWriter($translations);
	$writer->write(*OUT);
	close (OUT) or $self->throw("Could not close $infile.");
	
	#===========================================================================
	
	
	my $blastClust = Kea::ThirdParty::Blast::_BlastClustWrapper->new;
	$blastClust->run(
		-i => $infile,
		-o => $outfile,
		-p => $protein,
		-b => $bothStrands,
		-S => $similarityThreshold,
		-L => $minLengthCoverage
		);
	
	
	
	
	
	#========
	# STEP 5
	#========
	
	# Create Clusters.
	#===========================================================================
	
	open(IN, $outfile) or $self->throw("Could not open $outfile.");
	my $handler = Kea::IO::BlastClust::DefaultReaderHandler->new;	
	my $reader = Kea::IO::BlastClust::ReaderFactory->createReader;
	$reader->read(*IN, $handler);
	close(IN) or $self->throw("Could not close $outfile.");
	
	$self->{_clusterCollection} = $handler->getClusterCollection;
	
	#===========================================================================
	
	
	#========
	# STEP 6
	#========
	
	# Keep things tidy!
	#===========================================================================
	
	
	if ($args{-cleanup => TRUE}) {
		print ">>> Tidying up: deleting the following temporary files...\n";											
		unlink(TMP_INFILE);
		unlink(TMP_OUTFILE);
		}
	
	#===========================================================================
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getClusterCollection {
	
	my $self = shift;
	my $clusterCollection = $self->{_clusterCollection} or
		$self->throw(
			"No cluster collection available - have you called 'run' yet?"
			);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

