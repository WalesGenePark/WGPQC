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
package Kea::IO::Phylip::Interleaved::_ToHandlerReader;
use Kea::IO::IReader;
our @ISA = "Kea::IO::IReader";

## Purpose		: 

use strict;
use warnings;
use Carp;

use constant TRUE => 1;
use constant FALSE => 0;

use constant SENSE => "sense";
use constant ANTISENSE => "antisense";

use constant FASTA => "fasta";
use constant EMBL => "embl";
use constant UNKNOWN => "unknown";

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

## Purpose		: Constructor.
## Parameter	: n/a.
## Throws		: n/a.
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

my $store = sub {
	my ($handler, $id, $seq) = @_;
	
	#Êremove whitespace from sequence.
	$seq =~ s/\s//g;
	
	$handler->nextSequence($id, $seq);
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

## Purpose		: ?????????????.
## Returns		: n/a.
## Parameter	: n/a.
## Throws		: n/a.
sub read {
	my ($self, $FILEHANDLE, $handler) = @_;
	
	my $numberOfSequences = undef;
	my $sequenceLength = undef;
	my $counter = 0;
	my @labels;
	my @sequences;
	
	while (my $line = <$FILEHANDLE>) {
		
		if ($line =~ /^\s+(\d+)\s+(\d+)\w*$/) {
			$handler->header($1, $2);
			$numberOfSequences = $1;
			$sequenceLength = $2;
			}
		
		elsif ($line =~ /^\s*$/) {
			$counter = 0;
			if (@labels != $numberOfSequences || @sequences != $numberOfSequences) {
				confess "\nERROR: Formatting problem encountered.";
				}
			}
		
		elsif ($line =~ /^(\S+)\s+(.+)$/) {
			my $id = $1;
			my $seqFragment = $2;
			push(@labels, $id);
			push(@sequences, $seqFragment);
			
			if (!defined $numberOfSequences || !defined $sequenceLength) {
				confess "\nERROR: Formatting problem encountered: header not recognised.";
				}
			}
		
		elsif ($line =~ /^\s+(.+)$/) {
			$sequences[$counter] = $sequences[$counter] . $1;
			$counter++;
			if ($counter > $numberOfSequences) {
				confess "\nERROR: Formatting problem encountered. Expected number of sequences = $numberOfSequences; actual number = $counter.";
				}
			}
		
		}
	
	# Send data to handler.
	for (my $i = 0; $i < @labels; $i++) {
		my $id = $labels[$i];
		my $sequence = $sequences[$i];
		$sequence =~ s/\s//g;
		if (length($sequence) != $sequenceLength || !defined $sequenceLength) {
			confess "\nERROR: Formatting problem encountered.";
			}
		$handler->nextSequence($id, $sequence);
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;
=pod
    4    239
identifie MNLWDKKAKT YARYQNTLNT IQKQTFEYLQ NLKIIFQNKN IIDIGCGTGV
gi|861539 MNLWDKKAKT YARYQNTLNT IQKQTFEYLQ NLNISFQNKS IIDIGCGTGV
gi|153951 MNLWDKKAKT YTRYQNTLNT IQKQTFEYLQ NLKISFQDKS IIDIGCGTGV
gi|157916 MNLWDKKAKT YARYQNTLNT IQKQTFEYLQ NLKISFQDKS IIDIGCGTGV

          WTLHLAKEAK EILALDNAKA MLEILQEDAK KLNLNNIKCE NSSFETWMQN
          WTLHLAKEAK EILALDSANT MLEILQEDAK KLNLNNIKCE NLSFETWMQN
          WTLHLAKEAK EILALDSANA MLEILQEDAK KLNFNNIKCE NLSFETWMQN
          WTLHLAKEAK EILALDSANA MLEILQEDAK KLNLNNIKCK NLSFETWMQN

          HPNAKFDLAF LSMSPALKDE KDYANFLNLA KIKIYLGWAD YRKSDFLDPI
          NPNVKFDLAF LSMSPALQNE KDYTNFLNLA KIKIYLGWAD YRKSDFLDPI
          NPNAKFDLAF LSMSPVLKDE KDYANFLNLA KIKIYLGWTD YRKSDFLDPI
          NPNVKFDLAF LSMSPALQNE KDYTNFLNLA KIKIYLGWAD YRKSDFLDPI

          FKHFNTEFKG FYKQDLENYL LEKNIFFHKI VFNETRKVQR TKEEAIENAL
          FKYFNTEFKG FYKKDLENYL LEKNIFFHKI VFDETRKVQR TKEEAIENAL
          FKYFNTGFKG FYKKDLENYL LEKNIFFHKI VFHETRKVQR TKEEAIENAL
          FKYFNTEFKG FYKKDLENYL LEKNIFFHKI VFDETRKVQR TKEEAIENAL

          WHLNMNKITT SKEILSPFVQ NDITETIKSK IKLLIINNL
          WHLSMNKITT SKEAVSSFVE NDIIETIESK IKLLIINNL
          WHLSMNEITA SKETVSSFIE NDIIETIESK IKLLIINNL
          WHLSMNKITA SKETVSSFVE NNITETIESK IKLLIINNL

=cut
