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
package Kea::IO::GenBank::WriterFactory;
use Kea::Object;
use Kea::IO::IWriterFactory;
our @ISA = qw(Kea::Object Kea::IO::IWriterFactory);

use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant FASTA 		=> "fasta";
use constant EMBL 		=> "embl";
use constant UNKNOWN 	=> "unknown";
use constant HASH 		=> "HASH";
use constant ARRAY 		=> "ARRAY";

#  ONLY USE _FromRecordCollectionWriter. 
# use Kea::IO::GenBank::_FromRecordWriter;

use Kea::IO::GenBank::_FromRecordCollectionWriter;
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
	my ($self, @args) = @_;
	
	if (scalar(@args) == 1) {
	
		# Is a Record object.
		if ($args[0]->isa("Kea::IO::IRecord")) {
			
			# Commented out 02/03/2009.
			#return Kea::IO::GenBank::_FromRecordWriter->new($args[0]);
			
			# NOT CURRENTLY USING _FromRecordWriter - DIFFICULT TO MAINTAIN BOTH.
			my $recordCollection = Kea::IO::RecordCollection->new("");
			$recordCollection->add($args[0]);
			
			return
				Kea::IO::GenBank::_FromRecordCollectionWriter->new(
					$recordCollection
					);
			
			}
		
		elsif ($args[0]->isa("Kea::IO::RecordCollection")) {
			return Kea::IO::GenBank::_FromRecordCollectionWriter->new($args[0]);
			}
		
		else {
			$self->throw("Unsupported reference: '" . ref($args[0]) . "'");
			}
		}
	else {
		$self->throw("Wrong number of arguments passed to method.");
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

