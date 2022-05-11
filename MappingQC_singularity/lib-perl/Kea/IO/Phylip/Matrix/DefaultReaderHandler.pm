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
package Kea::IO::Phylip::Matrix::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::Phylip::Matrix::IReaderHander;
our @ISA = qw(Kea::Object Kea::IO::Phylip::Matrix::IReaderHandler);

use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";

use Kea::Phylogeny::MatrixFactory;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $self = {
		_size => undef,
		_labels => [],
		_matrix => []
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

sub header {
	my ($self, $numberOfSequences) = @_;
	$self->{_size} = $numberOfSequences;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub nextRow {

	my ($self, $id, @values) = @_;
	
	push(@{$self->{_labels}}, $id);
	
	my $actualN = @values;
	my $expectedN = $self->{_size};
	
	if ($actualN != $expectedN) {
		$self->throw(
			"Number of matrix columns ($actualN)" .
			" does not correspond to expected number ($expectedN)."
			);	
		}
	
	my $matrix = $self->{_matrix};
	
	push(@$matrix, \@values);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getMatrix {

	my $self = shift;
	my $expectedN = $self->{_size};
	my $labels = $self->{_labels};
	my $matrix = $self->{_matrix};
	
	if (!defined $expectedN) {
		$self->throw(
			"Matrix file does not appear to have a header - " .
			"is the file format correct?"
			);	
		}
	
	if ($expectedN != scalar(@$matrix) || $expectedN != scalar(@{$matrix->[0]})) {
		$self->throw("Actual size and expected size of matrix are not equal.");
		}
	
	if ($expectedN != scalar(@$labels)) {
		$self->throw(
			"Number of labels (" . scalar(@$labels) .
			") do not match expected number of sequences ($expectedN)."
			);	
		}
		
	return Kea::Phylogeny::MatrixFactory->createMatrix($labels, $matrix);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

