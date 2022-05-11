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
package Kea::Utilities::PCR;

## Purpose		: 

use constant TRUE => 1;
use constant FALSE => 0;
use constant LIMIT_EXCEEDED => 999;
use constant MAX_MISMATCHES => 7;

use Kea::Utilities::DNAUtility;
use Kea::Utilities::_SearchOutcome;

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

my $findBestMatch = sub {
	my ($sequence, $primer) = @_;
	
	my @sequenceBases = split("", $sequence);
	my @primerBases = split("", $primer);
	my @mismatchScores;
	
	my @searchOutcomes;
	
	# Work through sequence one base at a time.
	for (my $i = 0; $i < @sequenceBases - @primerBases - 1; $i ++) {
		
		my $mismatchCounter = 0;
		my $seqPosition = $i;
		
		# Work through oligo, one base at a time.
		for (my $j = 0; $j < @primerBases; $j++) {

			# Increase mismatch counter if current primer base does not match 
			# current sequence base.
			if ($sequenceBases[$seqPosition] ne $primerBases[$j]) {
				$mismatchCounter ++;
				} 
			
			# Ensure next primer base is compared with next sequence base.
			$seqPosition ++;
			
			# Stop if reached max. mismatch limit.
			if ($mismatchCounter > MAX_MISMATCHES) {
				$mismatchCounter = LIMIT_EXCEEDED; 
				last;
				}
			
			# Stop if no more sequence left to compare. (must come after
			# previous if block).
			if ($seqPosition == @sequenceBases) {last;}
			
			} # End of for j loop.
		
		#-----------------------------------------------------------------
		
		# Investigation at current sequence position ended.  Store results.
		
		# Store data.
		push(@mismatchScores, $mismatchCounter);
		
		} # End of for i loop.
	
	# Iterate through mismatch score array and create search outcomes for
	# each position that has a valid search (i.e., not LIMIT_EXCEEDED).
	for (my $i = 0; $i < @mismatchScores; $i++) {
		
		# Get score associated with sequence position i.
		my $score = $mismatchScores[$i];
		
		# If score is outside requested range do not store in collection.
		if ($score == LIMIT_EXCEEDED) {next;}
		
		# Score is valid, therefore create outcome object.
		my $outcome = Kea::Utilities::_SearchOutcome->new(
			-mismatches => $mismatchScores[$i],
			-start => $i + 1,
			-end => $i + length($primer)
			);
		
		# Store outcome object in collection.
		push(@searchOutcomes, $outcome);
		
		}
	
	# Now sort outcomes to find best match:
	my @sortedOutcomes = sort { $a->getMismatches <=> $b->getMismatches} @searchOutcomes;
	
	return $sortedOutcomes[0];
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub setRecord {
	my ($self, $record) = @_;
	$self->{_record} = $record;
	} # End of method.

sub setForwardPrimer {
	my ($self, $primer) = @_;
	$primer =~ tr/a-z/A-Z/;
	$self->{_forwardPrimer} = $primer;
	} # End of method.

sub setReversePrimer {
	my ($self, $primer) = @_;
	$primer =~ tr/a-z/A-Z/;
	$self->{_reversePrimer} = $primer;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub run {
	my $self = shift;
	my $record = $self->{_record};
	my $forwardPrimer = $self->{_forwardPrimer};
	my $reversePrimer = $self->{_reversePrimer};
	
	# Assuming reverse primer is antisense (should be!), convert to sense.
	my $utility = Kea::Utilities::DNAUtility->new;
	$reversePrimer = $utility->getReverseComplement($reversePrimer);
	
	my $sequence = $record->getSequence;
	$sequence =~ tr/a-z/A-Z/;
	
	# Get start and end positions of pcr product (including primers).
	my $match1 = $findBestMatch->($sequence, $forwardPrimer);
	my $match2 = $findBestMatch->($sequence, $reversePrimer);
	
	my $first = $match1;
	my $second = $match2;
	if ($first->getStart > $second->getStart) {
		$first = $match2;
		$second = $match1;
		} 

	print "Outcome of forward primer:\n" . $first->toString . "\n";
	print "Outcome of reverse primer:\n" . $second->toString . "\n";
	
	my $start = $first->getStart;
	my $end = $second->getEnd;
	my $length = $end-$start;
	
	# Generate pcr product and return.
	my $product = substr($sequence, $start-1, $length+1);
	
	return $product;
	
	} # End of method.

################################################################################
		
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

