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
package Kea::IO::Phylip::Interleaved::_FromAlignmentWriter;
use Kea::IO::IWriter;
our @ISA = "Kea::IO::IWriter";

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
	my $alignment = shift;
	
	my @codes = $alignment->getLabels;
	my @sequences = $alignment->getRowStrings;
	
	# Edit if codes longer than 9 characters - and warn.
	for (my $i = 0; $i < @codes; $i++) {
		my $originalCode = $codes[$i];
		if (length($originalCode) > 9) {
			$codes[$i] = substr($codes[$i], 0, 9);
			warn "WARNING: $originalCode is greater than 9 characters and will be truncated to $codes[$i].\n";
			}
		}
	
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

#ÊPRIVATE METHODS

my $convertRecordToLineArray = sub {
	my ($code, $sequence) = @_;

	
	# Dice sequence into 50 base chunks
	my @buffer;
	for (my $i = 0; $i < length($sequence); $i = $i + 50) {
		my $bases50 = substr($sequence, $i, 50);
		
		# Further dice into 10 base blocks
		my @line;
		for (my $j = 0; $j < length($bases50); $j = $j + 10) {
			my $bases10 = substr($bases50, $j, 10);
			push(@line, $bases10);
			}
		push(@buffer, \@line);
		} # End of for loop - sequence fully diced.
	
	
	# Produce codeblock (must be 10 characters in length).
	my $codeBlock = $code;
	while (length($codeBlock) < 10) {
		$codeBlock = $codeBlock . " ";	
		}
	
	# Now store each line in buffer along with header code.
	my @lines;
	my $blank = "          ";
	foreach my $line (@buffer) {
	
		my $line = $codeBlock . join(" ", @$line);
		push(@lines, $line);
	
		# Once code printed, replace with blank block.
		if ($codeBlock ne $blank) {$codeBlock = $blank;}
		}
	
	return \@lines;
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

## Purpose		: ?????????????.
## Returns		: n/a.
## Parameter	: n/a.
## Throws		: n/a.
sub write {
	my ($self, $FILEHANDLE) = @_;
	
	my @codes = @{$self->{_codes}};
	my @sequences = @{$self->{_sequences}};
	
	# Generate first line.
	my $n = scalar(@codes);
	my $m = length($sequences[0]); 
	print $FILEHANDLE "    $n    $m\n";
	
	# Now generate sequential data.
	my @lineArrays;
	for (my $i = 0; $i < @codes; $i++) {
		push(
			@lineArrays,
			$convertRecordToLineArray->($codes[$i], $sequences[$i])
			);
		}
	
	my $numberOfLines = scalar(@{$lineArrays[0]});
	for (my $i = 0; $i < $numberOfLines; $i++) {
		foreach my $lineArray (@lineArrays) {
			print $FILEHANDLE $lineArray->[$i] . "\n";
			}
		print $FILEHANDLE "\n";
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

