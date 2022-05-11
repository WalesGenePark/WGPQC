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
package Kea::IO::Quality::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::Quality::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::Quality::IReaderHandler);

use strict;
use warnings;

use constant TRUE		=> 1;
use constant FALSE		=> 0;
use constant SENSE		=> "sense";
use constant ANTISENSE	=> "antisense";

use Kea::Quality::QualityScoresCollection;
use Kea::Quality::QualityScoresFactory;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $qualityScoresCollection = Kea::Quality::QualityScoresCollection->new("");
	
	my $self = {
		_currentId	 				=> undef,
		_qualityScoresCollection	=> $qualityScoresCollection
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

sub _nextHeader {

	my $self	= shift;
	my $header	= $self->check(shift);
	
	$header =~ /^(\S+)/;
	$self->{_currentId} = $1;
	
	} # End of method.


sub _nextQualityScores {
	
	my $self			= shift;
	my @array			= @{$self->check(shift)};
	
	$self->{_qualityScoresCollection}->add(
		Kea::Quality::QualityScoresFactory->createQualityScores(
			-id				=> $self->{_currentId},
			-scoresArray	=> \@array	
			)
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getQualityScoresCollection {
	return shift->{_qualityScoresCollection};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

