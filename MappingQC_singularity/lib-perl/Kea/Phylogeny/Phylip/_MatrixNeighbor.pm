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
package Kea::Phylogeny::Phylip::_MatrixNeighbor;
use Kea::Object;
use Kea::Phylogeny::Phylip::IPhylip;
our @ISA = qw(Kea::Object Kea::Phylogeny::Phylip::IPhylip);

## Purpose		: 

use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;

use constant TMP_INFILE 	=> "TMP_neighbor_infile.mat";
use constant TMP_OUTFILE 	=> "TMP_neighbor_outfile.txt";
use constant TMP_OUTTREE 	=> "TMP_neighbor_outtree.tre";

use Kea::IO::Phylip::Matrix::WriterFactory;
use Kea::ThirdParty::Phylip::_NeighborWrapper;
use Kea::IO::Phylip::Tree::DefaultReaderHandler;
use Kea::IO::Phylip::Tree::ReaderFactory;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

## Purpose		: Constructor.
## Parameter	: n/a.
## Throws		: n/a.
sub new {
	my $className 	= shift;
	my $matrix 		= Kea::Object->check(shift, "Kea::Phylogeny::IMatrix");
	
	my $self = {
		_matrix => $matrix,
		_tree 	=> undef
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
	
	my $self = shift;
	my %args = @_;
	
	
	
	
	#===========================================================================
	
	my $cleanup = TRUE;
	if (exists $args{-cleanup}) {
		$cleanup = $args{-cleanup};
		}
	
	my $matrix = $self->{_matrix};
	
	#===========================================================================
	

	
	
	
	#===========================================================================
	
	# Just fail if ids are too long.
	
	my @ids = $matrix->getLabels;
	foreach my $id (@ids) {
		if (length($id) > 10) {
			$self->throw("Label '$id' is too long!");	
			}
		}
	
	#===========================================================================
	
	
	
	
	
	
	# create tmp infile (phylip matrix) for neighbor.
	#===========================================================================
	
	open (INFILE, ">" . TMP_INFILE) or $self->throw("Could not create tmp infile.");
	my $writer = Kea::IO::Phylip::Matrix::WriterFactory->createWriter($matrix);
	$writer->write(*INFILE);
	close(INFILE) or $self->throw("Could not close tmp infile.");
	
	# Run neighbor
	my $neighbor = Kea::ThirdParty::Phylip::_NeighborWrapper->new;
	$neighbor->run(
		-infile 	=> TMP_INFILE,
		-outfile 	=> TMP_OUTFILE,
		-outtree 	=> TMP_OUTTREE
		);
	
	# Convert outfile to tree object.
	open (TREE, TMP_OUTTREE) or $self->throw("Could not open tmp treefile.");
	my $handler = Kea::IO::Phylip::Tree::DefaultReaderHandler->new;
	my $reader = Kea::IO::Phylip::Tree::ReaderFactory->createReader;
	$reader->read(*TREE, $handler);
	close(TREE) or $self->throw("Could not close tmp treefile.");
	
	
	
	$self->{_tree} = $handler->getTree;
	
	# Delete tmp files.
	if ($cleanup) {
		unlink(TMP_INFILE);
		unlink(TMP_OUTFILE);
		unlink(TMP_OUTTREE);
		}
	
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getTree {
	return shift->{_tree};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

