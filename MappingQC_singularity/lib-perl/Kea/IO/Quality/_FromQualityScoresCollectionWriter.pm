#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 11/03/2009 15:40:23
#    Copyright (C) 2009, University of Liverpool.
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
package Kea::IO::Quality::_fromQualityScoresCollectionWriter;
use Kea::Object;
use Kea::IO::IWriter;
our @ISA = qw(Kea::Object);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	my $qualityScoresCollection =
		Kea::Object->check(shift, "Kea::Quality::QualityScoresCollection");
	
	my $self = {
		_qualityScoresCollection => $qualityScoresCollection
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
	my $qualityScoresCollection = $self->{_qualityScoresCollection};
	
	
	for (my $i = 0; $i < $qualityScoresCollection->getSize; $i++) {
		my $qualityScores = $qualityScoresCollection->get($i);
		
		print $FILEHANDLE ">" . $qualityScores->getId . "\n";	
		
		my @array = $qualityScores->getScoresAsArray;
		
	
		my $n = 60;
		
		while (@array) {
			my @buffer = splice(@array, 0, $n);
			print $FILEHANDLE "@buffer\n";
			}
		
		
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

