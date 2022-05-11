#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 11/03/2009 15:12:33
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
package Kea::Quality::_QualityScores;
use Kea::Object;
use Kea::Quality::IQualityScores;
our @ISA = qw(Kea::Object Kea::Quality::IQualityScores);
 
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
	
	my %args = @_;
	
	my $record 		= $args{-record}		|| undef; # Want to be flexible not strict here!
	my $id 			= $args{-id}			|| undef; # Strictness to be inforced by public 
	my $scoresArray	= $args{-scoresArray}	|| undef; # factory class not this private class.
	
	my $self = {
		_id 		=> $id,
		_array 		=> $scoresArray,
		_record 	=> $record
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

sub getScoresAsString {

	my $self = shift;
	my @array = @{$self->{_array}};

	return "@array";	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getScoresAsArray {
	return @{shift->{_array}};
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getId {
	return shift->{_id};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSize {
	return scalar(shift->getScoresAsArray);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self = shift;
	my $id = $self->getId;
	my @scores = $self->getScoresAsArray;
	
	my $n = 30;
	my $string = ">$id\n";	
	while (@scores) {
		my @buffer = splice(@scores, 0, $n);
		$string .= "@buffer\n";
		}
		
	return $string;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

