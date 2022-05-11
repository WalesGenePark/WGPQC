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
package Kea::Alignment::Blast::_Blast;
use Kea::Object;
use Kea::Alignment::Blast::IBlast;
our @ISA = qw(Kea::Object Kea::Alignment::Blast::IBlast);

use strict;
use warnings;
use Term::ANSIColor;

use constant TRUE => 1;
use constant FALSE => 0;

use constant TMP_OUTFILE => "TMP_blast_outfile.txt";
use constant TMP_INFILE => "TMP_blast_infile.fas";

use Kea::IO::Fasta::WriterFactory;

use Kea::IO::Blast::Tabular::DefaultReaderHandler;
use Kea::IO::Blast::Tabular::ReaderFactory;
use Kea::Sequence::SequenceCollection;


################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	
	my $className 		= shift;
	my $type 			= shift;
	my $showMessages 	= shift;
	
	if (!defined $showMessages) {
		Kea::Object->throw("Must specify whether messages are to be shown");
		}
	
	$type =~ tr/A-Z/a-z/;
	if ($type !~ /[npx]/) {
		Kea::Object->throw("Unrecognised blast program: blast$type.");	
		}
	
	my $self = {
		_type 			=> $type,
		_showMessages 	=> $showMessages
		};
	
	bless(
		$self,
		$className
		);
	
	return $self;
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $getCommandForSequenceCollectionAgainstDatabaseBlast = sub {
	
	my (
		$self,
		$formatdb,
		$sequenceCollection,
		$outfile,
		$format,
		$e,
		$b,
		$v
		) = @_;
	
	# Create tmp infile from sequence collection.
	my $input = TMP_INFILE;
	open(OUT, ">$input") or $self->throw("Could not create $input.");
	my $wf = Kea::IO::Fasta::WriterFactory->new;
	my $writer = $wf->createWriter($sequenceCollection);
	$writer->write(*OUT);
	close(OUT) or $self->throw("Could not close $input");
	
	my $databaseName = $formatdb->getName;
	
	# Create command.
	my $type = $self->{_type};
	
	return
		"blastall " .
			"-p blast$type " .
			"-d $databaseName " .
			"-i $input " .
			"-o $outfile " .
			"-m $format " .
			"-e $e " .
			"-b $b " .
			"-v $v";
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $getCommandForRecordAgainstDatabaseBlast = sub {
	my (
		$self,
		$formatdb,
		$record,
		$outfile,
		$format,
		$e,
		$b,
		$v
		) = @_;
	
	# Create tmp infile from record.
	my $input = TMP_INFILE;
	open(OUT, ">$input") or $self->throw("Could not create $input.");
	my $wf = Kea::IO::Fasta::WriterFactory->new;
	my $writer = $wf->createWriter($record);
	$writer->write(*OUT);
	close(OUT) or $self->throw("Could not close $input.");
	
	my $databaseName = $formatdb->getName;
	
	# Create command.
	my $type = $self->{_type};
	
	return
		"blastall " .
			"-p blast$type " .
			"-d $databaseName " .
			"-i $input " .
			"-o $outfile " .
			"-m $format " .
			"-e $e " .
			"-b $b " .
			"-v $v";
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub run {

	my $self = shift;
	my %args = @_;
	
	my $formatdb 	= $self->check($args{-d}, "Kea::Alignment::Blast::IFormatdb");
	my $input 		= $args{-i} or $self->throw("No input supplied.");
	my $outfile 	= $args{-o} || TMP_OUTFILE;
	my $format 		= $args{-m} || 0;
	my $e 			= $args{-e} || 10.0; 	# Expectation value.
	my $b 			= $args{-b} || 250; 	# Number of database sequence to show alignments for (B) [Integer]  default = 250
	my $v 			= $args{-v} || 500; 	# Number of database sequences to show one-line descriptions for (V) [Integer]  default = 500

	
	# Store for possible future reference.
	$self->{_format} = $format;
	$self->{_outfile} = $outfile;
	

	my $command;
	if ($input->isa("Kea::Sequence::SequenceCollection")) {
		$command = $self->$getCommandForSequenceCollectionAgainstDatabaseBlast(
			$formatdb,
			$input,
			$outfile,
			$format,
			$e,
			$b,
			$v
			);
		}
	elsif ($input->isa("Kea::Sequence::ISequence")) {
		my $sequenceCollection = Kea::Sequence::SequenceCollection->new;
		$sequenceCollection->add($input);
		$command = $self->$getCommandForSequenceCollectionAgainstDatabaseBlast(
			$formatdb,
			$sequenceCollection,
			$outfile,
			$format,
			$e,
			$b,
			$v
			);
		}
	elsif ($input->isa("Kea::IO::IRecord")) {
		$command = $self->$getCommandForRecordAgainstDatabaseBlast(
			$formatdb,
			$input,
			$outfile,
			$format,
			$e,
			$b,
			$v
			);
		}
	else {
		$self->throw("Unrecognised type of input -i: " . ref($input) . ".");
		}
	
	# Run command.
	if ($self->{_showMessages})  {
		my $type = $self->{_type};
		print color "yellow";
		print
			"\n".
			"\t-------------------\n".
			"\t Running blast$type...\n".
			"\t-------------------\n".
			"\n";
		print $command . "\n";	
		system($command);
		print
			"\n" .
			"\t--------------------\n".
			"\t ...blast$type finished \n".
			"\t--------------------\n".
			"\n";
		print color "reset";	
		}
	else {
		system($command);
		}
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getBlastAlignmentCollection {

	my $self = shift;
	
	# Only catering for tabular output at present.
	if ($self->{_format} != 8) {
		$self->throw(
			"Could not create report object as outfile is not tabular - " .
			"must use -m 8 not " . $self->{_format}
			);
		}
	
	my $reportFile = $self->{_outfile};
	open (IN, $reportFile) or $self->throw("Could not open $reportFile.");
	my $handler = Kea::IO::Blast::Tabular::DefaultReaderHandler->new;
	my $rf = Kea::IO::Blast::Tabular::ReaderFactory->new;
	my $reader = $rf->createReader;
	$reader->read(*IN, $handler);
	close(IN) or $self->throw("Could not close $reportFile.");
	
	return $handler->getBlastAlignmentCollection;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub trashOutfiles {
	unlink(TMP_OUTFILE);
	unlink(TMP_INFILE);
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

