#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 07/05/2008 15:24:39
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
package Kea::IO::Newbler::AlignmentInfo::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::Newbler::AlignmentInfo::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::Newbler::AlignmentInfo::IReaderHandler);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::Assembly::Newbler::AlignmentInfo::ContigInfoCollection;
use Kea::Assembly::Newbler::AlignmentInfo::ContigInfoFactory;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $contigInfoCollection =
		Kea::Assembly::Newbler::AlignmentInfo::ContigInfoCollection->new("");
	
	my $self = {
		_contigInfoCollection => $contigInfoCollection
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
	
	my $self = shift;
	my $id = $self->check(shift);
	my $number = $self->checkIsInt(shift);
	
	$self->{_contigInfoCollection}->add(
		Kea::Assembly::Newbler::AlignmentInfo::ContigInfoFactory->createContigInfo(
			-id 	=> $id,
			-number => $number	
			)
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextInfoLine {
	
	my $self 				= shift;
	my $position 			= $self->checkIsInt(shift);		# Position in contig.
	my $base 				= $self->checkIsChar(shift);	# consensus base.
	my $qualityScore		= $self->checkIsInt(shift);		# quality score.
	my $depth				= $self->checkIsInt(shift);		# depth.
	my $signal				= $self->checkIsNumber(shift);	# Signal.
	my $standardDeviation	= $self->checkIsNumber(shift);	# Standard deviation.
	
	my $contigInfo = $self->{_contigInfoCollection}->getLast;
	
	$contigInfo->_addInfo(
		$position,
		$base,
		$qualityScore,
		$depth,
		$signal,
		$standardDeviation
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getContigInfoCollection {
	return shift->{_contigInfoCollection};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

