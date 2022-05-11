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
package Kea::Assembly::_Contig;
use Kea::Object;
use Kea::Assembly::IContig;
our @ISA = qw(Kea::Object Kea::Assembly::IContig);

use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";

my $GAP			= "-";
my $WHITESPACE 	= " ";
my $DIFF 		= "*";
my $NO_DIFF 	= " ";

my $MULTIPLE_ALLELE	= "X";
my $PADDING			= 30;

use Kea::Sequence::SequenceCollection;
use Kea::Sequence::SequenceFactory;
use Kea::Alignment::AlignmentFactory;

use Kea::Assembly::Newbler::AllDiffs::SummaryLineFactory;
use Kea::Assembly::Newbler::AllDiffs::AlignmentLineFactory;
use Kea::Assembly::Newbler::AllDiffs::AlignmentLineCollection;
use Kea::Assembly::Newbler::AllDiffs::DiffRegionCollection;
use Kea::Assembly::Newbler::AllDiffs::DiffRegionFactory;
use Kea::IO::Location;
use Kea::Number;

use Kea::Alignment::Aligner::AlignerFactory;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	my $className = shift;
	
	my %args = @_;
	
	my $contigName 				= Kea::Object->check($args{-contigName});			
	my $numberOfBases 			= Kea::Object->check($args{-numberOfBases});		
	my $numberOfReads 			= Kea::Object->check($args{-numberOfReads}); 		
	my $numberOfBaseSegments 	= Kea::Object->check($args{-numberOfBaseSegments});
	# U (uncomplemented) or C (complemented).
	my $UorC 					= Kea::Object->check($args{-UorC});					
	my $paddedConsensus			= Kea::Object->check($args{-paddedConsensus});
	my $qualityScores			= Kea::Object->check($args{-qualityScores});
	my $readCollection			= Kea::Object->check($args{-readCollection});
	
	if ($numberOfBases != length($paddedConsensus)) {
	
		Kea::Object->throw(
			"Length of padded consensus (" .
			length($paddedConsensus) . 
			") does not equal reported number of bases (" .
			$numberOfBases . 
			")."
			);
		
		}
	
	#ÊProcess orientation.
	my $orientation = undef;
	if ($UorC =~ /^U$/i) {
		$orientation = SENSE;
		}
	elsif ($UorC =~ /^C$/i) {
		$orientation = ANTISENSE;
		}
	else {
		Kea::Object->throw("Expecting U or C: " . $UorC . ".");
		}
	
	
	# Check that variables agree.
	my $consensus = $paddedConsensus;
	$consensus =~ s/$GAP//g;
	
	if (length($consensus) != scalar(@$qualityScores)) {
		Kea::Object->throw(
			"Number of quality scores (" .
			scalar(@$qualityScores) . 
			") does not match length of contig sequence (" .
			length($consensus) . 
			")."
			);
		} 
	
	
	my $self = {
	
		_contigName 			=> $contigName,
		_numberOfBases 			=> $numberOfBases,
		_numberOfReads 			=> $numberOfReads,
		_numberOfBaseSegments 	=> $numberOfBaseSegments,
		_orientation	 		=> $orientation,
		_paddedConsensus 		=> $paddedConsensus,
		_consensus 				=> $consensus,
		_qualityScores 			=> $qualityScores,
		_readCollection 		=> $readCollection
		
		};
	
	bless(
		$self,
		$className
		);
	
	return $self;
	
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

