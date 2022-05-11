#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 05/03/2008 11:18:35 
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
package Kea::IO::Newbler::AllDiffs::_ToHandlerReader;
use Kea::Object;
use Kea::IO::IReader;
our @ISA = qw(Kea::Object Kea::IO::IReader);

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
	my $self = {};
	bless(
		$self,
		$className
		);
	return $self;
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $processReadsWithDifference = sub {

	my $self 		= shift;
	my $FILEHANDLE 	= $self->check(shift);
	my $handler 	= $self->check(shift, "Kea::IO::Newbler::AllDiffs::IReaderHandler");
	
	#Ia                           1+ GTAGT-AGCA-CTGTATTGA-GTACGAGTG-AATCTT-GCA-TGT-GCGTG 44
	#												  ***
	#E5G1LZ401BIFWI             154- GTAGT-AGCA-CTGTATT-AAGTACGAGTG-AATCTTA-CAC-GTA-CGTG 111
	#E5G1LZ402GWVA3               1+   AGT-AGCA-CTGTATT-AAGTACGAGTG-AATCTTA-CAC-GTA-CGTG 42
	#												  ***
	#
	
	# First line will be reference sequence.
	
	<$FILEHANDLE> =~ /^([\w\-]+)\s+\(*(\d+)*\)*\s+(\d+)([-+])\s([\s\w-]+)\s(\d+)$/ or
		$self->throw("Failed to match reference alignment line.");
	
	$handler->_nextRefAlignmentLine(
		$1, # Id of read (or reference sequence).
		$2,	# Number in parenthesis ???
		$3, # Start position within read.
		$4,	# Orientation (+/-).
		$5, # Sequence with alignment gaps.
		$6	# End position within read.
		);
	
	<$FILEHANDLE> =~ /^                                (\s*([\*]+))$/ or
		$self->throw("Failed to match difference string.");
	
	$handler->_nextDifferenceLine(
		$1 # Simple string showing location of difference with *.
		);
	
	
	while (<$FILEHANDLE>) {
		
		# Empty line signifies end of 'reads with difference'.		
		if (/^\s*$/) {return}
		
		if (/^([\w\-]+)\s+\(*(\d+)*\)*\s+(\d+)([-+])\s([\s\w-]+)\s(\d+)$/) {
			$handler->_nextReadWithDifferenceAlignmentLine(
				$1, # Id of read (or reference sequence).
				$2,	# Number in parenthesis ???
				$3, # Start position within read.
				$4,	# Orientation (+/-).
				$5, # Sequence with alignment gaps.
				$6	# End position within read.
				);
			}
		
		}
	
	
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $processOtherReads = sub {
	
	my $self 		= shift;
	my $FILEHANDLE 	= $self->check(shift);
	my $handler 	= $self->check(shift, "Kea::IO::Newbler::AllDiffs::IReaderHandler");
	
	while (<$FILEHANDLE>) {
		
		# Empty line signifies end of 'other reads'.		
		if (/^\s*$/) {return}
		
		if (/^([\w\-]+)\s+\(*(\d+)*\)*\s+(\d+)([-+])\s([\s\w-]+)\s(\d+)$/) {
			$handler->_nextOtherReadAlignmentLine(
				$1, # Id of read (or reference sequence).
				$2,	# Number in parenthesis ???
				$3, # Start position within read.
				$4,	# Orientation (+/-).
				$5, # Sequence with alignment gaps.
				$6	# End position within read.
				);
			}
		
		}

	}; # End of method.

################################################################################

# PUBLIC METHODS

sub read {

	my $self 		= shift;
	my $FILEHANDLE 	= $self->check(shift);
	my $handler 	= $self->check(shift, "Kea::IO::Newbler::AllDiffs::IReaderHandler");
	
	while (<$FILEHANDLE>) {
		
		# Just in case...
		s/\r//;
		
		#>contig00001    104     104     -       [A, AA] 2       0       2       3       67
		if (/>(.+)\t(\d+)\t(\d+)\t(\S+)\t\[(.+)\]\t(\d+)\t(\d+)\t(\d+)\t(\d+)\t(\d+)$/) {
		
			my @array = split(", ", $5);
		
			$handler->_nextSummaryLine(
			
				$1, # (Accno) 		Accession number of the reference sequence in which the difference was detected.
				$2, # (Start Pos)	Start position within the reference sequence.
				$3, # (End pos) 	Stop position within the reference sequence.
				
				# Variation.
				$4, 		# (Seq) 		The reference sequence at the difference location.
				\@array, 	# (Seq) 		The differing sequence at the difference location.
				
				# Frequency.
				$6, # (#fwd)		The number of forward reads that include the difference.
				$7, # (#rev)		The number of reverse reads that include the difference.
				$8,	# (#Var)		The total number of reads that include the difference.
				$9, # (#Tot)		The total number of reads that fully span the difference location.
				$10	# (%) 			The percentage of different reads versus total reads that fully span the difference location.
				);
			
			}
		
		
		
		
		#  $1	$2		$3		$4		$5 		$6		$7		$8		$9		$10
		# >Ia	17		17		G		A       1       1       2       12      17
		if (/>(.+)\t(\d+)\t(\d+)\t([\w-]+)\t([\w-]+)\t(\d+)\t(\d+)\t(\d+)\t(\d+)\t(\d+)$/) {
		
		
			$handler->_nextSummaryLine(
			
				$1, # (Accno) 		Accession number of the reference sequence in which the difference was detected.
				$2, # (Start Pos)	Start position within the reference sequence.
				$3, # (End pos) 	Stop position within the reference sequence.
				
				# Variation.
				$4, # (Seq) 		The reference sequence at the difference location.
				[$5], # (Seq) 		The differing sequence at the difference location.
				
				# Frequency.
				$6, # (#fwd)		The number of forward reads that include the difference.
				$7, # (#rev)		The number of reverse reads that include the difference.
				$8,	# (#Var)		The total number of reads that include the difference.
				$9, # (#Tot)		The total number of reads that fully span the difference location.
				$10	# (%) 			The percentage of different reads versus total reads that fully span the difference location.
				);
			}
		
		
		if (/^Reads with Difference:$/) {
			$self->$processReadsWithDifference($FILEHANDLE, $handler);
			}
		

		if (/^Other Reads:$/) {
			$self->$processOtherReads($FILEHANDLE, $handler);
			}
		
		
		
		# -----------------------------
		if (/^-----------------------------$/) {
			$handler->_nextAlignmentEnd;
			}
		
		} # End of while - end of filestream reached.
	
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

