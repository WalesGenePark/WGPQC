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
package Kea::Format::Convert::Fasta;

## Purpose		: Encapsulates methods for converting fasta formated files to different formats.

use strict;
use warnings;

use constant TRUE => 1;
use constant FALSE => 0;

use Kea::Parsers::Fasta::Parser;
use Kea::IO::Phylip::Sequential::Writer;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

## Purpose		: Constructor.
## Returns		: n/a.
## Parameter	: n/a.
## Throws		: n/a.
sub new {
	my ($className, %args) = @_;
	
	my $filehandle = $args{-filehandle} or die "ERROR: No reference to filehandle provided.  Use the -filehandle flag.";
	
	my $parser = Kea::Parsers::Fasta::Parser->new($filehandle);
	my @codes = $parser->getCodes;
	my @sequences = $parser->getSequences;
	
	my $self = {
		_codes => \@codes,
		_sequences => \@sequences
		};
	bless(
		$self,
		$className
		);
	return $self;
	} # End of constructor.

################################################################################

# METHODS

## Purpose		: ?????????????.
## Returns		: n/a.
## Parameter	: n/a.
## Throws		: n/a.
sub toPhylipInterleaved {
	my ($self, %args) = @_;
	
	my $FILEHANDLE = $args{-filehandle} or die "ERROR: No filehandle provided.  Use -filehandle flag.";
	my @codes = @{$self->{_codes}};
	my @sequences = @{$self->{_sequences}};
	
	my $writer = Kea::IO::Phylip::Sequential::Writer->new(
		-codes => \@codes,
		-sequences => \@sequences
		);
		
	$writer->write($FILEHANDLE);	

	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

