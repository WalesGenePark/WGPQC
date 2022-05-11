#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 30/01/2009 15:23:32
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
package Kea::IO::Newbler::NewblerMetrics::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::Newbler::NewblerMetrics::IReaderHandler;
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
	
	my $self = {
		_totalNumberOfReads 		=> undef,
		_totalNumberOfBases 		=> undef,
		_numberOfSearches 			=> undef,
		_seedHitsFound 				=> undef,
		_overlapsReported 			=> undef,
		_overlapsUsed 				=> undef,
		_numAlignedReads 			=> undef,
		_numAlignedBases 			=> undef,
		_inferredReadError 			=> undef,
		_numberAssembled 			=> undef,
		_numberPartial 				=> undef,
		_numberSingletons 			=> undef,
		_numberRepeat 				=> undef,
		_numberOutlier 				=> undef,
		_numberTooShort 			=> undef,
		_numberOfLargeContigs 		=> undef,
		_numberOfLargeContigBases 	=> undef,
		_avgLargeContigSize 		=> undef,
		_N50ContigSize 				=> undef,
		_largestContigSize 			=> undef,
		_Q40PlusBases 				=> undef,
		_Q39MinusBases 				=> undef,
		_numberOfContigs 			=> undef,
		_numberOfBases 				=> undef
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

sub _totalNumberOfReads {
	
	my $self 	= shift;
	my $n		= $self->checkIsInt(shift);
	
	$self->{_totalNumberOfReads} = $n;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _totalNumberOfBases {
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _numberOfSearches {
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _seedHitsFound	{

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _overlapsFound	{
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////
	
sub _overlapsReported {
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _overlapsUsed {
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _numAlignedReads {
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _numAlignedBases {
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _inferredReadError {
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _numberAssembled {
	
	} # End of method

#///////////////////////////////////////////////////////////////////////////////

sub _numberPartial {
	
	} # End of method

#///////////////////////////////////////////////////////////////////////////////

sub _numberSingletons {
	
	} # End of method

#///////////////////////////////////////////////////////////////////////////////

sub _numberRepeat {
	
	} # End of method

#///////////////////////////////////////////////////////////////////////////////

sub _numberOutlier {
	
	} # End of method

#///////////////////////////////////////////////////////////////////////////////

sub _numberTooShort {
	
	} # End of method

#///////////////////////////////////////////////////////////////////////////////

sub _numberOfLargeContigs {
	
	} # End of method

#///////////////////////////////////////////////////////////////////////////////

sub _numberOfLargeContigBases {
	
	} # End of method

#///////////////////////////////////////////////////////////////////////////////

sub _avgLargeContigSize {
	
	} # End of method

#///////////////////////////////////////////////////////////////////////////////

sub _N50ContigSize {
	
	} # End of method

#///////////////////////////////////////////////////////////////////////////////

sub _largestContigSize {
	
	} # End of method

#///////////////////////////////////////////////////////////////////////////////

sub _Q40PlusBases {
	
	} # End of method

#///////////////////////////////////////////////////////////////////////////////

sub _Q39MinusBases {
	
	} # End of method

#///////////////////////////////////////////////////////////////////////////////

sub _numberOfContigs {
	
	} # End of method

#///////////////////////////////////////////////////////////////////////////////

sub _numberOfBases {
	
	} # End of method

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

