#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 05/08/2008 10:02:42
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
package Kea::IO::SOLiD::MatchFile::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::SOLiD::MatchFile::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::SOLiD::MatchFile::IReaderHandler);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::IO::SOLiD::MatchFile::Hit;
use Kea::IO::SOLiD::MatchFile::HitCollection;
use Kea::IO::SOLiD::MatchFile::_MatchResult;
use Kea::IO::SOLiD::MatchFile::MatchResultCollection;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $matchResultCollection =
		Kea::IO::SOLiD::MatchFile::MatchResultCollection->new("");
	
	my $self = {
		_matchResultCollection => $matchResultCollection
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

sub _nextMatch {
	
	my $self = shift;
	my $id = $self->check(shift);
	my $hitList = $self->checkIsArrayRef(shift);
	
	my $hitCollection = Kea::IO::SOLiD::MatchFile::HitCollection->new("");
	
	foreach my $hitString (@$hitList) {
	
		if ($hitString =~ /^(\d+)\.(\d+)$/) {
			
			$hitCollection->add(
				Kea::IO::SOLiD::MatchFile::Hit->new(
					SENSE,	# Orientation
					$1,		# position
					$2		# mismatch
					)
				);
			}
	
		elsif ($hitString =~ /^-(\d+)\.(\d+)$/) {
		
			$hitCollection->add(
				Kea::IO::SOLiD::MatchFile::Hit->new(
					ANTISENSE,	# Orientation
					$1,			# position
					$2			# mismatch
					)
				);
			}
		else {
			$self->throw(
				"Unaccounted for hit string: $hitString."
				);
			}
		}
	
	
	my $matchResult = Kea::IO::SOLiD::MatchFile::_MatchResult->new(
		$id,
		$hitCollection
		);
	
	$self->{_matchResultCollection}->add($matchResult);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getMatchResultCollection {
	return shift->{_matchResultCollection};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

