#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 07/03/2008 12:22:51 
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
package Kea::IO::Mummer::ShowAligns::_FromMummerAlignmentCollectionWriter;
use Kea::Object;
use Kea::IO::IWriter;
our @ISA = qw(Kea::Object Kea::IO::IWriter);

## Purpose		: 

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $mummerAlignmentCollection =
		Kea::Object->check(
			shift,
			"Kea::Alignment::Mummer::MummerAlignmentCollection"
			);
	
	my $self = {
		_mummerAlignmentCollection => $mummerAlignmentCollection
		};
	
	bless(
		$self,
		$className
		);
	
	return $self;
	
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $convertToBlocks = sub {
	
	my $self 		= shift;
	my $string 	= $self->check(shift);
	my $size		= $self->checkIsInt(shift);
	
	my @blocks;
	for (my $i = 0; $i < length($string); $i = $i+$size) {
		push(
			@blocks, substr($string, $i, $size)
			);
		}
	
	return @blocks;
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $formatAlignment= sub {
	
	my $self 		= shift;
	my $mummerAlignment =
		$self->check(shift, "Kea::Alignment::Mummer::IMummerAlignment");

	my $referenceLocation 	= $mummerAlignment->getReferenceLocation;
	my $queryLocation 		= $mummerAlignment->getQueryLocation;
	
	my $referenceSequence 	= lc($mummerAlignment->getReferenceSequence("."));
	my $querySequence 		= lc($mummerAlignment->getQuerySequence("."));
	my $differenceString	= $mummerAlignment->getDifferenceString("^");
	
	my @refBlocks 			= $self->$convertToBlocks($referenceSequence, 49);
	my @queryBlocks 		= $self->$convertToBlocks($querySequence, 49);
	my @diffStringBlocks 	= $self->$convertToBlocks($differenceString, 49);
		
	my $text = "";
	my $refStart = $referenceLocation->getStart;
	my $queryStart = $queryLocation->getStart;
	
	if ($mummerAlignment->getReferenceOrientation =~ /^-/) {
		$refStart = $referenceLocation->getEnd;
		}
	if ($mummerAlignment->getQueryOrientation =~ /^-/) {
		$queryStart = $queryLocation->getEnd;
		}
	
	for (my $i = 0; $i < @refBlocks; $i++) {
		
		$text .=
			sprintf(
				"%-11d%s\n%-11d%s\n%11s%s\n\n",
				$refStart,
				$refBlocks[$i],
				$queryStart,
				$queryBlocks[$i],
				" ",
				$diffStringBlocks[$i]
				);
		
		
		if ($mummerAlignment->getReferenceOrientation =~ /^-/) {
			$refStart -= length($refBlocks[$i]) - ($refBlocks[$i] =~ s/\.//g);
			}
		else {
			$refStart += length($refBlocks[$i]) - ($refBlocks[$i] =~ s/\.//g);
			}
		
		if ($mummerAlignment->getQueryOrientation =~ /^-/) {
			$queryStart -= length($queryBlocks[$i]) - ($queryBlocks[$i] =~ s/\.//g);
			}
		else {
			$queryStart += length($queryBlocks[$i]) - ($queryBlocks[$i] =~ s/\.//g);
			}
		
		
		
		
		}
		
	return $text;	
		
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub write {
	
	my $self 		= shift;
	my $FILEHANDLE 	= $self->check(shift);
	
	my $mummerAlignmentCollection = $self->{_mummerAlignmentCollection};
	
	printf $FILEHANDLE (
		"%s %s\n", 
		$mummerAlignmentCollection->getReferenceFilePath, 
		$mummerAlignmentCollection->getQueryFilePath
		) or $self->throw("Could not print to file.");
	
	print $FILEHANDLE "\n============================================================\n" or
		$self->throw("Could not print to file.");
	
	printf $FILEHANDLE (
		"-- Alignments between %s and %s\n\n",
		$mummerAlignmentCollection->getReferenceId,
		$mummerAlignmentCollection->getQueryId
		) or
		$self->throw("Could not print to file.");
	
	for (my $i = 0; $i < $mummerAlignmentCollection->getSize; $i++) {
		my $mummerAlignment = $mummerAlignmentCollection->get($i);
		
		# Accommodate orientation
		my $refOrientation = $mummerAlignment->getReferenceOrientation;
		my $refStart = $mummerAlignment->getReferenceLocation->getStart;
		my $refEnd = $mummerAlignment->getReferenceLocation->getEnd;
		if ($refOrientation =~ /^-/) {
			$refStart = $mummerAlignment->getReferenceLocation->getEnd;
			$refEnd = $mummerAlignment->getReferenceLocation->getStart;
			}
		
		my $queryOrientation = $mummerAlignment->getQueryOrientation;
		my $queryStart = $mummerAlignment->getQueryLocation->getStart;
		my $queryEnd = $mummerAlignment->getQueryLocation->getEnd;
		if ($queryOrientation =~ /^-/) {
			$queryStart = $mummerAlignment->getQueryLocation->getEnd;
			$queryEnd = $mummerAlignment->getQueryLocation->getStart;
			}
		
		my $refFrame = $mummerAlignment->getReferenceFrame;
		my $queryFrame = $mummerAlignment->getQueryFrame;
		
		printf $FILEHANDLE (
		
			"-- BEGIN alignment [ %s%d %d - %d | %s%d %d - %d ]\n\n\n",
			
			$refOrientation,
			$refFrame,
			$refStart,
			$refEnd,
			
			$queryOrientation,
			$queryFrame,
			$queryStart,
			$queryEnd
			
			) or $self->throw("Could not print to file.");
		
		
		print $FILEHANDLE(
			$self->$formatAlignment($mummerAlignment)
			) or $self->throw("Could not print to file.");
		
		printf $FILEHANDLE (
		
			"\n--   END alignment [ %s%d %d - %d | %s%d %d - %d ]\n",
			
			$refOrientation,
			$refFrame,
			$refStart,
			$refEnd,
			
			$queryOrientation,
			$queryFrame,
			$queryStart,
			$queryEnd
			
			) or $self->throw("Could not print to file.");
		}
	
	print $FILEHANDLE (
		"\n============================================================\n"
		);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


=pod

============================================================
-- Alignments between Ia and Contig107

-- BEGIN alignment [ +1 1895349 - 1895761 | +1 3224 - 3635 ]


1895349    tttagggtttagtgggtttagggtt....gtttagggtt....gtttag
3224       tttagggttta..gggtttagggtttagggtttagggtttagggtttag
                      ^^            ^^^^          ^^^^      

1895390    ggtggtgtagggtttagggtttagggtttagggtttagggtttagggtt
3271       ggt..t.tagggtttagggtttagggtttagggtttagggtttagggtt
              ^^ ^                                          

1895439    tagggtttagggtttagggtttagggtttagggtttagggtttagggtt
3317       tagggtttagggtttagggtttagggtttagggtttagggtttagggtt
                                                            

=cut
