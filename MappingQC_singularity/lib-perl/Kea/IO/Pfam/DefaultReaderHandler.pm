#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 11/06/2008 12:02:14
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
package Kea::IO::Pfam::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::Pfam::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::Pfam::IReaderHandler);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::IO::Pfam::PfamResultCollection;
use Kea::IO::Pfam::_PfamResult;
use Kea::IO::Location;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	my $pfamResultCollection = Kea::IO::Pfam::PfamResultCollection->new("");
	
	my $self = {
		_pfamResultCollection => $pfamResultCollection
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

sub _nextLine {

	my $self 		= shift;
	my $queryId 	= shift; # seq id
	my $queryStart 	= shift; # seq start
	my $queryEnd 	= shift; # seq end
	my $hmmId		= shift; # hmm acc
	my $hmmStart	= shift; # hmm start
	my $hmmEnd		= shift; # hmm end
	my $bitScore	= shift; # bit score
	my $eValue		= shift; # e value.
	my $hmmName		= shift; # hmm name
	my $isNested	= shift || FALSE;
	
	my $queryLocation = Kea::IO::Location->new($queryStart, $queryEnd);
	my $hmmLocation = Kea::IO::Location->new($hmmStart, $hmmEnd);
	
	$self->{_pfamResultCollection}->add(
		Kea::IO::Pfam::_PfamResult->new(
			-queryId 		=> $queryId,
			-queryLocation 	=> $queryLocation,
			-hmmId			=> $hmmId,
			-hmmLocation	=> $hmmLocation,
			-bitScore		=> $bitScore,
			-eValue			=> $eValue,
			-hmmName		=> $hmmName,
			-isNested		=> $isNested
			)
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getPfamResultCollection {
	return shift->{_pfamResultCollection};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

