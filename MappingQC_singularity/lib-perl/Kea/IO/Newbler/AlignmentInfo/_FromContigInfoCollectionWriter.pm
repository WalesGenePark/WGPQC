#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 07/05/2008 15:37:19
#    Copyright (C) 2008, University of Liverpool.
#    Author: Kevin Ashelford.
#
#    Contact details:
#    Email:   k.ashelford@liv.ac.uk
#    Address: School of Biological Sciences, University of Liverpool, 
#             Biosciences Building, Crown Street, Liverpool, UK. L69 7ZB
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
package Kea::IO::Newbler::AlignmentInfo::_FromContigInfoCollectionWriter;
use Kea::Object;
use Kea::IO::IWriter;
our @ISA = qw(Kea::Object Kea::IO::IWriter);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::Number;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	my $contigInfoCollection =
		Kea::Object->check(
			shift,
			"Kea::Assembly::Newbler::AlignmentInfo::ContigInfoCollection"
			);
	
	my $self = {
		_contigInfoCollection => $contigInfoCollection
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

sub write {

	my $self 					= shift;
	my $FILEHANDLE 				= $self->check(shift);
	my $contigInfoCollection 	= $self->{_contigInfoCollection};
	
	print $FILEHANDLE
		"Position	Consensus	Quality Score	Depth	Signal	StdDeviation\n"
		or
		$self->throw("Could not print to outfile.");
	
	for (my $i = 0; $i < $contigInfoCollection->getSize; $i++) {
		my $contigInfo = $contigInfoCollection->get($i);
		
		my $id 		= $contigInfo->getId;
		my $number 	= $contigInfo->getNumber;
		
		print $FILEHANDLE ">$id \t$number\n" or
			$self->throw("Could not print to outfile.");
		
		my $bases 				= $contigInfo->getBases;
		my $qualityScores 		= $contigInfo->getQualityScores;
		my $depths 				= $contigInfo->getDepths;
		my $signals				= $contigInfo->getSignals;
		my $standardDeviations	= $contigInfo->getStandardDeviations;
		
		for (my $i = 0; $i < @$bases; $i++) {
			# 1       C       64      16      2.93    0.85
			printf $FILEHANDLE (
				"%d\t%s\t%d\t%d\t%s\t%s\n",
				
				$i+1,
				$bases->[$i],
				$qualityScores->[$i],
				$depths->[$i],
				Kea::Number->roundup($signals->[$i], 2),
				Kea::Number->roundup($standardDeviations->[$i], 2)
				
				) or $self->throw("Could not print to outfile.");
			}
		
		}
	
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

