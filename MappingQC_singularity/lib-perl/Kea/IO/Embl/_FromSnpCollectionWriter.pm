#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 25/03/2009 15:49:14
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
package Kea::IO::Embl::_FromSnpCollectionWriter;
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

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $snpCollection =
		Kea::Object->check(
			shift,
			"Kea::IO::SOLiD::Snps::SnpCollection"
			);
	
	my $self = {
		_snpCollection => $snpCollection
		};
	
	bless(
		$self,
		$className
		);
	
	return $self;
	
	} # End of constructor.

################################################################################

#?PRIVATE METHODS

my $privateMethod = sub {
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub write {

	my $self 			= shift;
	my $FILEHANDLE 		= $self->check(shift);
	my $colour			= $self->check(shift, "Kea::Graphics::IColour");
	my $snpCollection 	= $self->{_snpCollection};
	
	
	# Sort snp collection - needs to be ordered by position for features file
	my @snps = $snpCollection->getAll;
	
	foreach my $snp (sort {$a->getCoordinate <=> $b->getCoordinate} @snps) {
		
		my $coordinate		= $snp->getCoordinate;
		my $refAllele		= $snp->getReferenceAllele;
		my $consensusAllele	= $snp->getConsensusAllele;
		
		my $note = "$refAllele -> $consensusAllele";
		
		my $colourString = join(" ", @{$colour->getRgb});
		
		my $text = "";
		$text .= "FT   snp             $coordinate..$coordinate\n";
		$text .= "FT                   /note=\"$note\"\n";
		$text .= "FT                   /colour=\"" . $colourString . "\"\n";

		print $FILEHANDLE $text;
		
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

