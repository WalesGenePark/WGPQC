#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 27/08/2009 15:23:05
#    Copyright (C) 2009, University of Liverpool.
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
package Kea::IO::Fastq::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::Fastq::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::Fastq::IReaderHandler);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::Sequence::SequenceCollection;
use Kea::Sequence::SequenceFactory;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $self = {
		_headers 	=> undef,
		_sequences 	=> undef,
		_qualities 	=> undef
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

sub _nextHeader {
	
	my $self = shift;
	my $header = shift;
	
	$header =~ /^(\S+)/;
	
	push(@{$self->{_headers}}, $1);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextSequence {
	
	my $self = shift;
	my $sequence = shift;
	
	push(@{$self->{_sequences}}, $sequence);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextQualities {
	
	my $self = shift;
	my $qualities = $self->check(shift);
	
	# NOTE AM ASSUMING ILLUMINA CODING
	my @buffer = split("", $qualities);
	my @scores;
	foreach  (@buffer) {
		push(@scores, ord($_) - 64);
		}	
	
	push(@{$self->{_qualities}}, \@scores);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSequenceCollection {
	
	my $self = shift;
	
	my $headers = $self->{_headers};
	my $sequences = $self->{_sequences};
	my $qualities = $self->{_qualities};
	
	my $sequenceCollection = Kea::Sequence::SequenceCollection->new("");
	
	for (my $i = 0; $i < @$headers; $i++) {
		$sequenceCollection->add(
			Kea::Sequence::SequenceFactory->createSequence(
				-id => $headers->[$i],
				-sequence => $sequences->[$i],
				-qualities => $qualities->[$i]
				)
			);
		}
	
	return $sequenceCollection;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

