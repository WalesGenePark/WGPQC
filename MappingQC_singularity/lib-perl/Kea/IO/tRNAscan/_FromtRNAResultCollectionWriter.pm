#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 15/05/2008 15:58:06
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
package Kea::IO::tRNAscan::_FromtRNAResultCollectionWriter;
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

our $_header;

use Kea::Number;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	
	my $className = shift;
	
	my $tRNAResultCollection =
		Kea::Object->check(shift, "Kea::IO::tRNAscan::tRNAResultCollection");
	
	my $self = {
		_tRNAResultCollection => $tRNAResultCollection
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
	my $FILEHANDLE				= $self->check(shift);
	my $tRNAResultCollection 	= $self->{_tRNAResultCollection};
	
	print $FILEHANDLE $_header 
		or $self->throw("Could not print to outfile: $!");
	
	for (my $i = 0; $i < $tRNAResultCollection->getSize; $i++) {
		my $tRNAResult = $tRNAResultCollection->get($i);
		
		my $start = $tRNAResult->getLocation->getStart;
		my $end = $tRNAResult->getLocation->getEnd;
		if ($start > $end) {
			$end = $tRNAResult->getLocation->getStart;
			$start = $tRNAResult->getLocation->getEnd;
			}
		
		my $intronStart = $tRNAResult->getIntronLocation->getStart;
		my $intronEnd = $tRNAResult->getIntronLocation->getEnd;
		if ($intronStart > $intronEnd) {
			$intronEnd = $tRNAResult->getIntronLocation->getStart;
			$intronStart = $tRNAResult->getIntronLocation->getEnd;
			}
		
		my $text = sprintf(
			"%-13s\t%d\t%d\t%d\t%s\t%s\t%d\t%d\t%s\n",
			$tRNAResult->getId,
			$tRNAResult->getNumber,
			$start,
			$end,
			$tRNAResult->getType,
			$tRNAResult->getAnticodon,
			$intronStart,
			$intronEnd,
			Kea::Number->roundup($tRNAResult->getCoveScore, 2)
			);
		
		print $FILEHANDLE $text 
			or $self->throw("Could not print to outfile: $!");
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////

$_header = <<HEADER;
Sequence     		tRNA   	Bounds 	tRNA	Anti	Intron Bounds	Cove
Name         	tRNA #	Begin  	End    	Type	Codon	Begin	End	Score
--------     	------	----   	------ 	----	-----	-----	----	------
HEADER
1;

