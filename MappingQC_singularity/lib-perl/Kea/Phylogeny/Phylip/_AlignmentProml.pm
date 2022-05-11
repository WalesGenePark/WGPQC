#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 25/02/2008 08:48:12 
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
package Kea::Phylogeny::Phylip::_AlignmentProml;
use Kea::Object;
use Kea::Phylogeny::Phylip::IPhylip;
our @ISA = qw(Kea::Object Kea::Phylogeny::Phylip::IPhylip);

## Purpose		: 

use strict;
use warnings;

use constant TRUE 			=> 1;
use constant FALSE 			=> 0;
use constant TMP_INFILE		=> "TMP_proml_infile.phy";
use constant TMP_OUTFILE 	=> "TMP_proml_outfile.txt";
use constant TMP_OUTTREE 	=> "TMP_proml_outtree.tre";

use Kea::IO::Phylip::Tree::DefaultReaderHandler;
use Kea::IO::Phylip::Tree::ReaderFactory;
use Kea::ThirdParty::Phylip::_PromlWrapper;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	
	my $className = shift;
	my $alignment = Kea::Object->check(shift, "Kea::Alignment::IAlignment");
	
	my $self = {
		_alignment => $alignment
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
	
	
	
	# Get Args etc.
	#===========================================================================
	
	my $cleanup = TRUE;
	if (exists $args{-cleanup}) {
		$cleanup = $args{-cleanup};
		}
	
	my $P 			= $args{-P};
	my $R			= $args{-R};
	my $S			= $args{-S};
	
	my $alignment 	= $self->{_alignment};
	
	#===========================================================================
	
	
	
	# Break code if ids too long.
	#===========================================================================
	
	my @ids = $alignment->getIds;
	foreach my $id (@ids) {
		if (length($id) > 9) {
			$self->throw(
				"Label '$id' is too long for Phylip! " .
				"Data will need preprocessing."
				);
			}
		}
	
	#===========================================================================
	
	
	
	
	# create tmp infile (phylip interleaved) from alignment object.
	#===========================================================================
	
	open(INFILE, ">" . TMP_INFILE) or $self->throw("Could not create tmp infile.");
	my $writer = 
		Kea::IO::Phylip::Interleaved::WriterFactory->createWriter(
			$alignment
			);
	$writer->write(*INFILE);
	close(INFILE) or $self->throw("Could not close tmp infile.");
	
	#===========================================================================
	
	
	
	
	# Run proml
	#===========================================================================
	
	my $dnadist = Kea::ThirdParty::Phylip::_PromlWrapper->new;
	$dnadist->run(
		-infile 	=> TMP_INFILE,
		-outfile 	=> TMP_OUTFILE,
		-outtree	=> TMP_OUTTREE,
		-P 			=> $P,
		-R			=> $R,
		-S			=> $S
		);
	
	#===========================================================================
	
	
	
	
	# Convert outfile to tree object.
	#===========================================================================
	
	open (TREE, TMP_OUTTREE) or $self->throw("Could not open tmp treefile.");
	my $handler = Kea::IO::Phylip::Tree::DefaultReaderHandler->new;
	my $reader = Kea::IO::Phylip::Tree::ReaderFactory->createReader;
	$reader->read(*TREE, $handler);
	close(TREE) or $self->throw("Could not close tmp treefile.");

	$self->{_tree} = $handler->getTree;
	
	#===========================================================================
	
	
	
	
	# Delete tmp files.
	#===========================================================================
	
	if ($cleanup) {
		unlink(TMP_INFILE);
		unlink(TMP_OUTFILE);
		unlink(TMP_OUTTREE);
		}
	
	#===========================================================================
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getTree {
	return shift->{_tree};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

