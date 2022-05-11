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
package Kea::Utilities::ContigConcatenator;

## Purpose		: Concatenates contigs according to output from nucmer, via show-coords.

use strict;
use warnings;

use constant TRUE => 1;
use constant FALSE => 0;

use Kea::Parsers::Mummer::Nucmer::ShowCoords::Parser;
use Kea::Parsers::Mummer::Nucmer::ShowCoords::AbstractHandler;
use Kea::Parsers::Fasta::Parser;

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

my $privateMethod = sub {
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

## Purpose		: ?????????????.
## Returns		: n/a.
## Parameter	: n/a.
## Throws		: n/a.
sub run {
	my ($self, %args) = @_;
	
	my $CONTIGS = $args{-contigsFilehandle} or die "ERROR: No contigs filehandle provided.";
	my $COORDS = $args{-coordsFilehandle} or die "ERROR No filehandle to show-coords outfile provided.";
	my $OUT = $args{-outFilehandle} or die "ERROR: No filehandle to outfile provided.";
	
	# Parse coordinates file.
	my $parser = Kea::Parsers::Mummer::Nucmer::ShowCoords::Parser->new;
	my $handler = Handler->new;
	$parser->parse($COORDS, $handler);
	
	# Sort contig ids according to start position.
	my %codeHash = $handler->getHash;
	my @sortedCodes = sort {$codeHash{$a}->[0] <=> $codeHash{$b}->[0]} (keys %codeHash);
	
	
#	my $i = 0;
#	foreach my $key (keys %hash) {
#		$i++;
#		print $i . ") $key " . $hash{$key}[0] . ", " . $hash{$key}[1] . "\n";
#		}

	# Parse contig file.
	my $contigParser = Kea::Parsers::Fasta::Parser->new($CONTIGS);
	my @codes = $contigParser->getCodes;
	my @sequences = $contigParser->getSequences;
	my %records = $contigParser->getSequencesAsHash;

	my $genome;	
	foreach my $code (@sortedCodes) {
		print $code . " -> position:" .  $codeHash{$code}->[0] . " \n";
#		print $OUT ">$code\n";
#		print $OUT "$records{$code}\n\n";
		$genome = $genome . "XXXXXX" . $records{$code};
		}
	
	print $OUT ">concatenated_contigs\n";
	print $OUT "$genome\n";
		
	} # End of method.

################################################################################
	
package Handler;
our @ISA = "Kea::Parsers::Mummer::Nucmer::ShowCoords::AbstractHandler";



sub new {
	my $className = shift;
	my $self = {
		_hash => {}
		};
	bless(
		$self,
		$className
		);
	return $self;
	} # End of constructor.

sub nextLine {
	my (
		$self,
		$S1, 			# S1 - start relative to subject (guide) sequence
		$E1, 			# E1 - end relative to subject (guide) sequence
		$S2, 			# S2
		$E2, 			# E2
		$LEN1,			# LEN 1
		$LEN2,			# LEN 2
		$percentIDY,	# % IDY
		$TAG1,			# first TAG
		$contigID			# second TAG - contig code.
		) = @_;
	
	# Determine orientation and hence start relative to guide.
	my $sense = 1;
	my $start = $S1;
	if ($S2 > $E2) {
		$sense = 0;
		$start = $E1;
		} 
	
	if (exists $self->{_hash}->{$contigID}) {
		my $previousStart = $self->{_hash}->{$contigID}->[0];
		my $previousSense = $self->{_hash}->{$contigID}->[1];
		
		if ($previousSense != $sense) {warn "WARNING: Conflicting sense information for $contigID.\n";}
		if ($previousStart > $start) {
			$self->{_hash}->{$contigID} = [$start, $sense];
			}
		}
	
	else {
		$self->{_hash}->{$contigID} = [$start, $sense];
		} 
	
	
	
	
	} # End of method.
		
sub getHash {
	return %{shift->{_hash}};
	} # End of method.		
		
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

