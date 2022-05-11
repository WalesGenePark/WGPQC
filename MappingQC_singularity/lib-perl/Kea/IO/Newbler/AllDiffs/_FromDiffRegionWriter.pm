#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 17/04/2008 16:46:30
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
package Kea::IO::Newbler::AllDiffs::_FromDiffRegionWriter;
use Kea::Object;
use Kea::IO::IWriter;
our @ISA = qw(Kea::Object Kea::IO::IWriter);

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

my $_header;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	
	my $className = shift;
	
	my $diffRegion =
		Kea::Object->check(
			shift,
			"Kea::Assembly::Newbler::AllDiffs::IDiffRegion"
			);
	
	my $self = {
		_diffRegion => $diffRegion
		};
	
	bless(
		$self,
		$className
		);
	
	return $self;
	
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $format = sub {
	
	my $self = shift;
	
	my $diffRegion =
		$self->check(shift, "Kea::Assembly::Newbler::AllDiffs::IDiffRegion");

	my $text = ">" . $diffRegion->getSummaryLine->toString . "\n";
	
	$text .= "\nReads with Difference:\n"; 
	$text .= $diffRegion->getRefAlignmentLine->toString . "\n";
	$text .= "                                " . $diffRegion->getDifferenceString . "\n";
	$text .= $diffRegion->getReadsWithDifferenceAlignmentLineCollection->toString;
	$text .= "                                " . $diffRegion->getDifferenceString . "\n";
	
	$text .= "\nOther Reads:\n";
	
	if ($diffRegion->hasOtherReads) {
		$text .= "                                " . $diffRegion->getDifferenceString . "\n";
		$text .= $diffRegion->getOtherReadsAlignmentLineCollection->toString;
		$text .= "                                " . $diffRegion->getDifferenceString . "\n";
		}
	
	$text .= "\n\n-----------------------------\n\n";
	
	return $text;
	
		
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub write {

	my $self 		= shift;
	my $FILEHANDLE	= $self->check(shift);
	my $diffRegion 	= $self->{_diffRegion};
	
	print $FILEHANDLE $self->$format($diffRegion);
		
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub writeHeader {
	
	my $self = shift;
	my $FILEHANDLE = $self->check(shift);
	
	print $FILEHANDLE $_header;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
$_header = <<HEADER;
Reference      	     	   	   	Variation		Frequency
Accno          			Start	End	Seq	Seq    	#fwd	#rev	#Var	#Tot	(%)
               			 Pos 	Pos	   	   	    	    	
___________________________________	_______________________	____________________
HEADER
1;