# Expand regions identified in diff line into single blocks, each block
# representing a particular difference.
my $postProcessDiffLine = sub {
	
	my $self = shift;
	
	my @baseSummary = split("", uc(shift));
	my @diffLine = split("", shift);
	
	for (my $i = 0; $i < @baseSummary; $i++) {
		
		next if $diffLine[$i] ne $DIFF; 
		
		my $diffBase = $baseSummary[$i];
		
		#ÊForward direction.
		for (my $j = $i; $j < @baseSummary; $j++) {
			if ($diffBase eq $baseSummary[$j]) {
				$diffLine[$j] = $DIFF;
				}
			else {
				last;
				}
			}
		# Reverse direction.
		for (my $j = $i; $j >= 0; $j--) {
			if ($diffBase eq $baseSummary[$j]) {
				$diffLine[$j] = $DIFF;
				}
			else {
				last;
				}
			}
		
		}
	
	return join("", @diffLine);
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

# Returns ref to array of rows (= alleles) from column array input.
my $getRows = sub {
	
	my $self 	= shift;
	
	# Array of column objects representing the difference region of interest
	# (with non-relevant columns already removed).
	my $columns = $self->checkIsArrayRef(shift); 
	
	# get first column (all columns assumed to be the same length).
	my $firstColumn = $columns->[0];
	
	# Generate array of row strings.
	my @rows;
	for (my $i = 0; $i < $firstColumn->getSize; $i++) {
		my $row = "";
		foreach my $column (@$columns) {
			$row .= $column->getBaseAt($i);
			}
		# Note: some bases may be lower case (from contig) - convert all to uc.
		push(@rows, uc($row));
		}
	
	return \@rows;
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

# Generates diff string highlighting the current difference region ONLY. 
my $tempDiffString = sub {
	
	my $self = shift;
	
	# Diff location within padded consensus, start = 0.
	my $location = $self->check(shift, "Kea::IO::Location");  
	
	my $string = "";
	for (1..$location->getStart) {
		$string .= $NO_DIFF;
		}
	for ($location->getStart..$location->getEnd) {
		$string .= $DIFF;
		}
	
	return $string;
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

# Returns true if supplied column is to be ignored (i.e., has identical bases,
# or only one base difference).
my $ignoreColumn = sub {
	
	my $self = shift;
	my $column = shift;
	my $alignment = shift;
	
	my $readCollection = $self->getReadCollection;
	
	# ignore column with no difference.
	return TRUE if $column->hasIdenticalBases;
		
	## If column has only one base difference - see whether that base represents
	## multiple reads.
	#if ($column->differsByNoMoreThanOneBase) {
	#	
	#	# Column differs by one base...
	#	my $minorityBase = $column->getMinorityBase;
	#	my $majorityBase = $column->getMajorityBase;
	#	
	#	#ÊFind index number for that base.
	#	for (my $j = 0; $j < $column->getSize; $j++) {
	#		if ($minorityBase eq $column->getBaseAt($j)) {
	#		
	#			# Get name of responsible seq.
	#			my $readName = $alignment->getLabel($j);
	#		
	#			# if j = 0, then contig so don't ignore column
	#			# (though why contig should be different???).
	#			if ($j == 0) {
	#				
	#				$self->warn(
	#					"All reads are identical at this point ($majorityBase) " .
	#					"yet $readName differs ($minorityBase) - ignoring."
	#					);
	#				return TRUE;
	#				}
	#		
	#			# Get responsible read.
	#			my $read = $readCollection->getReadWithName($readName);
	#			
	#			# Ignore column if read responsible for single base difference
	#			# does NOT represent multiple reads (i.e. the base difference
	#			# is worth persuing further).
	#			return TRUE if !$read->hasDuplicateReads;
	#		
	#			}
	#		}
	#	
	#	}
	
	return FALSE;
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

# Returns ref to array of column objects identified by diff location object
# within padded consensus.ÊNote: Ignores singleton columns.
my $getColumns = sub {
	
	my $self = shift;
	
	# Diff location within padded consensus, start = 0.
	my $location 	= $self->check(shift, "Kea::IO::Location");  
	my $alignment 	= $self->check(shift, "Kea::Alignment::IAlignment");
	
	my @columns;
	for (my $i = $location->getStart; $i <= $location->getEnd; $i++) {
	
		my $column = $alignment->getColumnAt($i);
		
		next if $self->$ignoreColumn($column, $alignment);
	
		push(
			@columns,
			$alignment->getColumnAt($i)
			);
		}
	
	return \@columns;
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

# Returns position key for supplied padded sequence string.
my $getPositionKey = sub {
	
	my $self = shift;
	my @paddedSeq = split("", shift);
	
	my @positionKey;
	my $realPosition = 0;
	$positionKey[0] = 0;
	for (my $i = 0; $i < @paddedSeq; $i++) {
	
		if ($paddedSeq[$i] ne $GAP && $paddedSeq[$i] ne $WHITESPACE) {
			$realPosition++;	
			}
	
		push(@positionKey, $realPosition); 
		}
	
	return \@positionKey;
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

# Calculates correct 'true' position for read.
my $getCorrectReadLocation = sub {
	
	my $self 				= shift;
	my $alignment 			= shift;
	my $read 				= shift;
	my $diffRegionLocation 	= shift; 	# Location of diff region relative to
										# consensus and hence alignment.
	

	#ÊGet aligned sequence string for current read.
	my $alignedSeq = $alignment->getSequenceWithId($read->getName);
	
	# Create position key for this sequence string.
	my $key = $self->$getPositionKey($alignedSeq);
	
	# Define true (ungapped) start and stop position within read.
	my $start = $key->[$diffRegionLocation->getStart];
	my $end = $key->[$diffRegionLocation->getEnd];
	
	#ÊCreate location object taking into account read orientation.
	my $orientation = $read->getOrientation;
	if ($orientation eq SENSE) {
		$start += $read->getRegionOfInterest->getStart;
		$end += $read->getRegionOfInterest->getStart;
		
		return Kea::IO::Location->new(
			$start,
			$end - 1
			);
		}
	else {
		$start = $read->getRegionOfInterest->getEnd - $start;
		$end = $read->getRegionOfInterest->getEnd - $end;
		
		return Kea::IO::Location->new(
			$end + 1,
			$start
			);
		
		}
	
	}; # End of method.


#///////////////////////////////////////////////////////////////////////////////

my $createAlignmentLineCollection = sub {
	
	my $self = shift;
	my $alignment = shift;
	my $diffRegionLocation = shift;
	my $alignmentBlock = shift;
	my $readCollection = shift;
	my $names = shift;
	
	
	my $readCount = 0;
	
	my $alignmentLineCollection =
		Kea::Assembly::Newbler::AllDiffs::AlignmentLineCollection->new("");

		
	#ÊIf no read-names associated with contig allele this means all reads
	# DIFFER from contig at this difference location - this is possible if
	#Êcontig allele contains one or more degenerate bases.
	
	if (defined $names) {	
	
		# Process each read in turn and add to collection.
		for (my $i = 0; $i < @$names; $i++) {
		
			# Retrieve read object from read collection corresponding to read name.
			my $read = $readCollection->getReadWithName($names->[$i]);
			
			#ÊIncrement count (taking into account duplicate reads).
			$readCount ++;
			if ($read->hasDuplicateReads) {
				$readCount += scalar(@{$read->getDuplicateReads});
				}
			
			# Retrieve position information for section of read actually used in
			# assembly - i.e., newbler assembler partial reads.
			my $readRegion =  $read->getRegionOfInterest;
			
			
			
			#############################
			#############################
			
			# Create location object representing the true start and stop
			# positions within read.
			my $correctReadLocation = $self->$getCorrectReadLocation(
				$alignment,
				$read,
				$diffRegionLocation
				);
			#############################
			#############################
				
			my $duplicateCount = undef;	
			if ($read->hasDuplicateReads) {
				$duplicateCount = scalar(@{$read->getDuplicateReads}) + 1;
				}	
			
			# Create alignment line and add to alignment line collection.
			$alignmentLineCollection->add(
				Kea::Assembly::Newbler::AllDiffs::AlignmentLineFactory->createAlignmentLine(
					-id 			=> $read->getAccession,
					-number 		=> $duplicateCount,
					-location 		=> $correctReadLocation,
					-orientation 	=> $read->getOrientation,
					-sequence 		=> $alignmentBlock->getSequenceWithId($names->[$i])
					)
				);
			}
	
		}
	
	
	return ($alignmentLineCollection, $readCount);
	
	}; #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

my $createDiffRegion = sub {
	
	my $self 				= shift;
	my $diffLocation 		= shift; # Location of diff relative to padded consensus, start = 0.
	my $alignment 			= shift;
	my $positionKey			= shift; # Hash mapping positions in padded consensus to consensus without gaps.
	
	
	my $readCollection = $self->getReadCollection;
	
	
	# Get list of contig + read names.
	my @labels = $alignment->getLabels;
	
	
	#===========================================================================
	# Get columns at difference (screening out single-base columns or those with
	# only one base difference - and hence assumed to be sequencing error).
	my $columnObjects = $self->$getColumns($diffLocation, $alignment);
	
	# no further action if no suitable columns identified for region (
	# i.e. only one base difference per column - interpreted as sequencing error).
	return if scalar @$columnObjects == 0;
	
	# Convert difference columns into rows (and hence 'alleles').
	my @alleles = @{$self->$getRows($columnObjects)};
	#===========================================================================
	

	
	# Get consensus 'allele' - as represented by first row of column
	# block.
	my $contigAllele = $alleles[0]; 	#ÊConsensus stored at i = 0.
	$contigAllele =~ s/$GAP//g;	# Remove gap characters
	$contigAllele = $GAP if length($contigAllele) == 0; # sequence only gaps therefore represent by single gap. 
	
	
	

	# Identify all posible row types ('alleles') within reads.
	my %alleleCounts; 					# Stores No. of reads with allele.
	my %readsWithAllele;				# Stores names of reads with allele. 
	$alleleCounts{$contigAllele} = 0; 	# Initialise here just in case no reads shares consensus allele.
	#===========================================================================
	for (my $i = 1; $i < @alleles; $i++) { # Note ignore consensus hence i = 1.
		
		my $allele = $alleles[$i];
		my $read = $labels[$i];
		
		#ÊRemove gap characters from allele.
		$allele =~ s/$GAP//g;
		$allele = $GAP if length($allele) == 0; # one gap if all gaps.
		
		# ignore rows with whitespace.
		next if $allele =~ /$WHITESPACE/;
		
		# ignore rows with Ns.
		next if $allele =~ /N/i;
		
		#ÊStore in hash as key with occurence freq. as value.
		if (exists $alleleCounts{$allele}) {
			$alleleCounts{$allele}++;
			}
		else {
			$alleleCounts{$allele} = 1;
			}
		# Store read name against allele.
		push(@{$readsWithAllele{$allele}}, $read);
		
		} # End of for - no more rows/alleles to process.
	#===========================================================================
	
	
	
	# Scenarios:
	# 1) One alternative allele to that of consensus.
	# 2) More than one alternative allele.
	# 3) No alternative allele.

	
	# Generate list of alternative alleles.
	my @altAlleles;
	my @keys = keys %alleleCounts;
	foreach my $allele (@keys) {
		if ($allele ne $contigAllele) { # Don't store contig allele
			push(@altAlleles, $allele);
			}	
		}
	
	#ÊNo further action if no alternative alleles (scenario 3).
	return if @altAlleles == 0;
	


	
	# Two scenarios:
	# 1) Only one alternative allele to that represented in consensus.
	# 2) More than one alternative.
	
	
	#ÊONE ALTERNATIVE ALLELE
	#========================
	
	# Note that AllDiffs style outfile can only represent ONE alternative
	# allele, therefore if more than one for a particular site, need to
	# summarise.
	my $altAllele;
	if (@altAlleles == 1) {
		$altAllele = $altAlleles[0];
		}
	
	
	
	# MULTIPLE ALTERNATIVE ALLELES
	#==============================
	
	# Generate summary data for multiple alleles.
	else {
		$altAllele = "[" . join(", ", @altAlleles) . "]"; #$MULTIPLE_ALLELE;
		
		my $summaryCount = 0;
		my @summaryReadArray;
		
		foreach my $altAllele (@altAlleles) {
			$summaryCount += $alleleCounts{$altAllele};
			foreach my $read (@{$readsWithAllele{$altAllele}}) {
				push(@summaryReadArray, $read);
				}
			}
		
		$alleleCounts{$altAllele} = $summaryCount;
		$readsWithAllele{$altAllele} = \@summaryReadArray;
		}
	
	
	
	# Create diff string for current diff region (i.e. diff string that only
	# identifies current diff location with ****).
	my $tempDiffString = $self->$tempDiffString($diffLocation);

	
	# Create location object representing location of difference within
	# true, ungapped consensus, note start = 0.
	my $trueDiffLocation = Kea::IO::Location->new(
		$positionKey->[$diffLocation->getStart],
		$positionKey->[$diffLocation->getEnd]
		);
	

	
	# decide length of sequence fragments for diff region to display.
	# Location relative to ungapped consensus (and hence refers to full alignment)
	#===========================================================================
	
	# Initialise with full padded consensus (full size of alignment).
	my $diffRegionLocation = Kea::IO::Location->new(0, $self->getPaddedSize-1);
	
	# Controls padding-sequence around diff.
	my $padding = $PADDING;
	
	# Amend start depending on location of current diff.
	if ($diffLocation->getStart - $padding > 0) {
		$diffRegionLocation->setStart(
			$diffLocation->getStart - $padding
			);
		}

	#ÊAmend end.
	if ($diffLocation->getStart + $padding < $diffRegionLocation->getEnd) {
		$diffRegionLocation->setEnd($diffLocation->getStart + $padding);
		}
	#===========================================================================
	
	#ÊGet alignment block for region identified.
	my $alignmentBlock =
		$alignment->getAlignmentBlock(
			$diffRegionLocation
			);
	
	
	# Trim diff string to correspond with identified region.
	my $diffSubstring =
		join(
			"",
			substr($tempDiffString, $diffRegionLocation->getStart)
			);
	
	
	
	
	
	
	#===========================================================================
	
	my ($readsWithDifference, $readsWithDifferenceCount) =
		$self->$createAlignmentLineCollection(
			$alignment,
			$diffRegionLocation,
			$alignmentBlock,
			$readCollection,
			$readsWithAllele{$altAllele}
			);
	
	
	my ($otherReads, $otherReadsCount) =
		$self->$createAlignmentLineCollection(
			$alignment,
			$diffRegionLocation,
			$alignmentBlock,
			$readCollection,
			$readsWithAllele{$contigAllele}
			);
	
	#===========================================================================
	
	
	
	# 1) Create summary line:
	#===========================================================================
	
	# Position of allele within consensus.
	my $x = $trueDiffLocation->getStart + 1;# Start = start of difference block originally identified + 1 (now, start = 1)
	
	
	
	
	my $alleleLocation =
		Kea::IO::Location->new(
			$x,		
			$x + length($contigAllele) - 1 # End accomodates length of consensus allele.
			);
	
	
	
	
	# Counts etc.
	my $var = $readsWithDifferenceCount;
	my $tot = $var + $otherReadsCount;
	my $percent = ($var / $tot) * 100; 
	$percent = Kea::Number->roundup($percent, 0);
	
	
	
	
	
	# Determine number of sense and antisense for reads with difference.
	#---------------------------------------------------------------------------
	my $readnames = $readsWithAllele{$altAllele};
	
	my $fwd = 0;
	my $rev = 0;
	foreach my $readname (@$readnames) {
		my $read = $readCollection->getReadWithName($readname);
		if ($read->getOrientation eq SENSE) {
			$fwd++;
			
			if ($read->hasDuplicateReads) {
				$fwd += scalar(@{$read->getDuplicateReads});
				}
			
			}
		else {
			$rev++;
			
			if ($read->hasDuplicateReads) {
				$rev += scalar(@{$read->getDuplicateReads});
				}
			
			}
		}
	#---------------------------------------------------------------------------
	
	
	
	
	
	
	# Create summary line.
	my $summaryLine =
		Kea::Assembly::Newbler::AllDiffs::SummaryLineFactory->createSummaryLine(
			-refId 		=> $self->getName,
			-location	=> $alleleLocation,
			-oldSeq		=> $contigAllele,
			-newSeqs	=> [$altAllele],
			-fwd		=> $fwd,
			-rev		=> $rev,
			-var		=> $var,
			-tot		=> $tot,
			-percent	=> $percent
			);
		
	#===========================================================================

	

	# 2) Create contig alignment line.
	#===========================================================================
	
	
	
	
	my $contigAlignmentLine =
		Kea::Assembly::Newbler::AllDiffs::AlignmentLineFactory->createAlignmentLine(
			-id 			=> $self->getName,
			-number 		=> undef,
			-location 		=> Kea::IO::Location->new(
										$positionKey->[$diffRegionLocation->getStart+1], # Determine start and end of block within unedited consensus.
										$positionKey->[$diffRegionLocation->getEnd]
										),
			-orientation 	=> SENSE,
			-sequence 		=> $alignmentBlock->getSequence(0)
			);
	
	#===========================================================================
	
	
	
	
	
	
	
	# Finally, create diff region object from various component objects created
	# above and return.
	my $diffRegion = Kea::Assembly::Newbler::AllDiffs::DiffRegionFactory->createDiffRegion(
		-summaryLine 			=> $summaryLine,
		-reference				=> $contigAlignmentLine,
		-readsWithDifference 	=> $readsWithDifference,
		-otherReads 			=> $otherReads,
		-differenceString 		=> $diffSubstring
		);
	
	return $diffRegion;
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

# Location objects representing difference regions as indicated by difference
# string. start = 0.
sub getDifferenceLocations {
	
	my $self = shift;
	my $differenceString = $self->getDifferenceString;
	
	my @chars = split("", $differenceString);
	
	# Identify difference regions and create location object for each.
	my @locations;
	my $currentLocation = undef;
	for (my $i = 0; $i < @chars; $i++) {
		
		# Start of diff block.
		if ($chars[$i] eq $DIFF && !defined $currentLocation) {
			$currentLocation = Kea::IO::Location->new($i, $i);
			}
		
		# Mid diff block.
		elsif ($chars[$i] eq $DIFF && defined $currentLocation) {
			$currentLocation->incrementEnd;
			}
		
		# End of diff block.
		elsif ($chars[$i] ne $DIFF && defined $currentLocation) {
			push(@locations, $currentLocation);
			$currentLocation = undef;
			}
		else {
			# No diff - do nothing.
			}
		} 

	
	return \@locations;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getDiffRegionCollection {
	
	my $self = shift;
	
	my %args = @_;
	
	
	# Calling functions once here and passing reference to subsequent functions.
	my $positionKey = $self->getPositionKey;
	my $alignment;
	if (defined $args{-compact} && $args{-compact} == TRUE) {
		$alignment = $self->getAlignmentWithoutDuplicates;
		}
	else {
		$alignment = $self->getAlignment;
		}
	
	
	# Initialise diff region collection object.
	my $diffRegionCollection =
		Kea::Assembly::Newbler::AllDiffs::DiffRegionCollection->new("");
	
	
	
	
	# Identify difference locations and create diff region object for each.
	my $diffLocations = $self->getDifferenceLocations;
	foreach my $location (@$diffLocations) {
		my $diffRegion = $self->$createDiffRegion(
			$location,		# Location relative to padded consensus, start = 0.
			$alignment, 	# alignment representation of consensus + reads
			$positionKey 	# padded positions mapped to true, unpadded consensus.
			);
		
		if (defined $diffRegion) {
			$diffRegionCollection->add($diffRegion);
			}
		
		}
	
	
	# Return diff region collection.
	return $diffRegionCollection;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# Returns alignment with duplicate reads reduced to one.
sub getAlignmentWithoutDuplicates {
	
	my $self = shift;
	my $readCollection = $self->getReadCollection;
	
	#ÊFirst create new summary read collection.
	my $simplifiedReadCollection = $readCollection->getSimplifiedReadCollection;
	
	my $readAlignment = Kea::Alignment::AlignmentFactory->createAlignment(
		$simplifiedReadCollection
		);
	
	my $sequenceCollection = Kea::Sequence::SequenceCollection->new("");
	$sequenceCollection->add(
		Kea::Sequence::SequenceFactory->createSequence(
			-id 		=> $self->getName,
			-sequence 	=> $self->getPaddedConsensus
			)
		);
	
	my $readSequenceCollection = $readAlignment->getSequenceCollection;
	
	
	for (my $i = 0; $i < $readSequenceCollection->getSize; $i++) {
		$sequenceCollection->add(
			$readSequenceCollection->get($i)
			);
		
		}	

	
	
	return Kea::Alignment::AlignmentFactory->createAlignment(
		$sequenceCollection
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# Returns alignment object representing alignment of reads alongside contig.
sub getAlignment {
	return Kea::Alignment::AlignmentFactory->createAlignment(shift);
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getReadAlignment {
	return
		Kea::Alignment::AlignmentFactory->createAlignment(
			shift->getReadCollection
			);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# Returns mapping of gapped-contig locations to ungapped 'true' positions. 
sub getPositionKey {
	
	my $self = shift;
	my @paddedConsensus = split("", $self->getPaddedConsensus);
	
	my @positionKey;
	my $realPosition = 0;
	$positionKey[0] = 0;
	for (my $i = 1; $i < @paddedConsensus; $i++) {
		$realPosition++ if $paddedConsensus[$i] ne $GAP;
		push(@positionKey, $realPosition); 
		}
	
	return \@positionKey;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getRealignment {
	
	my $self = shift;
	
	my $sequenceCollection = $self->getAlignment->getUnalignedSequenceCollection;
	
	my $aligner =
		Kea::Alignment::Aligner::AlignerFactory->createAligner(
			-sequenceCollection => $sequenceCollection,
			-program => "muscle"
			);
	
	$aligner->run;
	return $aligner->getAlignment;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getDifferenceString {
	
	my $self = shift;
	my $n = $self->getPaddedSize;
	my $matrix = $self->getAlignment->getMatrix;
	
	# Create diff line.
	my $baseSummary = "";
	my $diffLine  = "";
	for (my $j = 0; $j < $n; $j++) {
		my $base = undef;
		my $char = $NO_DIFF;
		for (my $i = 0; $i < @$matrix; $i++) {
			if ($matrix->[$i]->[$j] eq $GAP) {
				$char = $DIFF;
				}
			elsif (!defined $base && $matrix->[$i]->[$j] ne $WHITESPACE) {
				$base = $matrix->[$i]->[$j];
				}
			}
		$diffLine .= $char;
		$baseSummary .= $base;
		}
	
	my $finalDiffLine = $self->$postProcessDiffLine(
		$baseSummary,
		$diffLine
		);
	
	return $finalDiffLine;  
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getName {
	return shift->{_contigName};
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getNumberOfBasesInPaddedConsensus {
	return shift->{_numberOfBases};	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getNumberOfReads {
	return shift->{_numberOfReads};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getOrientation {
	return shift->{_orientation};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getPaddedConsensus {

	my $self = shift;
	my $gapChar = shift;

	my $paddedConsensus = $self->check($self->{_paddedConsensus});
	
	if (defined $gapChar) {
		$paddedConsensus =~ s/$GAP/$gapChar/g;
		}
	
	return $paddedConsensus;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getConsensus {
	return shift->{_consensus};
	} # End of method.

# Convenience method.
sub getSequence {
	return shift->{_consensus};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSize {
	return length(shift->{_consensus});
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getPaddedSize {
	return length(shift->{_paddedConsensus});
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getQualityScores {
	return @{shift->{_qualityScores}};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getReadCollection {
	return shift->{_readCollection};
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	my $self = shift;
	
	my $name = $self->getName || "Unknown";
	
	my $numberOfBasesInPaddedConsensus =
		$self->getNumberOfBasesInPaddedConsensus || "Unknown";
		
	my $numberOfReads = $self->getNumberOfReads || "Unknown";
	
	my $orientation = $self->getOrientation || "Unknown";
	
	my $paddedConsensus = $self->getPaddedConsensus || "Unknown";
	
	my $consensus = $self->getConsensus || "Unknown";
	
	my $size = $self->getSize || "Unknown";
	
	my @qualityScores = $self->getQualityScores;
	
	
	#my $qualityString;
	#for (my $i = 0; $i < 50; $i++) {
	#	$qualityString = $qualityString . " $qualityScores[$i]";
	#	}
	
	return sprintf(
		"Contig name = %s\n" .
		"Number of bases = %s\n" .
		"Number of reads = %s\n" .
		"Orientation = %s\n" .
		"Padded consensus:\n%s\n\n" .
		"Consensus:\n%s\n\n" .
		"Size = %s\n" . 
		"Quality scores:\n%s\n\n",
		
		$name,
		$numberOfBasesInPaddedConsensus,
		$numberOfReads,
		$orientation,
		$paddedConsensus, #substr($paddedConsensus, 0, 50) . "...",
		$consensus, #substr($consensus, 0, 50) . "...",
		$size,
		join(" ", @qualityScores) #$qualityString
		);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

