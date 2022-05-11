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

#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////

# CLASS NAME
package Kea::Alignment::Muscle::_SequenceCollectionMuscle;
use Kea::Object;
our @ISA = qw(Kea::Object);

## Purpose		: 

use strict;
use warnings;

use constant TRUE 			=> 1;
use constant FALSE 			=> 0;
use constant TMP_INFILE 	=> "TMP_muscle_infile.fas";
use constant TMP_OUTFILE 	=> "TMP_muscle_outfile.fas";

use Kea::IO::Fasta::WriterFactory;
use Kea::IO::Fasta::DefaultReaderHandler;
use Kea::IO::Fasta::ReaderFactory;
use Kea::ThirdParty::Muscle::_MuscleWrapper;
use Kea::Alignment::AlignmentFactory;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

## Purpose		: Constructor.
## Parameter	: n/a.
## Throws		: n/a.
sub new {
	my $className = shift;
	my $sequenceCollection = shift;
	
	
	my $self = {
		_sequenceCollection => $sequenceCollection,
		_alignment 			=> undef
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

## Purpose		: ?????????????.
## Returns		: n/a.
## Parameter	: n/a.
## Throws		: n/a.
sub run {
	my ($self, %args) = @_;
	
	my $gapopen = $args{-gapopen};
	
	my $cleanup = TRUE;
	if (exists $args{-cleanup}) {
		$cleanup = $args{-cleanup};
		} 
	
	my $sequenceCollection = $self->{_sequenceCollection};
	
	# Create temporary infile from  sequence collection.
	open (INFILE, ">" . TMP_INFILE) or die "\nERROR: Could not create " . TMP_INFILE;
	my $wf = Kea::IO::Fasta::WriterFactory->new;
	my $writer = $wf->createWriter($sequenceCollection);
	$writer->write(*INFILE);
	close(INFILE);
	
	# run muscle with infile.
	my $muscle = Kea::ThirdParty::Muscle::_MuscleWrapper->new;
	$muscle->run(
		-in => TMP_INFILE,
		-out => TMP_OUTFILE,
		-gapopen => $gapopen
		);
	
	# Check TMP_OUTFILE exists before proceeding.
	my $attempts = 0;
	while (!(-e TMP_OUTFILE) && $attempts < 5) {
		$attempts++;
		sleep 1;
		}
	
	# extract alignment from muscle output.
	open (OUTFILE, TMP_OUTFILE) or die "\nERROR: Could not open " . TMP_OUTFILE;
	my $handler = Kea::IO::Fasta::DefaultReaderHandler->new;
	my $reader = Kea::IO::Fasta::ReaderFactory->createReader;
	$reader->read(*OUTFILE, $handler);
	close(OUTFILE);
	
	my $alignedSequenceCollection = $handler->getSequenceCollection;
	my $alignment = Kea::Alignment::AlignmentFactory->createAlignment(
		$alignedSequenceCollection
		);
	
	$self->{_alignment} = $alignment;
	
	# clean up, if requested.
	if ($cleanup) {
		unlink(TMP_INFILE);
		unlink(TMP_OUTFILE);
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAlignment {
	return shift->{_alignment};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

