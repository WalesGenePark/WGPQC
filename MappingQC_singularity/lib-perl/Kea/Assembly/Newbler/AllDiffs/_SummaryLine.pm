#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 05/03/2008 14:20:06 
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
package Kea::Assembly::Newbler::AllDiffs::_SummaryLine;
use Kea::Object;
use Kea::Assembly::Newbler::AllDiffs::ISummaryLine;
our @ISA = qw(Kea::Object Kea::Assembly::Newbler::AllDiffs::ISummaryLine);

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	my %args = @_;

	
	my $self = {
		_refId 		=> $args{-refId},
		_location	=> Kea::Object->check($args{-location}, "Kea::IO::Location"),
		_oldSeq		=> $args{-oldSeq},
		_newSeqs	=> Kea::Object->checkIsArrayRef($args{-newSeqs}),
		_fwd		=> $args{-fwd},
		_rev		=> $args{-rev},
		_var		=> $args{-var},
		_tot		=> $args{-tot},
		_percent	=> $args{-percent}
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

sub getReferenceId 	{
	return shift->{_refId};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLocation {
	return shift->{_location};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getRefSequenceAtLocation {
	return shift->{_oldSeq}
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getDifferingSequencesAtLocation {
	return shift->{_newSeqs}
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getTotalFowardReadsWithDifference {
	return shift->{_fwd};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getTotalReverseReadsWithDifference {
	return shift->{_rev};
	} # End of method.	

#///////////////////////////////////////////////////////////////////////////////

sub getTotalReadsWithDifference {
	return shift->{_var};	
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub getTotalReads {
	return shift->{_tot};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getPercentDifferentReads {
	return shift->{_percent};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {

	my $self = shift;
	
	my $diffSeqString;
	my $diffSeqs = $self->getDifferingSequencesAtLocation;
	if (@$diffSeqs == 1) {
		$diffSeqString = $diffSeqs->[0];
		}
	elsif (@$diffSeqs > 1) {
		$diffSeqString = "[" . join(", ", @$diffSeqs) ."]";
		}
	else {
		$self->throw("No differing sequence!");
		}
	
	return sprintf(
		"%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s",
		$self->getReferenceId,
		$self->getLocation->getStart,
		$self->getLocation->getEnd,
		$self->getRefSequenceAtLocation,
		$diffSeqString,
		$self->getTotalFowardReadsWithDifference,
		$self->getTotalReverseReadsWithDifference,
		$self->getTotalReadsWithDifference,
		$self->getTotalReads,
		$self->getPercentDifferentReads
		);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

