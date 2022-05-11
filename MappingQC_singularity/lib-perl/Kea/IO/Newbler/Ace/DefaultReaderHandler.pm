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
package Kea::IO::Newbler::Ace::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::Newbler::Ace::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::Newbler::Ace::IReaderHandler);

use strict;
use warnings;

use constant TRUE		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
my $GAP					= "-";

use Kea::Assembly::ContigCollection;
use Kea::Assembly::_Contig;
use Kea::Assembly::ReadCollection;
use Kea::Assembly::_Read;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $contigCollection = Kea::Assembly::ContigCollection->new("Unknown");
	
	my $self = {
	
		_contigCollection 	=> $contigCollection,
		_numberOfContigs 	=> undef,
		_totalNumberOfReads => undef,
		
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

sub _nextAS {
	my (
		$self,
		$numberOfContigs,	# Number of contigs.
		$totalNumberOfReads	# Total number of reads in ace file.
		) = @_;
	
	$self->{_numberOfContigs} = $numberOfContigs;
	$self->{_totalNumberOfReads} = $totalNumberOfReads;
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextCO {
	my (
		$self,
		$contigName,			# Contig name
		$numberOfBases, 		# Number of bases
		$numberOfReads, 		# Number of reads in contig
		$numberOfBaseSegments,	# Number of base segments in contig
		$UorC,					# U (uncomplemented) or C (complemented).
		$paddedConsensusSequence
		) = @_;
	
	if ($numberOfBases != length($paddedConsensusSequence)) {
		$self->throw(
			"Length of padded consensus does not equal " .
			"expected number of bases."
			);
		}
	
	#ÊReplace * with default GAP character.
	$paddedConsensusSequence =~ s/\*/$GAP/g;
	
	$self->{_currentContigName} 				= $contigName;		
	$self->{_currentNumberOfBases} 				= $numberOfBases;
	$self->{_currentNumberOfReads} 				= $numberOfReads;
	$self->{_currentNumberOfBaseSegments} 		= $numberOfBaseSegments;
	$self->{_currentUorC} 						= $UorC;
	$self->{_currentPaddedConsensusSequence} 	= $paddedConsensusSequence;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextBQ {

	my (
		$self,
		$qualityScores
		) = @_;
	
	my $contigCollection = $self->{_contigCollection};
	my $readCollection = Kea::Assembly::ReadCollection->new("Unknown");
	
	my $contig = 
		Kea::Assembly::_Contig->new(
		
			-contigName 			=> $self->{_currentContigName},
			-numberOfBases 			=> $self->{_currentNumberOfBases},
			-numberOfReads 			=> $self->{_currentNumberOfReads},
			-numberOfBaseSegments 	=> $self->{_currentNumberOfBaseSegments},
			-UorC 					=> $self->{_currentUorC},
			-paddedConsensus 		=> $self->{_currentPaddedConsensusSequence},
			-qualityScores 			=> $qualityScores,
			-readCollection 		=> $readCollection
		
			);
		
	$self->{_currentContig} = $contig;	
	
	$contigCollection->add(
		$contig
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextAF {

	my $self        = shift;
    my $readName    = $self->check(shift);  # Read name (uaccno number and location info).
	my $UorC        = $self->check(shift);  # C or U.
	my $paddedStart	= $self->check(shift);  # Padded start consensus position
    
	my $read = Kea::Assembly::_Read->new(-name => $readName);
	
	if ($UorC eq "U") {
		$read->setOrientation(SENSE);
		}
	elsif ($UorC eq "C") {
		$read->setOrientation(ANTISENSE);
		}
	else {
		$self->throw("Unrecognised orientation (expecting U or C): $UorC.");
		}
	
	$read->setPaddedStartConsensusPosition($paddedStart);
	
	
	$self->{_currentContig}->getReadCollection->add($read);
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextBS {
	my (
		$self,
		$paddedStart, 	# padded start consensus position
		$paddedEnd, 	# padded end consensus position
		$readName		# read name (uaccno number plus location info)
		) = @_;
	
	#print "$paddedStart\n";
	#print "$paddedEnd\n";
	#print "$readName\n\n";
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextRD {
	my (
		$self,
		$readName,						# Read name (uaccno number)
		$numberOfPaddedBases, 			# Number of padded bases
		$numberOfWholeReadInfoItems,	# Number of whole read info items
		$numberOfReadTags,				# Number of read tags
		$paddedRead						# Read string including padding.
		) = @_;
	
	
	if ($numberOfPaddedBases != length($paddedRead)) {
		$self->throw(
			"Length of padded read does not equal " .
			"expected number of padded bases."
			);
		}
	
	# Replace * with default GAP character.
	$paddedRead =~ s/\*/$GAP/g;
	
#	print "$readName\n";
	
	my $read = $self->{_currentContig}->getReadCollection->get($readName);
	$read->setNumberOfPaddedBases($numberOfPaddedBases);
	$read->setNumberOfWholeReadInfoItems($numberOfWholeReadInfoItems);
	$read->setNumberOfReadTags($numberOfReadTags);
	$read->setPaddedRead($paddedRead);	
	
	# Store for next QA
	$self->{_currentRead} = $read;
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextQA {
	my (
		$self,
		$qualClippingStart,		# qual clipping start
		$qualClippingEnd,		# qual clipping end
		$alignClippingStart,	# align clipping start
		$alignClippingEnd		# align clipping end
		) = @_;
	
	
	my $read = $self->{_currentRead};
	
	$read->setQualClippingStart($qualClippingStart); 	
	$read->setQualClippingEnd($qualClippingEnd); 			
	$read->setAlignClippingStart($alignClippingStart);
	$read->setAlignClippingEnd($alignClippingEnd); 	
	
	# Just in case - will force error if used again before next RD.
	$self->{_currentRead} = undef;

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextDS {
	my (
		$self,
		$chromatFileName,	# name of chromat file
		$phdFileName,		# name of phd file
		$dateAndTime, 		# date/time of the phd file
		$trim				# TRIM ???
		) = @_;
	
	#print "$chromatFileName\n";
	#print "$phdFileName\n";
	#print "$dateAndTime\n";
	#print "$trim\n\n";
	
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _endOfFile {
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getContigCollection {
	return shift->{_contigCollection};
	} #ÊEnd of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

