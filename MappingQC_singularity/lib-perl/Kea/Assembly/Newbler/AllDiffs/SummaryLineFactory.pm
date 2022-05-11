#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 09/04/2008 12:31:00
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
package Kea::Assembly::Newbler::AllDiffs::SummaryLineFactory;
use Kea::Object;
our @ISA = qw(Kea::Object);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::Assembly::Newbler::AllDiffs::_SummaryLine;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	my $className = shift;
	my $self = {};
	bless(
		$self,
		$className
		);
	return $self;
	} # End of constructor.

################################################################################

#�PRIVATE METHODS

my $privateMethod = sub {
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub createSummaryLine {

	my $self = shift;
	my %args = @_;
	
	return Kea::Assembly::Newbler::AllDiffs::_SummaryLine->new(
		-refId 		=> $self->check($args{-refId}),
		-location	=> $self->check($args{-location}, "Kea::IO::Location"),
		-oldSeq		=> $self->check($args{-oldSeq}),
		-newSeqs	=> $self->checkIsArrayRef($args{-newSeqs}),
		-fwd		=> $self->check($args{-fwd}),
		-rev		=> $self->check($args{-rev}),
		-var		=> $self->checkIsInt($args{-var}),
		-tot		=> $self->checkIsInt($args{-tot}),
		-percent	=> $self->checkIsNumber($args{-percent})
		);
	

	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;
