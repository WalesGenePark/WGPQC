#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 25/07/2008 12:57:22
#    Copyright (C) 2008, University of Liverpool.
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
package Kea::IO::Paml::Sequential::_FromSequenceCollectionWriter;
use Kea::Object;
use Kea::IO::IWriter;
our @ISA = qw(Kea::Object Kea::IO::IWriter);

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE	=> 0;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	my $className = shift;
	
	my $sequenceCollection =
		Kea::Object->check(shift, "Kea::Sequence::SequenceCollection");
	
	my @codes = $sequenceCollection->getIDs;
	my @sequences = $sequenceCollection->getSequenceStrings;
	
	# Edit if codes longer than 9 characters - and warn.
	for (my $i = 0; $i < @codes; $i++) {
		my $originalCode = $codes[$i];
		if (length($originalCode) > 9) {
			$codes[$i] = substr($codes[$i], 0, 9);
			Kea::Object->warn(
				"$originalCode is greater than 9 characters and will be " .
				"truncated to $codes[$i]."
				);
			}
		}
	
	for (my $i = 0; $i < @codes; $i++) {
		$codes[$i] = $codes[$i] . "  ";
		}
	
	
	my $self = {
		_codes 		=> \@codes,
		_sequences 	=> \@sequences
		};
	
	bless(
		$self,
		$className
		);
	
	return $self;
	
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $printRecord = sub {
	my ($FILEHANDLE, $code, $sequence) = @_;
	
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
		}
	
	# Produce codeblock (must be 11 characters in length).
	my $codeBlock = $code;
	while (length($codeBlock) < 11) {
		$codeBlock = $codeBlock . " ";	
		}
	
	# Now print each line in buffer along with header code.
	my $blank = "           ";
	foreach my $line (@buffer) {
	
		# print code or 11 blank characters.
		print $FILEHANDLE $codeBlock;
	
		# Once code printed, replace with blank block.
		if ($codeBlock ne $blank) {$codeBlock = $blank;}
	
		# Now print line of sequence blocks.
		foreach my $block (@$line) {
			print $FILEHANDLE "$block ";
			}
		print $FILEHANDLE "\n";
		}
	print $FILEHANDLE "\n";
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub write {
	my ($self, $FILEHANDLE) = @_;
	
	my @codes = @{$self->{_codes}};
	my @sequences = @{$self->{_sequences}};
	
	
	
	# Generate first line.
	my $n = scalar(@codes);
	my $m = length($sequences[0]); 
	print $FILEHANDLE "    $n    $m\n";
	
	# Now generate sequential data.
	for (my $i = 0; $i < scalar(@codes); $i++) {
		$printRecord->($FILEHANDLE, $codes[$i], $sequences[$i]);
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

