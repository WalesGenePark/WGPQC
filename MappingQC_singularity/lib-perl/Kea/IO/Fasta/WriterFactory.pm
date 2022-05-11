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
package Kea::IO::Fasta::WriterFactory;
use Kea::Object;
use Kea::IO::IWriterFactory;
our @ISA = qw(Kea::Object Kea::IO::IWriterFactory);

use strict;
use warnings;

use constant TRUE	=> 1;
use constant FALSE	=> 0;

use Kea::IO::Fasta::_FromHashWriter; 
use Kea::IO::Fasta::_FromSequenceArrayWriter;
use Kea::IO::Fasta::_FromArraysWriter;
use Kea::IO::Fasta::_FromSequenceCollectionWriter;
use Kea::IO::Fasta::_FromISequenceWriter;
use Kea::IO::Fasta::_FromRecordWriter;
use Kea::IO::Fasta::_FromFeatureArrayWriter;
use Kea::IO::Fasta::_FromFeatureCollectionWriter;
use Kea::IO::Fasta::_FromRecordCollectionWriter;
use Kea::IO::Fasta::_FromAlignmentWriter;
use Kea::IO::Fasta::_FromSwissProtRecordCollectionWriter;
use Kea::IO::Fasta::_FromSwissProtRecordWriter;
use Kea::IO::Fasta::_FromReadCollectionWriter;

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

my $privateMethod = sub {
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub createWriter {

	my ($self, @args) = @_;
	
	if (scalar(@args) == 1) {
	
		# Is a reference to a sequence hash.
		if (ref($args[0]) eq "HASH") {
			return Kea::IO::Fasta::_FromHashWriter->new($args[0]);
			}
		# Is a reference to an array - of Sequence objects.
		elsif (ref $args[0] eq "ARRAY" && $args[0]->[0]->isa("Kea::Sequence::ISequence")) {
			return Kea::IO::Fasta::_FromSequenceArrayWriter->new($args[0]);
			}
		
		# DOESN'T WORK!
		# Is a reference to an array of Feature objects.
#		elsif (ref $args[0] eq "ARRAY" && $args[0]->isa("Kea::IO::Feature::IFeature")) {
#			return Kea::IO::Fasta::_FromFeatureArrayWriter->new($args[0]);
#			}
		
		elsif ($args[0]->isa("Kea::Alignment::IAlignment")) {
			return Kea::IO::Fasta::_FromAlignmentWriter->new($args[0]);
			}
		
		elsif ($args[0]->isa("Kea::IO::Feature::FeatureCollection")) {
			return Kea::IO::Fasta::_FromFeatureCollectionWriter->new($args[0], "dna");
			}
		
		elsif ($args[0]->isa("Kea::IO::RecordCollection")) {
			return Kea::IO::Fasta::_FromRecordCollectionWriter->new($args[0]);
			}
		
		# Is an ISequence object.
		elsif ($args[0]->isa("Kea::Sequence::ISequence")) {
			return Kea::IO::Fasta::_FromISequenceWriter->new($args[0]);
			}
		
		# Is a SequenceCollection object.
		elsif (ref $args[0] eq "Kea::Sequence::SequenceCollection") {
			return Kea::IO::Fasta::_FromSequenceCollectionWriter->new($args[0]);
			}
		
        # Is a ReadCollection object.
        elsif (ref $args[0] eq "Kea::Assembly::ReadCollection") {
            return Kea::IO::Fasta::_FromReadCollectionWriter->new($args[0]);
            }
        
		# Is a Record object.
		elsif ($args[0]->isa("Kea::IO::IRecord")) {
			return Kea::IO::Fasta::_FromRecordWriter->new($args[0]);
			}
		
		elsif ($args[0]->isa("Kea::IO::SwissProt::SwissProtRecordCollection")) {
			return
				Kea::IO::Fasta::_FromSwissProtRecordCollectionWriter->new(
					$args[0]
					);
			}
		
		elsif ($args[0]->isa("Kea::IO::SwissProt::ISwissProtRecord")) {
			return
				Kea::IO::Fasta::_FromSwissProtRecordWriter->new(
					$args[0]
					);
			}
		
		else {
			$self->throw("Unrecognised argument: " . ref($args[0]) . ".");
			}
			
		}
	
	
	
	
	elsif (scalar(@args) == 2) {
		if (ref $args[0] eq "ARRAY" and ref $args[1] eq "ARRAY") {
			return Kea::IO::Fasta::_FromArraysWriter->new(@args);
			}
		
		elsif ($args[0]->isa("Kea::IO::Feature::FeatureCollection") && $args[1] =~ /aa/i) {
			return Kea::IO::Fasta::_FromFeatureCollectionWriter->new($args[0], "aa");
			}
		elsif ($args[0]->isa("Kea::IO::Feature::FeatureCollection") && $args[1] =~ /dna/i) {
			return Kea::IO::Fasta::_FromFeatureCollectionWriter->new($args[0], "dna");
			}
		
		else {
			$self->throw("Both arguments must be references to arrays.");
			}
		}
	else {
		confess->throw("Wrong number of arguments.");
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

