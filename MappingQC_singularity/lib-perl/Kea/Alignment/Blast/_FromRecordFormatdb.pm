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
package Kea::Alignment::Blast::_FromRecordFormatdb;
use Kea::Object;
use Kea::Alignment::Blast::IFormatdb;
our @ISA = qw(Kea::Object Kea::Alignment::Blast::IFormatdb);


use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use constant TEMP_FILE => "TMP_formatdb.fas";

use Kea::IO::Fasta::WriterFactory;
use Kea::Sequence::SequenceCollection;
use Kea::Sequence::SequenceFactory;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	my $className = shift;
	my $record = Kea::Object->check(shift, "Kea::IO::IRecord");
	
	my $self = {
		_record => $record
		};
	bless(
		$self,
		$className
		);
	return $self;
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $createGenomeFastaInfile = sub {
	
	my $self = shift;
	
	my $tmpFile = TEMP_FILE;
	
	open (OUT, ">$tmpFile") or $self->throw("Could not create $tmpFile");
	my $wf = Kea::IO::Fasta::WriterFactory->new;
	my $writer = $wf->createWriter($self->{_record});
	$writer->write(*OUT);
	close(OUT) or $self->throw("Could not close $tmpFile");
	
	return $tmpFile;
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $createCDSFastaInfile = sub {
	
	my $self = shift;
	
	my $tmpFile = TEMP_FILE;
	
	my $cdsFeatureCollection = $self->{_record}->getCDSFeatureCollection;
	
	my $sequenceCollection = Kea::Sequence::SequenceCollection->new;
	my $sf = Kea::Sequence::SequenceFactory->new;
	for (my $i = 0; $i < $cdsFeatureCollection->getSize; $i++) {
		my $sequence = $sf->createSequence(
			-id 		=> $cdsFeatureCollection->get($i)->getLocusTag,
			-sequence	=> $cdsFeatureCollection->get($i)->getDNASequence
			);
		$sequenceCollection->add($sequence);
		}
	
	open (OUT, ">$tmpFile") or $self->throw("Could not create $tmpFile");
	my $wf = Kea::IO::Fasta::WriterFactory->new;
	my $writer = $wf->createWriter($sequenceCollection);
	$writer->write(*OUT);
	close(OUT) or $self->throw("Could not close $tmpFile");
	
	return $tmpFile;
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $createTranslationsFastaInfile = sub {
	
	my $self = shift;
	
	my $tmpFile = TEMP_FILE;
	
	my $cdsFeatureCollection = $self->{_record}->getCDSFeatureCollection;
	
	my $sequenceCollection = Kea::Sequence::SequenceCollection->new;
	my $sf = Kea::Sequence::SequenceFactory->new;
	for (my $i = 0; $i < $cdsFeatureCollection->getSize; $i++) {
		my $sequence = $sf->createSequence(
			-id 		=> $cdsFeatureCollection->get($i)->getLocusTag,
			-sequence 	=> $cdsFeatureCollection->get($i)->getTranslation
			);
		$sequenceCollection->add($sequence);
		}
	
	open (OUT, ">$tmpFile") or $self->throw("Could not create $tmpFile.");
	my $wf = Kea::IO::Fasta::WriterFactory->new;
	my $writer = $wf->createWriter($sequenceCollection);
	$writer->write(*OUT);
	close(OUT) or $self->throw("Could not close $tmpFile.");
	
	return $tmpFile;
	
	}; # end of method.

################################################################################

# PUBLIC METHODS

sub run {
	my ($self, %args) = @_;
	
	my $protein = $args{-p};
	if (!defined $protein) {
		$protein = TRUE;
		}
	
	my $cdsOnly = $args{-cdsOnly};
	if (!defined $cdsOnly) {
		$cdsOnly = TRUE;
		}
	
	# Be strict!
	if ($protein && !$cdsOnly) {$self->throw("-p TRUE and -cdsOnly FALSE is illogical!");}
	
	my $command;
	# Create protein database from aa translations.
	if ($protein) {
		# Extract translations from record.
		my $infile = $self->$createTranslationsFastaInfile();
		$command = "formatdb -p T -i $infile";
		}
	
	# Create dna database from cds regions.
	elsif ($cdsOnly) {
		my $infile = $self->$createCDSFastaInfile();
		$command = "formatdb -p F -i $infile";
		}
	
	# Create dna database from entire dna sequence.
	else {
		# Extract entire genome from record.
		my $infile = $self->$createGenomeFastaInfile();
		$command = "formatdb -p F -i $infile";
		}	
	
	# Run command.
	print
		"\n".
		"\t----------------------\n".
		"\t Running formatdb...\n".
		"\t----------------------\n".
		"\n";
	print $command . "\n";	
	system($command);
	print
		"\n" .
		"\t----------------------\n".
		"\t ...formatdb finished \n".
		"\t----------------------\n".
		"\n";
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub trashOutfiles {
	
	my $self = shift;
	my $tmpfile = TEMP_FILE;
	
	opendir (DIR, ".") or $self->throw("Could not open current directory");
	
	while(defined(my $file = readdir(DIR))) {
		if ($file =~ /^$tmpfile.*/) {
			unlink($file);
			}
		}
	
	unlink("formatdb.log");
	
	closedir(DIR);
	}

#///////////////////////////////////////////////////////////////////////////////

sub getName {
	my ($self) = shift;
	return TEMP_FILE;
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

