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
package Kea::IO::Paml::CodemlResult::_ToHandlerReader;
use Kea::Object;
use Kea::IO::IReader;
our @ISA = qw(Kea::Object Kea::IO::IReader); 

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use Kea::Phylogeny::Paml::_BranchResult;
use Kea::Phylogeny::TreeFactory;

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

my $readTable = sub {
	
	my $self 		= shift;
	my $FILEHANDLE 	= $self->check(shift);
	my $handler 	= $self->check(shift,"Kea::IO::Paml::CodemlResult::IReaderHandler");
	
	# Read and ignore first blank line.
	my $line = <$FILEHANDLE>;
	
	while (($line = <$FILEHANDLE>) !~ /^\s*$/) {
	
		#branch           t        N        S    dN/dS       dN       dS   N*dN   S*dS
		#
		# 11..2       0.046    492.0    102.0   0.0823   0.0052   0.0634    2.6    6.5
		# 11..12      0.005    492.0    102.0   0.0823   0.0005   0.0065    0.3    0.7
		# 12..6       0.000    492.0    102.0   0.0823   0.0000   0.0000    0.0    0.0
		# 12..13      0.000    492.0    102.0   0.0823   0.0000   0.0000    0.0    0.0
		# 13..7       0.005    492.0    102.0   0.0823   0.0006   0.0076    0.3    0.8
		# 13..14      0.000    492.0    102.0   0.0823   0.0000   0.0000    0.0    0.0
		# 14..8       0.000    492.0    102.0   0.0823   0.0000   0.0000    0.0    0.0
		# 14..15      0.000    492.0    102.0   0.0823   0.0000   0.0000    0.0    0.0
		# 15..16      0.000    492.0    102.0   0.0823   0.0000   0.0000    0.0    0.0
		# 16..17      0.000    492.0    102.0   0.0823   0.0000   0.0000    0.0    0.0
		# 17..18      0.034    492.0    102.0   0.0823   0.0038   0.0467    1.9    4.8
		# 18..3       0.000    492.0    102.0   0.0823   0.0000   0.0000    0.0    0.0
		# 18..10      0.005    492.0    102.0   0.0823   0.0006   0.0076    0.3    0.8
		# 17..4       0.000    492.0    102.0   0.0823   0.0000   0.0000    0.0    0.0
		# 16..5       0.000    492.0    102.0   0.0823   0.0000   0.0000    0.0    0.0
		# 15..9       0.034    492.0    102.0   0.0823   0.0038   0.0467    1.9    4.8
		# 11..1       0.142    492.0    102.0   0.0823   0.0162   0.1970    8.0   20.1

	
	
		# NOTE VERSION 3.14 OUTPUT - SEE BELOW FOR DIFFERENCE WITH VERSION 4.
		# branch           t        S        N    dN/dS       dN       dS   S*dS   N*dN
		#
		#	8..9       0.071    107.9    282.1 999.0000   0.0329   0.0000    0.0    9.3
		#	9..1       0.024    107.9    282.1   0.7183   0.0073   0.0101    1.1    2.1
		#	9..2       0.041    107.9    282.1   0.2519   0.0074   0.0294    3.2    2.1
		#	8..10      0.042    107.9    282.1   1.5041   0.0153   0.0101    1.1    4.3
		#   10..11      0.079    107.9    282.1   3.5119   0.0329   0.0094    1.0    9.3
		#   11..3       0.044    107.9    282.1   0.6511   0.0128   0.0197    2.1    3.6
		#   11..4       0.052    107.9    282.1   0.8725   0.0166   0.0191    2.1    4.7
		#   10..5       0.019    107.9    282.1 999.0000   0.0087   0.0000    0.0    2.5
		#	8..12      0.122    107.9    282.1   0.4917   0.0316   0.0644    6.9    8.9
		#   12..6       0.040    107.9    282.1   0.5605   0.0110   0.0197    2.1    3.1
		#   12..7       0.026    107.9    282.1   0.0001   0.0000   0.0307    3.3    0.0
		
		
		if ($line =~ /^\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s*$/) {
			
			$handler->nextBranchResult(
				Kea::Phylogeny::Paml::_BranchResult->new(
					-branch 	=> $1,
					-t 			=> $2,
					-N 			=> $3,	# NOTE: THESE TWO PARAMETERS SWAPPED ROUND 
					-S 			=> $4,	#     : IN VERSION 4!!! 
					-omega 		=> $5,
					-dN 		=> $6,
					-dS 		=> $7,
					-NxdN 		=> $8,	# NOTE: THESE TWO PARAMETERS SWAPPED ROUND 
					-SxdS		=> $9	#     : IN VERSION 4!!! 
					)
				);
			
			} # end of if block - line processed.
		
		} #ÊEnd of while - no more lines in table.
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $readTrees = sub {
	
	my $self 		= shift;
	my $FILEHANDLE 	= $self->check(shift);
	my $handler 	= $self->check(shift,"Kea::IO::Paml::CodemlResult::IReaderHandler");
	
	# Ugly strategy follows - but hey!
	
	# Discard first blank line.
	my $line = <$FILEHANDLE>;
	
	# Read next line.
	#(8: 0.039045, ((6: 0.197161, 1: 0.903961): 0.000000, (5: 0.343710, ((3: 0.001753, 7: 1.088692): 0.000000, (2: 0.218094, 4: 0.001375): 0.023505): 1.027007): 0.152632): 0.133133, 9: 0.199299);
	$line = <$FILEHANDLE>;
	chomp($line);
	if ($line =~ /^\(.+\);$/) {
		
		my $tree = Kea::Phylogeny::TreeFactory->createTree(
			$line
			);

	#	print $tree->toString . "\n";
				
		$handler->unlabelledTree($tree);
		} else {
		$self->throw("Didn't recognise line as tree data:\n\n\t$line");
		}
	
	# Discard second blank line.
	$line = <$FILEHANDLE>;
	
	# Read next line
	#(Seq1: 0.039045, ((Seq2: 0.197161, Seq6: 0.903961): 0.000000, (Seq4: 0.343710, ((Seq5: 0.001753, Seq3: 1.088692): 0.000000, (Seq7: 0.218094, Seq8: 0.001375): 0.023505): 1.027007): 0.152632): 0.133133, Seq0: 0.199299);
	$line = <$FILEHANDLE>;
	chomp($line);
	if ($line =~ /^\(.+\);$/) {
	
		my $tree = Kea::Phylogeny::TreeFactory->createTree(
			$line
			);
				
		$handler->labelledTree($tree);
	
		} else {
		$self->throw("Didn't recognise line as tree data:\n\n\t$line");
		}
	
	
	
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub read {

	my $self 		= shift;
	my $FILEHANDLE 	= $self->check(shift);
	my $handler 	= $self->check(shift, "Kea::IO::Paml::CodemlResult::IReaderHandler"); 
	
	# Only accept output generated from version 4 of paml (file differences 
	# between versions).
	# Only accept output file generated by version 4 of paml.
		
	#	
	#seed used = 511432689
	#CODONML (in paml version 4, June 2007)    seqfile.phy   Model: One dN/dS 
	my $line0 = <$FILEHANDLE>;	
	my $line1 = <$FILEHANDLE>;	
	my $line3 = <$FILEHANDLE>;
	if ($line3 !~ /^CODONML \(in paml version 4, June 2007\)/) {
		$self->throw( 
			"\nERROR: Wrong version of Paml is being used: $line3\n\n" . 
			"expecting: version 4, June 2007."
			);
		}	
			
	while (<$FILEHANDLE>) {
		
		#tree length =   4.32937
		#
		#(8: 0.039045, ((6: 0.197161, 1: 0.903961): 0.000000, (5: 0.343710, ((3: 0.001753, 7: 1.088692): 0.000000, (2: 0.218094, 4: 0.001375): 0.023505): 1.027007): 0.152632): 0.133133, 9: 0.199299);
		#
		#(Seq1: 0.039045, ((Seq2: 0.197161, Seq6: 0.903961): 0.000000, (Seq4: 0.343710, ((Seq5: 0.001753, Seq3: 1.088692): 0.000000, (Seq7: 0.218094, Seq8: 0.001375): 0.023505): 1.027007): 0.152632): 0.133133, Seq0: 0.199299);
		if (/^tree length =\s+\d+\.\d+\s*$/) {
			$self->$readTrees($FILEHANDLE, $handler);
			}
		
		
		
		#lnL(ntime: 11  np: 13):   -906.017440     +0.000000
		#lnL(ntime: 11  np: 23):   -896.412472     +0.000000
		if (/^lnL\(ntime:.+\):\s+(-*\d+\.\d+)/) {
			$handler->logLikelihood($1);
			}
		
		# kappa (ts/tv) =  4.58785
		elsif (/^kappa \(ts\/tv\) =\s+(\d+\.\d+)\s*$/) {
			$handler->kappa($1);
			}
		
		#Note: Branch length is defined as number of nucleotide substitutions per codon (not per neucleotide site).
		#tree length =   0.14704
		elsif (/^tree length =\s+(\d+\.*\d+)\s*$/) {
			$handler->treeLength($1);
			}
		
		#tree length for dN:      0.02236
		elsif (/^tree length for dN:\s+(\d+\.*\d+)\s*$/) {
			$handler->dNTreeLength($1);
			}
		
		#tree length for dS:      0.18840
		elsif (/^tree length for dS:\s+(\d+\.*\d+)\s*$/) {
			$handler->dSTreeLength($1);
			}
				
		# branch           t        N        S    dN/dS       dN       dS   N*dN   S*dS
		elsif (/\s+branch\s+t\s+N/) {
			$self->$readTable($FILEHANDLE, $handler);
			}

		elsif (//) {}
		
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

