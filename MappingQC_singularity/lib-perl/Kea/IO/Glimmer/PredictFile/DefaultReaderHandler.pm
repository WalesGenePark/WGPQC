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
package Kea::IO::Glimmer::PredictFile::DefaultReaderHandler;
use Kea::IO::Glimmer::PredictFile::IReaderHandler;
use Kea::Object;
our @ISA = qw(Kea::Object Kea::IO::Glimmer::PredictFile::IReaderHandler);

use strict;
use warnings;

use constant TRUE => 1;
use constant FALSE => 0;

use Kea::IO::Glimmer::ORF;
use Kea::IO::Glimmer::ORFCollection;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	my $className = shift;
	my $self = {
		_collectionArray => []
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
	my (
		$self,
		$id		# Contig id, e.g. contig00001
		) = @_;
	
	my $oc = Kea::IO::Glimmer::ORFCollection->new(
		-id => $id
		);
	
	push (@{$self->{_collectionArray}}, $oc);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextORF {
	my (
		$self,
		
		$geneID,			# orf code. e.g. orf00001 
		$startPosition,		# Start location within contig.
		$endPosition,		# End position within contig.
		$readingFrame,		# Reading frame: -3, -2, -1, +1, +2, +3
		$rawScore			# Raw score.
		) = @_;
	
	# Create new orf object and add to current collection.
	my $orf = Kea::IO::Glimmer::ORF->new(
		-id 		=> $geneID,
		-start 		=> $startPosition,
		-end 		=> $endPosition,
		-readFrame 	=> $readingFrame,
		-rawScore 	=> $rawScore
		);
	
	my $n = @{$self->{_collectionArray}};
	
	$self->{_collectionArray}->[$n-1]->add($orf);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getOrfCollection {
	
	my $self = shift;
	my $orfCollections = $self->{_collectionArray};
	
	$self->throw(
		"Assuming only one orf collection, but found " .
		@$orfCollections .
		"."
		)
		if @$orfCollections != 1;
	
	return $orfCollections->[0];
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getORFCollections {
	return @{shift->{_collectionArray}};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

