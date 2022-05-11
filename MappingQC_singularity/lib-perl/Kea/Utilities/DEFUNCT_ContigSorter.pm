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
package Kea::Utilities::ContigSorter;

## Purpose		: Sorts contigs relative to reference sequence.

use constant TRUE => 1;
use constant FALSE => 0;

use strict;
use warnings;
use Carp;
use POSIX;

use Kea::IO::Fasta::WriterFactory;
use Kea::Alignment::Mummer::Nucmer;
use Kea::Parsers::Mummer::Nucmer::ShowCoords::Parser;
use Kea::Parsers::Mummer::Nucmer::ShowCoords::AbstractHandler;
use Kea::Sequence::SequenceCollection;

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

my $existsInArray = sub {
	my ($query, @array) = @_;
	foreach my $subject (@array) {
		if ($query eq $subject) {
			return TRUE;
			}
		}
	return FALSE;
	}; # End of method.

################################################################################

# PUBLIC METHODS

## Purpose		: Sets reference sequence to be used.
## Parameter	: ISequence object.
sub setReference {
	my ($self, $reference) = @_;
	
	$reference->isa("Kea::Sequence::ISequence")
		or confess "\nERROR: method requires a ISequence object";	
	
	$self->{_reference} = $reference;
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

# Purpose		: Sets contigs to be analysed.
# Parameter		: SequenceCollection object.
sub setContigs {
	my ($self, $contigs) = @_;
	
	$contigs->isa("Kea::Sequence::SequenceCollection")
		or confess "\nERROR: method requires a SequenceCollection object";
	
	$self->{_data} = $contigs;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose		: Returns array of ids successfully ordered by sorter. 
## Return		: Array of id strings.
sub getOrderedIDs {
	my @orderedIDs = @{shift->{_orderedIDs}}
		or confess "\nERROR: No ordered IDs - has run been called?";
		
	return @orderedIDs;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasUnorderedIDs {
	my @unorderedIDs = @{shift->{_unorderedIDs}};
	if (@unorderedIDs) {return TRUE;} else {return FALSE;}
	} #ÊEnd of method.

## Purpose		: Returns array of ids which could not be sorted. 
## Return		: Array of id strings.
sub getUnorderedIDs {
	my @unorderedIDs = @{shift->{_unorderedIDs}}
		or confess "\nERROR: No ordered IDs - has run been called?";
	return @unorderedIDs;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSortedOrientations {
	return %{shift->{_orientations}}
		or confess "\nERROR: No orientations - run been called?";
	} # End of method.

sub getSortedPercentMatches {
	return %{shift->{_percentMatches}}
		or confess "\nERROR: No percent matches - run been called?";
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose		: Run sorter.
## Returns		: n/a.
## Parameter	: n/a.
## Throws		: n/a.
sub run {
	my $self = shift;
	
	# Get previously stored input data or throw exception.
	my $contigSequenceCollection = $self->{_data} or confess "\nERROR: No sequence data provided";
	my $referenceSequence = $self->{_reference} or confess "\nERROR: No reference data provided";
	
	# Create tmp files from these data which will be used by nucmer program.
	my $referenceInfile = "tmp_ref.fas";
	my $queryInfile = "tmp_query.fas";
	my $coordsOutfile = "tmp_coords.outfile";
	my $clusterOutfile = "tmp_cluster.outfile";
	my $deltaOutfile = "tmp_delta.outfile";
	
	open (QUERY, ">$queryInfile") or confess "\nERROR: Could not create tmp file $queryInfile";
	my $wf = Kea::IO::Fasta::WriterFactory->new;
	my $writer = $wf->createWriter($contigSequenceCollection);
	$writer->write(*QUERY);
	close(QUERY);
	
	open (REF, ">$referenceInfile") or confess "\nERROR: Could nor create tmp file $referenceInfile.";
	$writer = $wf->createWriter($referenceSequence);
	$writer->write(*REF);
	close(REF);
	
	# Run nucmer program and parse resulting show-coords program output.
	my $nucmer = Kea::Alignment::Mummer::Nucmer->new;
	$nucmer->run(
		-referenceInfile => $referenceInfile,
		-queryInfile => $queryInfile,
		-deltaOutfile => $deltaOutfile,
		-clusterOutfile => $clusterOutfile,
		-coordsOutfile => $coordsOutfile
		);
	
	# Parse coords outfile.
	open(COORDS, "$coordsOutfile") or confess "\tERROR: Could not open $coordsOutfile";
	my $parser = Kea::Parsers::Mummer::Nucmer::ShowCoords::Parser->new;
	my $handler =  Kea::Utilities::ContigSorter::_Handler->new;
	$parser->parse(*COORDS, $handler);
	close(COORDS);
	
	# Retrieve data from handler.
	my %idHash = $handler->getHash;
	
	# Create hash with id as key and orientation as value.
	my %orientations;
	foreach my $id (keys %idHash) {
		$orientations{$id} = $idHash{$id}->[1];
		}
	# Store.
	$self->{_orientations} = \%orientations;
	
	# Get % match info also.
	my %percentMatches;
	foreach my $id (keys %idHash) {
		$percentMatches{$id} = $idHash{$id}->[2];
		}
	$self->{_percentMatches} = \%percentMatches;
	
	# Sort contig ids according to start position.
	my @sortedIDs = sort {$idHash{$a}->[0] <=> $idHash{$b}->[0]} (keys %idHash);
	
	# Get list of ids of those contigs which could not be ordered.
	my @allIDs = $contigSequenceCollection->getIDs;
	my @unsortedIDs;
	
	foreach my $id (@allIDs) {
		if (!$existsInArray->($id, @sortedIDs)) {
			push(@unsortedIDs, $id);
			}
		}
	
	# Store.
	$self->{_orderedIDs} = \@sortedIDs;
	$self->{_unorderedIDs} = \@unsortedIDs;
	
	# Delete all tmp files.
	unlink($referenceInfile);
	unlink($queryInfile);
	unlink($coordsOutfile);
	unlink($clusterOutfile);
	unlink($deltaOutfile);
	
	} # End of method.

################################################################################

package Kea::Utilities::ContigSorter::_Handler;
use Kea::Parsers::Mummer::Nucmer::ShowCoords::AbstractHandler;
our @ISA = "Kea::Parsers::Mummer::Nucmer::ShowCoords::AbstractHandler";

use constant TRUE => 1;
use constant FALSE => 0;

use constant SENSE => "sense";
use constant ANTISENSE => "antisense";

use strict;
use warnings;
use Carp;
use POSIX;

sub new {
	my $className = shift;
	my $self = {};
	bless($self,$className);
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
		$contigID		# second TAG - contig id.
		) = @_;
	
	# Determine orientation and hence start relative to guide.
	my $orientation = SENSE;
	my $start = $S1;
	if ($S2 > $E2) {
		$orientation = ANTISENSE;
		$start = $E1;
		} 
	
	# If already come across current contig.
	if (exists $self->{_hash}->{$contigID}) {
	
		# Add data to arrays stored in hash allocated to contig.
		push(@{$self->{_hash}->{$contigID}->{positions}}, $start);
		push(@{$self->{_hash}->{$contigID}->{orientations}}, $orientation);
		push(@{$self->{_hash}->{$contigID}->{percentMatches}}, $percentIDY);
	
		}
	
	else {
		$self->{_hash}->{$contigID} = {
			positions => [$start],
			orientations => [$orientation],
			percentMatches => [$percentIDY]
			}
		
		
		} 
	
	
	
	
	} # End of method.
		
sub getHash {
	my $self = shift;

	# First get data stored in hash.
	my @ids = keys %{$self->{_hash}};
	
	my %finalHash;
	
	
	foreach my $id (@ids) {
	
		my @positions;
		my @orientations;
		my @percentMatches;
	
		@positions = @{$self->{_hash}->{$id}->{positions}};
		@orientations =  @{$self->{_hash}->{$id}->{orientations}};
		@percentMatches = @{$self->{_hash}->{$id}->{percentMatches}};
		
		print "Contig ID: $id\n";
		print "==================================\n";
		
		# Now summarise each match and store in new hash.
		
		# THIS CODE FOR FINDING THE EARLIEST POSITION.
#		@positions = sort {$a <=> $b} @positions;
#		my $finalPosition = $positions[0];
#		print "Positions: @positions --- final position = $finalPosition\n";
		
		# THIS CODE FOR FINDING THE MEDIAN POSITION.
		my $finalPosition = $self->median(@positions);
		# Convert to integer (crude).
		#$finalPosition =~ s/\.\d+//;
		print "Positions: @positions --- median position = $finalPosition\n";

		
		my $meanPercentMatch = $self->mean(@percentMatches);
#		my $sum = 0;
#		foreach my $percentMatch (@percentMatches) {
#			$sum = $sum + $percentMatch;
#			}
#		$meanPercentMatch = $sum/scalar(@percentMatches);
		# Round up.
		$meanPercentMatch = sprintf("%.1f", $meanPercentMatch);
		print "Percent matches: @percentMatches --- mean = $meanPercentMatch\n";
		
		my $finalOrientation;
		my $counter = 0;
		my $n = scalar(@orientations);
		foreach my $orientation (@orientations) {
			if ($orientation eq SENSE) {$counter++;}
			}
		# If more than half are sense then assume sense.
		if ($counter >= $n/2) {$finalOrientation = SENSE;} else {$finalOrientation = ANTISENSE;}
		print "Sense: @orientations --- final = $finalOrientation\n\n";
		
		$finalHash{$id} = [$finalPosition, $finalOrientation, $meanPercentMatch];
		}
	
	
	return %finalHash;
	} # End of method.	

sub mean {
	my ($self, @data) = @_;
	
	my $n = scalar(@data);
	my $sum = 0;
	foreach my $x (@data) {
		$sum = $sum + $x;
		}
	
	return $sum/$n;
	
	} # End of method.
	
sub median {
	my ($self, @data) = @_;
	
	my $n = scalar(@data);
	
	if ($n == 0) {die "Cannot calculate median!";}
	
	elsif ($n == 1) {return $data[0];}
	
	# If odd
	elsif ($n % 2) {
	
		my $i = floor($n/2);
		return $data[$i];
		
		}
	# If even
	else {
		
		
		my $i = $n/2;
		my $j = $i-1;
		
		return ($data[$i] + $data[$j])/2;
		
		}
	
	
	
	} # end of method.	
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

