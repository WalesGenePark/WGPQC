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
package Kea::IO::Newbler::Ace::_ToHandlerReader;
use Kea::Object;
use Kea::IO::IReader;
our @ISA = qw(Kea::Object Kea::IO::IReader);

## Purpose		: 

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
	my $self = {};
	bless(
		$self,
		$className
		);
	return $self;
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $nextBlock = sub {
	my $FILEHANDLE = shift;
	
	my @buffer;
	while ((my $line = <$FILEHANDLE>) !~ /^\s*$/) {
		push(@buffer, $line);
		}
	
	return join(" ", @buffer);
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub read {

	my $self 		= shift;
	my $FILEHANDLE 	= $self->check(shift);
	my $handler 	= $self->check(shift, "Kea::IO::Newbler::Ace::IReaderHandler");
	
	while (<$FILEHANDLE>) {
	
		#AS   19641 270609
		if (/^AS\s+(\d+)\s+(\d+)\s*$/) {
			$handler->_nextAS(
				$1,	# Number of contigs.
				$2	# Total number of reads in ace file.
				);
			}
		
		#CO E7FAW9K04_c1 6637 1824 4812 U
		
		#CO contig00001 691 26 49 U
		#ATGAGTAAATGTGTTCTGCGTATGAaa*CAaCGGCcATCGCCGATATATA
		#ATAATATAATTCTAGGAACGCCA*TAAA*TTAA*GAA*CTAAA*CTGATA
		#A*cAATAAAa*AGCATTCAAATATCGTAATGTATTAAAATATAAACTAAG
		#TATAATAATTCTGAAGTTACTTCCAAT*AaTA*TTTtA*TtCGAAAAATC
		#ATGCGTAGT*CGT*AGCAATaGTCCAAGTTACTCTTtAGTAtCGGAaTCT
		#CTTGTTAaTATAAATTCCACATTTCGTATTAG*tGTTTCTCTGCAGCGAT
		#ATTTTAAAGATGTTCGTAGCCGATGTTACATATTAGTTAATCGCAATCGT
		#CC*TGTTCGTTGGTTGGAGAAAaGAATACAAAATATTTTtAC*A*CTT*C
		#CT*GGAAAaTTTt*GCCTCACTACAAa*tGGCCACATGCTACCATCGTGT
		#GAaGCTTTAGCACTTTtAAATTCTG*ATGA*TACTATTGAGGTTGTACCT
		#TTTTTGACTGATTtGAGt*aCTGA*TGTC*ATAA*TCAATGGGAACTCTA
		#CTGACCATGATATGTA*CAGATGTAATGAT*GCAACAGGTAg*cTCTAaT
		#GTGGACTC*AATCAGT*AaGCGATGCAAAAGAAAGGA**TGTGTTTGAGA
		#AATTTAAAAATAAATCTGCAGTTGTAGAGAAT*GCAACATC
		elsif (/^CO (\S+) (\d+) (\d+) (\d+) (U|C)$/) {
			
			my $contigName = 			$1;	# Contig name
			my $numberOfBases = 		$2; # Number of bases
			my $numberOfReads = 		$3; # Number of reads in contig
			my $numberOfBaseSegments = 	$4; # Number of base segments in contig
			my $UorC = 					$5; # U (uncomplemented) or C (complemented).
			
			my $paddedConsensus = $nextBlock->($FILEHANDLE);
			$paddedConsensus =~ s/\s//g;
			$handler->_nextCO(
				$contigName,	
				$numberOfBases, 
				$numberOfReads, 
				$numberOfBaseSegments,	
				$UorC,	
				$paddedConsensus
				);
			}
		
		#BQ
		#64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 46 21 7 59 64 15 64 64 64 64 13 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 
		elsif (/^BQ\s*$/) {
			my $qualityScores = $nextBlock->($FILEHANDLE);
			my @buffer = split(/\s+/, $qualityScores);
			$handler->_nextBQ(
				\@buffer # Array of quality scores.
				);
			}
		
		
		
		
		#AF <read name> <C or U> <padded start consensus position>
		#=======================================================================
		
		elsif (/^AF\s+(\S+)\s+(U|C)\s+(-*\d+)$/) {
        
			$handler->_nextAF(
				$1,	# Read name (uaccno number and location info).
				$2,	# C or U.
				$3	# Padded start consensus position
				);
			}
		
		#=======================================================================
		
		
		
		
		#BS 1 101 EYOMRYE01DCDBO.10-278
		#BS 102 102 EYOMRYE01CIFZU.204-1
		#BS 103 177 EYOMRYE02F01VV
		#BS 178 178 EYOMRYE01DCDBO.10-278
		#BS 179 179 EYOMRYE02F01VV
		#BS 180 180 EYOMRYE01DCDBO.10-278
		#BS 181 182 EYOMRYE02F01VV
		#BS 183 183 EYOMRYE01DCDBO.10-278
		#BS 184 186 EYOMRYE02F01VV
		#BS 187 187 EYOMRYE01DCDBO.10-278
		#BS 188 188 EYOMRYE02F01VV
		#BS 189 189 EYOMRYE01DCDBO.10-278
		#BS 190 190 EYOMRYE02F01VV
		#BS 191 191 EYOMRYE01DCDBO.10-278
		#BS 192 202 EYOMRYE02F01VV
		#BS 203 209 EYOMRYE02HQ9MQ.9-249
		#BS 210 210 EYOMRYE02F01VV
		#BS 211 213 EYOMRYE02HQ9MQ.9-249
		#BS 214 214 EYOMRYE02F01VV
		elsif (/^BS\s+(\d+)\s+(\d+)\s+(\S+)$/) { 
			$handler->_nextBS(
				$1, 	# padded start consensus position
				$2, 	# padded end consensus position
				$3		# read name (uaccno number plus location info)
				);
			}

		
		
		
		
		
		#=======================================================================
		
		
		#RD EYOMRYE01CPEFS.30-278 286 0 0
		#CGGCCGGGGAGTGTCAAGTGTTTACTGACATGAGTAAATGTGTTCTGCGT
		#ATGAAA*CAACGGCCATCGCCGATATATAATAATATAATTCTAGGAACGC
		#CAATAAAATTAAAGAAACTAAAACTGATAAT*AATAAA*TAGCATTCAAA
		#TATCGTAATGTATTAAAATATAAACTAAGTATAATAATTCTGAAGTTACT
		#TCCAAT*AATA*TTTTA*TTCGAAAAATCATGCGTAGT*CGT*AGCAATA
		#GTCCAAGTTACTCTTTAGTATCGGAATCTCTTGTTA
		
		
		
		
		elsif (/^RD\s+(\S+)\s+(\d+)\s+(\d+)\s+(\d+)$/) {
		
			my $readName = $1;						# Read name (uaccno number)
			my $numberOfPaddedBases = $2; 			# Number of padded bases (i.e., number of bases inc. padding)
			my $numberOfWholeReadInfoItems = $3;	# Number of whole read info items
			my $numberOfReadTags = $4;				# Number of read tags
				
			my $paddedRead = $nextBlock->($FILEHANDLE);
			$paddedRead =~ s/\s//g;
			
			
			$handler->_nextRD(
				$readName,						# Read name (uaccno number)
				$numberOfPaddedBases, 			# Number of padded bases
				$numberOfWholeReadInfoItems,	# Number of whole read info items
				$numberOfReadTags,				# Number of read tags
				$paddedRead						# Padded read
				);
			}

		
		#=======================================================================
		
		
		
		
		
		#QA 30 286 30 286
		elsif (/^QA\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)$/) {
			$handler->_nextQA(
				$1,	# qual clipping start
				$2,	# qual clipping end
				$3, # align clipping start
				$4	# align clipping end
				);
			}
		

		#=======================================================================
		
		
				
		# DS CHROMAT_FILE: EYOMRYE01CPEFS.30-278 PHD_FILE: EYOMRYE01CPEFS.30-278.phd.1 TIME: Thu Jul 27 12:33:48 2000 TRIM: 5-282
		# DS CHROMAT_FILE: <name of chromat file> PHD_FILE: <name of phd file> TIME: <date/time of the phd file>
		elsif (/^DS\s+CHROMAT_FILE:\s+(\S+)\s+PHD_FILE:\s+(\S+)\s+TIME:\s+(.+)\s+TRIM:\s+(\S+)$/) {
			$handler->_nextDS(
				$1,	# name of chromat file
				$2,	# name of phd file
				$3, # date/time of the phd file
				$4	# TRIM ???
				);
			}
		
		# DS CHROMAT_FILE: contig00001 PHD_FILE: contig00001.phd.1 TIME: Thu Jul 27 12:33:48 2000
		elsif (/^DS\s+CHROMAT_FILE:\s+(\S+)\s+PHD_FILE:\s+(\S+)\s+TIME:\s+(.+)$/) {
			$handler->_nextDS(
				$1,	# name of chromat file
				$2,	# name of phd file
				$3, # date/time of the phd file
				undef
				);
			}
		
		elsif (/^\s*$/) {}
		
		else {
			#$self->warn("line not accounted for: $_");
			}
	
		} # End of while - no more lines in file.
	
	$handler->_endOfFile;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

