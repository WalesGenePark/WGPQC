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
package Kea::Phylogeny::Phylip::_AlignmentProtDist;
use Kea::Object;
use Kea::Phylogeny::Phylip::IPhylip;
our @ISA = qw(Kea::Object Kea::Phylogeny::Phylip::IPhylip);

## Purpose		: 

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use constant TMP_INFILE		=> "TMP_protdist_infile.phy";
use constant TMP_OUTFILE 	=> "TMP_protdist_outfile.mat";

use Kea::IO::Phylip::Interleaved::WriterFactory;
use Kea::IO::Phylip::Matrix::DefaultReaderHandler;
use Kea::IO::Phylip::Matrix::ReaderFactory;
use Kea::ThirdParty::Phylip::_ProtDistWrapper;

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
	my $alignment = Kea::Object->check(shift, "Kea::Alignment::IAlignment");
	
	my $self = {
		_alignment 	=> $alignment,
		_matrix 	=> undef
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

sub run {
	my ($self, %args) = @_;
	
	my $cleanup = TRUE;
	if (exists $args{-cleanup}) {
		$cleanup = $args{-cleanup};
		}
	
	my $P = $args{-P};
	
	my $alignment =
		$self->check($self->{_alignment}, "Kea::Alignment::IAlignment");
	
	#===========================================================================
	
	# UNSATISFACTORY - changes ids too silently...
	
	# Phylip files limit ids to no more than 10 characters - any id above this
	# value is therefore truncated by following code.  Can be a problem if
	# relying on id remaining the same.  Therefore temporarily replace with aliases.
	
	#my @ids = $alignment->getIds;
	#my %idAliases;
	#my %ids;
	#for (my $i = 0; $i < @ids; $i++) {
	#	$idAliases{$ids[$i]} = "Seq$i";
	#	
	#	$ids{"Seq$i"} = $ids[$i];
	#	
	#	}
	#
	#my $tempAlignment =
	#	Kea::Alignment::AlignmentFactory->createRelabelledAlignment(
	#		$alignment,
	#		\%idAliases
	#		);
	
	# INSTEAD - break code if ids too long.
	my @ids = $alignment->getIds;
	foreach my $id (@ids) {
		if (length($id) > 9) {
			$self->throw("Label '$id' is too long for Phylip!");
			}
		}
	
	#===========================================================================
	
	
	# create tmp infile (phylip interleaved) for protdist.
	open(INFILE, ">" . TMP_INFILE) or $self->throw("Could not create tmp infile.");
	my $writer =
		Kea::IO::Phylip::Interleaved::WriterFactory->createWriter(
			#$tempAlignment <-- used if temporarily changing ids - see above. 
			$alignment
			);
	$writer->write(*INFILE);
	close(INFILE) or $self->throw("Could not close tmp infile.");
	
	# Run protdist
	my $protdist = Kea::ThirdParty::Phylip::_ProtDistWrapper->new;
	$protdist->run(
		-infile 	=> TMP_INFILE,
		-outfile 	=> TMP_OUTFILE,
		-P 			=> $P
		);
	
	
	# Convert outfile to matrix object.
	open (MATRIX, TMP_OUTFILE) or $self->throw("Could not open tmp outfile.");
	my $handler = Kea::IO::Phylip::Matrix::DefaultReaderHandler->new;
	my $reader = Kea::IO::Phylip::Matrix::ReaderFactory->createReader;
	$reader->read(*MATRIX, $handler);
	close(MATRIX) or $self->throw("Could not close tmp outfile.");
	
	#ÊGet matrix and relabel with original ids.
	#===========================================================================
	
	my $matrix = $handler->getMatrix;
	
	# NO LONGER RELABELLING - SEE ABOVE.
	#for (my $i = 0; $i < $matrix->getSize; $i++) {
	#	my $alias = $matrix->getLabel($i);
	#	my $id = $ids{$alias};
	#	$matrix->setLabel($i, $id);
	#	}
	
	#===========================================================================
	
	$self->{_matrix} = $matrix;
	
	# Delete tmp files.
	if ($cleanup) {
		unlink(TMP_INFILE);
		unlink(TMP_OUTFILE);
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getMatrix {
	return shift->{_matrix};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

