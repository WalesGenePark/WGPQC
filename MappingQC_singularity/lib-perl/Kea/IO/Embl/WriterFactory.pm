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
package Kea::IO::Embl::WriterFactory;
use Kea::Object;
use Kea::IO::IWriterFactory;
our @ISA = qw(Kea::Object Kea::IO::IWriterFactory);

use strict;
use warnings;

use constant TRUE	=> 1;
use constant FALSE 	=> 0;

# Currently defunct - forcing code to use _FromRecordCollectionWriter instead.
#use Kea::IO::Embl::_FromRecordWriter;

use Kea::IO::Embl::_FromRecordCollectionWriter;
use Kea::IO::Embl::_FromFeatureCollectionWriter;
use Kea::IO::Embl::_FromGffRecordCollectionWriter;
use Kea::IO::Embl::_FromDiffCollectionWriter;
use Kea::IO::Embl::_FromVariationCollectionWriter;
use Kea::IO::Embl::_FromSnpCollectionWriter;

use Kea::IO::RecordCollection;

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

	my $self 	= shift;
	my $object 	= $self->check(shift);
	
	if ($object->isa("Kea::IO::IRecord")) {
		
		# Commented out 02/03/2009 - easier to maintain code if only using
		# _FromRecordCollectionWriter.
		#return Kea::IO::Embl::_FromRecordWriter->new($object);
		
		my $recordCollection = Kea::IO::RecordCollection->new("");
		$recordCollection->add($object);
		
		return Kea::IO::Embl::_FromRecordCollectionWriter->new($recordCollection);
		
		}
	elsif ($object->isa("Kea::IO::RecordCollection")) {
		return Kea::IO::Embl::_FromRecordCollectionWriter->new($object);
		}
	elsif ($object->isa("Kea::IO::Feature::FeatureCollection")) {
		return Kea::IO::Embl::_FromFeatureCollectionWriter->new($object);
		}
	elsif ($object->isa("Kea::IO::Gff::GffRecordCollection")) {
		return Kea::IO::Embl::_FromGffRecordCollectionWriter->new($object);
		}
	elsif ($object->isa("Kea::IO::SOLiD::Snps::SnpCollection")) {
		return Kea::IO::Embl::_FromSnpCollectionWriter->new($object);
		}
	elsif ($object->isa("Kea::Assembly::Newbler::AllDiffs::DiffCollection")) {
		return Kea::IO::Embl::_FromDiffCollectionWriter->new($object);
		}
	elsif ($object->isa("Kea::Alignment::Variation::VariationCollection")) {
		return Kea::IO::Embl::_FromVariationCollectionWriter->new($object);
		}	
	else {
		$self->throw("Unrecognised type: " . ref($object) . ".");
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

