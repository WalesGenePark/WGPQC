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


# CLASS NAME
package Kea::Utilities::ContigRecordSorter;
use Kea::Object;
our @ISA = qw(Kea::Object);

## Purpose		: Sorts contigs relative to reference sequence.

use strict;
use warnings;
use POSIX;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant FASTA 		=> "fasta";
use constant EMBL 		=> "embl";
use constant UNKNOWN 	=> "unknown";
use constant HASH 		=> "HASH";
use constant ARRAY 		=> "ARRAY";

use Kea::IO::Fasta::WriterFactory;
use Kea::ThirdParty::Mummer::_NucmerWrapper;
use Kea::IO::Mummer::ShowCoords::ReaderFactory;
use Kea::IO::Mummer::ShowCoords::IReaderHandler;
use Kea::Sequence::SequenceCollection;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

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

sub setReference {

	my $self 		= shift;
	my $reference 	= $self->check(shift, "Kea::Sequence::ISequence");
	
	$self->{_reference} = $reference;
	
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub setContigs {
	
	my $self 	= shift;
	my $contigs = $self->check(shift, "Kea::IO::RecordCollection");
	
	$self->{_data} = $contigs;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getOrderedAccessions {

	my $self = shift;
	
	if (!exists $self->{_orderedAccessions}) {
		$self->throw("No ordered Accessions - has 'run' been called?");
		}

	my @orderedAccessions = @{$self->{_orderedAccessions}};
	return @orderedAccessions;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasUnorderedAccessions {

	my $self = shift;
	
	if (!exists $self->{_unorderedAccessions}) {
		$self->throw("No unordered accessions - has 'run' been called?");
		}

	my @unorderedAccessions = @{$self->{_unorderedAccessions}};
	if (@unorderedAccessions) {return TRUE;} else {return FALSE;}
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getUnorderedAccessions {
	
	my $self = shift;
	
	if (!exists $self->{_unorderedAccessions}) {
		$self->throw("No unordered accessions - has 'run' been called?");
		}
	
	my @unorderedAccessions = @{$self->{_unorderedAccessions}};
	return @unorderedAccessions;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getOrientationsForOrderedAccessions {

	my $self = shift;
	
	if (!exists $self->{_orientations}) {
		$self->throw("No orientations - has 'run' been called?");
		}

	return %{$self->{_orientations}};

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getPercentMatchesForOrderedAccessions {

	my $self = shift;
	
	if (!exists $self->{_percentMatches}) {
		$self->throw("No percent matches - has 'run' been called?");
		}
	
	return %{$self->{_percentMatches}};
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub run {
	
	my $self = shift;
	
	# Get previously stored input data or throw exception.
	my $contigRecordCollection
		= $self->check($self->{_data}, "Kea::IO::RecordCollection");
	
	my $reference
		= $self->check($self->{_reference}, "Kea::Sequence::ISequence");
	
	
	
	# Create tmp files from these data which will be used by nucmer program.
	my $referenceInfile 	= "TMP_ref.fas";
	my $queryInfile 		= "TMP_query.fas";
	my $coordsOutfile 		= "TMP_coords.outfile";
	my $clusterOutfile 		= "TMP_cluster.outfile";
	my $deltaOutfile 		= "TMP_delta.outfile";
	
	open (QUERY, ">$queryInfile") or $self->throw("Could not create tmp file $queryInfile.");
	my $writer = Kea::IO::Fasta::WriterFactory->createWriter($contigRecordCollection);
	$writer->write(*QUERY);
	close(QUERY) or $self->throw("Could not close $queryInfile.");
	
	open (REF, ">$referenceInfile") or $self->throw("Could not create $referenceInfile.");
	my $writer2 = Kea::IO::Fasta::WriterFactory->createWriter($reference);
	$writer2->write(*REF);
	close(REF) or $self->throw("Could not close $referenceInfile.");
	
	
	# Run nucmer program and parse resulting show-coords program output.
	my $nucmer = Kea::ThirdParty::Mummer::_NucmerWrapper->new;
	$nucmer->run(
		-referenceInfile 	=> $referenceInfile,
		-queryInfile 		=> $queryInfile,
		-deltaOutfile 		=> $deltaOutfile,
		-clusterOutfile 	=> $clusterOutfile,
		-coordsOutfile 		=> $coordsOutfile
		);
	
	
	
	
	
	# Parse coords outfile.
	open(COORDS, "$coordsOutfile") or $self->throw("Could not open $coordsOutfile");
	my $handler =  Kea::Utilities::ContigSorter::_Handler->new;
	my $reader = Kea::IO::Mummer::ShowCoords::ReaderFactory->createReader;
	$reader->read(*COORDS, $handler);
	close(COORDS) or $self->throw("Could not close $coordsOutfile.");
	
	
	
	# Retrieve data from handler.
	my %hash = $handler->getHash;
	
	# Create hash with id as key and orientation as value.
	my %orientations;
	foreach my $accession (keys %hash) {
		$orientations{$accession} = $hash{$accession}->[1];
		}
	# Store.
	$self->{_orientations} = \%orientations;
	
	# Get % match info also.
	my %percentMatches;
	foreach my $accession (keys %hash) {
		$percentMatches{$accession} = $hash{$accession}->[2];
		}
	$self->{_percentMatches} = \%percentMatches;
	
	
	
	
	
	
	# Sort contig primary accessions according to start position.
	my @sortedAccessions = sort {$hash{$a}->[0] <=> $hash{$b}->[0]} (keys %hash);
	
	
	
	
	
	
	# Get list of ids of those contigs which could not be ordered.
	my @allAccessions = $contigRecordCollection->getPrimaryAccessions;
	
	my @unsortedAccessions;
	
	foreach my $accession (@allAccessions) {
		if (!$existsInArray->($accession, @sortedAccessions)) {
			push(@unsortedAccessions, $accession);
			}
		}
	
	
	
	
	
	# Store.
	$self->{_orderedAccessions} = \@sortedAccessions;
	$self->{_unorderedAccessions} = \@unsortedAccessions;
	
	# Delete all tmp files.
	unlink ($referenceInfile);
	unlink ($queryInfile);
	unlink ($coordsOutfile);
	unlink ($clusterOutfile);
	unlink ($deltaOutfile);
	
	} # End of method.

################################################################################

package Kea::Utilities::ContigSorter::_Handler;
use Kea::Object;
use Kea::IO::Mummer::ShowCoords::IReaderHandler;
our @ISA = qw(
	Kea::Object
	Kea::IO::Mummer::ShowCoords::IReaderHandler
	);

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;

use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";

use strict;
use warnings;
use POSIX;







sub new {
	my $className = shift;
	my $self = {};
	bless($self,$className);
	return $self;
	} # End of constructor.





sub _nextLine {
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
			positions 		=> [$start],
			orientations 	=> [$orientation],
			percentMatches 	=> [$percentIDY]
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
	
		@positions 		= @{$self->{_hash}->{$id}->{positions}};
		@orientations 	= @{$self->{_hash}->{$id}->{orientations}};
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

