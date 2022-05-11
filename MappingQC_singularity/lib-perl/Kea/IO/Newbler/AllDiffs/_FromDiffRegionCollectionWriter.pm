#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 06/03/2008 09:02:26 
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
package Kea::IO::Newbler::AllDiffs::_FromDiffRegionCollectionWriter;
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
	
	my $diffRegionCollection =
		Kea::Object->check(
			shift,
			"Kea::Assembly::Newbler::AllDiffs::DiffRegionCollection"
			);
	
	my $self = {
		_diffRegionCollection => $diffRegionCollection
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
	
	my $difference =
		$self->check(shift, "Kea::Assembly::Newbler::AllDiffs::IDiffRegion");

	my $text = ">" . $difference->getSummaryLine->toString . "\n";
	
	$text .= "\nReads with Difference:\n"; 
	$text .= $difference->getRefAlignmentLine->toString . "\n";
	$text .= "                                " . $difference->getDifferenceString . "\n";
	$text .= $difference->getReadsWithDifferenceAlignmentLineCollection->toString;
	$text .= "                                " . $difference->getDifferenceString . "\n";
	
	$text .= "\nOther Reads:\n";
	
	if ($difference->hasOtherReads) {
		$text .= "                                " . $difference->getDifferenceString . "\n";
		$text .= $difference->getOtherReadsAlignmentLineCollection->toString;
		$text .= "                                " . $difference->getDifferenceString . "\n";
		}
	
	$text .= "\n\n-----------------------------\n\n";
	
	return $text;
	
		
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub write {

	my $self = shift;
	my $FILEHANDLE = $self->check(shift);
	
	my $diffRegionCollection = $self->{_diffRegionCollection};
	
	print $FILEHANDLE $_header;
	
	for (my $i = 0; $i < $diffRegionCollection->getSize; $i++) {
		my $difference = $diffRegionCollection->get($i);
		print $FILEHANDLE $self->$format($difference);
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub writeWithoutHeader {
	
	my $self = shift;
	my $FILEHANDLE = $self->check(shift);
	
	my $diffRegionCollection = $self->{_diffRegionCollection};
	
	for (my $i = 0; $i < $diffRegionCollection->getSize; $i++) {
		my $difference = $diffRegionCollection->get($i);
		print $FILEHANDLE $self->$format($difference);
		}
	
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

