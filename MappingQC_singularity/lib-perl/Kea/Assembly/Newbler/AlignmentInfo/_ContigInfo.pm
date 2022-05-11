#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 07/05/2008 15:28:32
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
package Kea::Assembly::Newbler::AlignmentInfo::_ContigInfo;
use Kea::Object;
use Kea::Assembly::Newbler::AlignmentInfo::IContigInfo;
our @ISA = qw(Kea::Object Kea::Assembly::Newbler::AlignmentInfo::IContigInfo);
 
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
	
	my $className	= shift;
	my $id 			= Kea::Object->check(shift);
	my $number 		= Kea::Object->checkIsInt(shift);
	
	my $self = {
	
		_id 					=> $id,
		_number 				=> $number,
	
		_baseArray 				=> [],
		_qualityScoreArray 		=> [],
		_depthArray				=> [],
		_signalArray 			=> [],
		_standardDeviationArray => []
	
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

sub _addInfo {

	my $self 				= shift;
	my $position 			= $self->checkIsInt(shift);		# Position in contig.
	my $base 				= $self->checkIsChar(shift);	# consensus base.
	my $qualityScore		= $self->checkIsInt(shift);		# quality score.
	my $depth				= $self->checkIsInt(shift);		# depth.
	my $signal				= $self->checkIsNumber(shift);	# Signal.
	my $standardDeviation	= $self->checkIsNumber(shift);	# Standard deviation.
	
	push(@{$self->{_baseArray}}, uc($base));
	push(@{$self->{_qualityScoreArray}}, $qualityScore);
	push(@{$self->{_depthArray}}, $depth);
	push(@{$self->{_signalArray}}, $signal);
	push(@{$self->{_standardDeviationArray}}, $standardDeviation);

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getId {
	return shift->{_id};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getNumber {
	return shift->{_number};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getBases {
	return shift->{_baseArray};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getQualityScores {
	return shift->{_qualityScoreArray};
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub getDepths {
	return shift->{_depthArray};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSignals {
	return shift->{_signalArray};
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub getStandardDeviations {
	return shift->{_standardDeviationArray};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

