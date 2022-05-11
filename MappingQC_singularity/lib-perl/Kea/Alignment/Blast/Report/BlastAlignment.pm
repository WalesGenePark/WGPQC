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
package Kea::Alignment::Blast::Report::BlastAlignment;
use Kea::Object;
our @ISA = qw(Kea::Object);


use strict;
use warnings;

use constant TRUE	=> 1;
use constant FALSE	=> 0;

use Kea::IO::Location;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	my %args = @_;

	my $self = {
	
		_queryId 			=> $args{-queryId},
		_subjectId 			=> $args{-subjectId},
		_percentIdentity 	=> $args{-percentIdentity},
		_alignmentLength 	=> $args{-alignmentLength},
		_mismatches 		=> $args{-mismatches},
		_gapOpenings 		=> $args{-gapOpenings},
		_queryStart 		=> $args{-queryStart},
		_queryEnd 			=> $args{-queryEnd},	
		_subjectStart 		=> $args{-subjectStart},
		_subjectEnd 		=> $args{-subjectEnd},
		_eValue 			=> $args{-eValue},
		_bitScore 			=> $args{-bitScore}
		
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

sub getQueryId {
	return shift->{_queryId};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setQueryId {
	my ($self, $id) = @_;
	$self->{_queryId} = $id;
	} #ÊEnd of method.
		
#///////////////////////////////////////////////////////////////////////////////
				
sub getSubjectId {
	return shift->{_subjectId};
	} # End of method.		

#///////////////////////////////////////////////////////////////////////////////

sub setSubjectId {
	my ($self, $id) = @_;
	$self->{_subjectId} = $id;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getPercentIdentity {
	return shift->{_percentIdentity};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAlignmentLength {
	return shift->{_alignmentLength};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getMismatches {
	return shift->{_mismatches};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getGapOpenings {
	return shift->{_gapOpenings};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getQueryStart {
	return shift->{_queryStart};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setQueryStart {
	
	my $self = shift;
	my $start = $self->checkIsInt(shift);
	
	$self->{_queryStart} = $start;
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getQueryEnd {
	return shift->{_queryEnd};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setQueryEnd {
	
	my $self = shift;
	my $end = $self->checkIsInt(shift);
	
	$self->{_queryEnd} = $end;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSubjectStart {
	return shift->{_subjectStart};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setSubjectStart {

	my $self = shift;
	my $start = $self->checkIsInt(shift);
	
	$self->{_subjectStart} = $start;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSubjectEnd {
	return shift->{_subjectEnd};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setSubjectEnd {
	
	my $self = shift;
	my $end = $self->checkIsInt(shift);
	
	$self->{_subjectEnd} = $end;
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSubjectLocation {

	my $self = shift;
	
	return Kea::IO::Location->new(
		$self->{_subjectStart},
		$self->{_subjectEnd}
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getQueryLocation {

	my $self = shift;

	return Kea::IO::Location->new(
		$self->{_queryStart},
		$self->{_queryEnd}
		);

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getEValue {
	return shift->{_eValue};
	} # End of method.		

#///////////////////////////////////////////////////////////////////////////////

sub getBitScore {
	return shift->{_bitScore};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self = shift;
	
	my $text = sprintf(
		"%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s",
		$self->getQueryId,
		$self->getSubjectId,
		$self->getPercentIdentity,
		$self->getAlignmentLength,
		$self->getMismatches,
		$self->getGapOpenings,
		$self->getQueryStart,
		$self->getQueryEnd,
		$self->getSubjectStart,
		$self->getSubjectEnd,
		$self->getEValue,
		$self->getBitScore
		);
	
	return $text;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

