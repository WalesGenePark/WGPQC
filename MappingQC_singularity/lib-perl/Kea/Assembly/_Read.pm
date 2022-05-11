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
package Kea::Assembly::_Read;
use Kea::Object;
use Kea::Assembly::IRead;
our @ISA = qw(Kea::Object Kea::Assembly::IRead);

use strict;
use warnings;

use constant TRUE		=> 1;
use constant FALSE		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
my $GAP = "-";

use Kea::IO::Location;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className 	= shift;
	my %args = @_;
	
	my $self = {
		_readName 		=> Kea::Object->check($args{-name}),
		_region 		=> $args{-region},		# Location object representing region of read of interest, or undef.
		_orientation 	=> $args{-orientation},	# SENSE or ANTISENSE, or undef
		_contig			=> $args{-contig},		#ÊParent contig id, or undef
		_otherContigs	=> $args{-otherContigs},# ref to array of contig ids or undef
		_otherReads		=> $args{-otherReads},	# ref to array of read objects sharing same sequence.
		_paddedRead		=> $args{-sequence}
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

sub getName {
	return shift->{_readName};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAccession {
	
	my $self = shift;
	my $name = $self->getName;
	
	if ($name =~ /^(\w+)\./) {
		return $1;
		}
	else {
		return $name;
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getContig {
	
	my $self = shift;
	my $contig = $self->{_contig};
	
	return $contig if defined $contig;
	
	$self->throw("No contig associated with read '" . $self->getName . "'.");
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getOtherContigs {
	
	my $self = shift;
	my $otherContigs = $self->{_otherContigs};
	
	return $otherContigs if defined $otherContigs;
	
	$self->throw("No other contigs associated with read '" . $self->getName . "'.");
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setDuplicateReads {
	
	my $self = shift;
	my $duplicates = $self->checkIsArrayRef(shift);
	
	$self->{_duplicates} = $duplicates;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasDuplicateReads {
	
	my $self = shift;
	
	if (defined $self->{_duplicates}) {
		return TRUE;
		}
	else {
		return FALSE;	
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getDuplicateReads {
	
	my $self = shift;
	
	if ($self->hasDuplicateReads) {
		return $self->{_duplicates};
		}
	else {
		$self->throw(
			"No duplicates associated with read '" .
			$self->getName . 
			"'."
			);
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# Returns region of UNGAPPED read that has contributed to consensus.
sub getRegionOfInterest {
	
	my $self = shift;
	my $region = $self->{_region};
	
	return $region if defined $region;
	
	# No region set so assume full length is region of interest.
	return Kea::IO::Location->new(
		1,
		length($self->getRead)
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# Returns mapping of gapped-read locations to ungapped 'true' read positions. 
sub getPositionKey {
	
	my $self = shift;
	my @paddedRead = split("", $self->getPaddedRead);
	
	my @positionKey;
	my $realPosition = 0;
	$positionKey[0] = 0;
	for (my $i = 1; $i < @paddedRead; $i++) {
		$realPosition++ if $paddedRead[$i] ne $GAP;
		push(@positionKey, $realPosition); 
		}
	
	return \@positionKey;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setNumberOfPaddedBases {
	
	my $self 	= shift;
	my $n 		= $self->checkIsInt(shift);
	
	# Commented out due to read listed multiple times (different sections) in
	# ace file, therefore _paddedRead defined but for different region hence
	# different length.
	
	if (defined $self->{_paddedRead}) {
		if ($n != length($self->{_paddedRead})) {
			$self->throw(
				$self->getName . " " . $self->getRegionOfInterest->toString . ":\n" . 
				"\tPadded read length (" .
				length($self->{_paddedRead}) .
				") does not equal number of padded bases (" .
				$n .
				")."
				);
			}
		}
	
	$self->{_numberOfPaddedBases} = $n;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getNumberOfPaddedBases {

	my $self = shift;
	return $self->check($self->{_numberOfPaddedBases});
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setNumberOfReadTags {
	
	my $self 	= shift;
	my $n 		= $self->checkIsInt(shift);
	
	$self->{_numberOfReadTags} = $n;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getNumberOfReadTags {

	my $self = shift;
	return $self->check($self->{_numberOfReadTags});

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setNumberOfWholeReadInfoItems {
	
	my $self	= shift;
	my $n 		= $self->checkIsInt(shift);
	
	$self->{_numberOfWholeReadInfoItems} = $n;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getNumberOfWholeReadInfoItems {

	my $self = shift;
	return $self->check($self->{_numberOfWholeReadInfoItems});

	} # End of metod.

#///////////////////////////////////////////////////////////////////////////////

sub setPaddedRead {
	
	my $self 		= shift;
	my $paddedRead 	= $self->check(shift);
	
	if (defined $self->{_numberOfPaddedBases}) {
		if ($self->{_numberOfPaddedBases} != length($paddedRead)) {
			$self->throw(
				"Padded read length (" . length($paddedRead) .
				") does not equal number of padded bases (" .
				$self->{_numberOfPaddedBases} .
				")."
				);
			}
		}
	
	$self->{_paddedRead} = $paddedRead;
	
	my $read = $paddedRead;
	$read =~ s/$GAP//g;
	$self->{_read} = $read;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getPaddedRead {
	
	my $self = shift;
	my $gapChar = shift;
	
	if (!defined $self->{_paddedRead}) {
		$self->throw("No padded read for " . $self->getName . " " . $self->getRegionOfInterest->toString  . ".");
		}
	
	my $paddedRead = $self->check($self->{_paddedRead});
	
	if (defined $gapChar) {
		$paddedRead =~ s/$GAP/$gapChar/g;
		}

	return $paddedRead;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getRead {

	my $self = shift;
	return $self->check($self->{_read});
	
	} # End of method.

sub getSequence {
	return shift->getRead;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setOrientation {
	
	my $self 		= shift;
	my $orientation = $self->check(shift);
	
	if ($orientation ne SENSE && $orientation ne ANTISENSE) {
		$self->throw("Unrecognised argument: $orientation");
		}
	
	$self->{_orientation} = $orientation;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getOrientation {
	
	my $self = shift;
	my $orientation = $self->{_orientation};
	
	return $orientation if defined $orientation;
	
	$self->throw("No orientation associated with read '" . $self->getName . "'.");
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setPaddedStartConsensusPosition {
	
	my $self	= shift;
	my $n 		= $self->checkIsInt(shift);
	
	$self->{_paddedStartConsensusPosition} = $n;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getPaddedStartConsensusPosition {

	my $self = shift;
	return $self->check($self->{_paddedStartConsensusPosition});
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setQualClippingStart {
	my $self = shift;
	$self->{_qualClippingStart} = $self->checkIsInt(shift);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getQualClippingStart {
	my $self = shift;
	return $self->checkIsInt($self->{_qualClippingStart});
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setQualClippingEnd {
	my $self = shift;
	$self->{_qualClippingEnd} = $self->checkIsInt(shift);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getQualClippingEnd {
	my $self = shift;
	return $self->checkIsInt($self->{_qualClippingEnd});
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getQualClipping {
	my $self = shift;
	return Kea::IO::Location->new(
		$self->getQualClippingStart,
		$self->getQualClippingEnd
		);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setAlignClippingStart {
	my $self = shift;
	$self->{_alignClippingStart} = $self->checkIsInt(shift);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAlignClippingStart {
	my $self = shift;
	return $self->checkIsInt($self->{_alignClippingStart});
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setAlignClippingEnd {
	my $self = shift;
	$self->{_alignClippingEnd} = $self->checkIsInt(shift);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAlignClippingEnd  {
	my $self = shift;
	return $self->checkIsInt($self->{_alignClippingEnd});
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAlignClipping {
	my $self = shift;
	return Kea::IO::Location->new(
		$self->getAlignClippingStart,
		$self->getAlignClippingEnd
		);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSize {
	return length(shift->getRead);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub equals {
	
	my $self = shift;
	my $other = $self->check(shift, "Kea::Assembly::IRead");
	
	if ($self->getNumberOfPaddedBases != $other->getNumberOfPaddedBases) {
		return FALSE;
		}
	
	if ($self->getNumberOfWholeReadInfoItems != $other->getNumberOfWholeReadInfoItems) {
		return FALSE;
		}
	
	if ($self->getNumberOfReadTags != $other->getNumberOfReadTags) {
		return FALSE;
		}
	
	if ($self->getPaddedRead ne $other->getPaddedRead) {
		return FALSE;
		}
	
	if ($self->getRead ne $other->getRead) {
		return FALSE;	
		}
	
	if ($self->getOrientation ne $other->getOrientation) {
		#$self->warn(
		#	"Orientation for '" . $self->getName . 
		#	"' (" . $self->getOrientation . 
		#	") does not match that of '" . $other->getName . 
		#	"' (" . $other->getOrientation .
		#	").");
		return FALSE;
		}
	
	if ($self->getPaddedStartConsensusPosition != $other->getPaddedStartConsensusPosition) {
		return FALSE;
		}
	
	if ($self->getQualClippingStart != $other->getQualClippingStart) {
		#$self->warn(
		#	"Qual clipping start for '" . $self->getName . 
		#	"' (" . $self->getQualClippingStart . 
		#	") does not match that of '" . $other->getName . 
		#	"' (" . $other->getQualClippingStart .
		#	").");
		return FALSE;
		}
	
	if ($self->getQualClippingEnd != $other->getQualClippingEnd) {
		#$self->warn(
		#	"Qual clipping end for '" . $self->getName . 
		#	"' (" . $self->getQualClippingEnd . 
		#	") does not match that of '" . $other->getName . 
		#	"' (" . $other->getQualClippingEnd .
		#	").");
		return FALSE;
		}
	
	if ($self->getAlignClippingStart != $other->getAlignClippingStart) {
		#$self->warn(
		#	"Align clipping start for '" . $self->getName . 
		#	"' (" . $self->getAlignClippingStart . 
		#	") does not match that of '" . $other->getName . 
		#	"' (" . $other->getAlignClippingStart .
		#	").");
		return FALSE;
		}
	
	if ($self->getAlignClippingEnd != $other->getAlignClippingEnd) {
		#$self->warn(
		#	"Align clipping end for '" . $self->getName . 
		#	"' (" . $self->getAlignClippingEnd . 
		#	") does not match that of '" . $other->getName . 
		#	"' (" . $other->getAlignClippingEnd .
		#	").");
		return FALSE;
		}

	return TRUE;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	my $self = shift;
	
	my $readName 					= $self->getName;
	my $numberOfPaddedBases 		= $self->getNumberOfPaddedBases;
	my $numberOfWholeReadInfoItems 	= $self->getNumberOfWholeReadInfoItems;
	my $numberOfReadTags 			= $self->getNumberOfReadTags;
	my $paddedRead		 			= $self->getPaddedRead;
	my $read	 					= $self->getRead;
	my $orientation 				= $self->getOrientation;
	my $paddedStartConsensusPos		= $self->getPaddedStartConsensusPosition;
	my $qualClippingStart			= $self->getQualClippingStart;
	my $qualClippingEnd				= $self->getQualClippingEnd;
	my $alignClippingStart			= $self->getAlignClippingStart;
	my $alignClippingEnd			= $self->getAlignClippingEnd;
	
	return
		"Read name = $readName\n" .
		"Number of padded bases = $numberOfPaddedBases\n" .
		"Number of whole read info items = $numberOfWholeReadInfoItems\n" .
		"Number of read tags = $numberOfReadTags\n" .
		"Orientation = $orientation\n" .
		"Padded start consensus position = $paddedStartConsensusPos\n" .
		"Qual clipping start = $qualClippingStart\n" .
		"Qual clipping end = $qualClippingEnd\n" .
		"Align clipping start = $alignClippingStart\n" .
		"Align clipping end = $alignClippingEnd\n" .
		"Padded read:\n" . $paddedRead . "\n\n" .
		"Read:\n" . $read . "\n\n";
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

