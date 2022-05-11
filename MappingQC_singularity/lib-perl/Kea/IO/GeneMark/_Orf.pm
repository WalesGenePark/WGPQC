#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 21/07/2009 13:13:12
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
package Kea::IO::GeneMark::_Orf;
use Kea::Object;
use Kea::IO::GeneMark::IOrf;
our @ISA = qw(Kea::Object Kea::IO::GeneMark::IOrf);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::IO::Location;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className 	= shift;
	my $geneNumber 	= shift;
	my $strand 		= shift;
	my $start		= shift;
	my $end			= shift;
	my $geneLength	= shift;
	my $class		= shift; 
	
	my $self = {
		_geneNumber => $geneNumber,
		_strand		=> $strand,
		_start 		=> $start,
		_end		=> $end,
		_geneLength	=> $geneLength,
		_class		=> $class
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

sub getGeneNumber {
	return shift->{_geneNumber};
	} # End of method.

sub setGeneNumber {
	my $self 		= shift;
	my $geneNumber 	= $self->checkIsInt(shift);
	$self->{_geneNumber} = $geneNumber;
	} # End of method. 

sub getStrand {
	return shift->{_strand};
	} # End of method.

sub setStrand {
	my $self = shift;
	my $strand = $self->check(shift);
	$self->{_strand} = $strand;
	} # End of method.

# Use this method to get stranded information as a string - SENSE or ANTISENSE
sub getOrientation {
	my $self = shift;
	my $strand = $self->getStrand;
	
	if ($strand eq "+") {
		return SENSE;
		}
	elsif ($strand eq "-") {
		return ANTISENSE;
		}
	else {
		$self->throw("Unexpected strand symbol: '$strand'.");
		}
	
	}

sub getStart {
	return shift->{_start};
	} # End of method.

sub setStart {
	my $self = shift;
	my $start = $self->check(shift);
	$self->{_start} = $start;
	} # End of method.

sub getEnd {
	return shift->{_end};
	} # End of method.

sub setEnd {
	my $self = shift;
	my $end = $self->check(shift);
	$self->{_end} = $end;
	} # End of method.


#///////////////////////////////////////////////////////////////////////////////

# Returns location object generated from start and end values.
sub getLocation {

	my $self 	= shift;
	my $start 	= $self->getStart;
	my $end 	= $self->getEnd;
	
	return Kea::IO::Location->new($start, $end);
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getGeneLength {
	return shift->{_geneLength};	
	} # End of method.

sub setGeneLength {
	my $self = shift;
	my $geneLength = $self->checkIsInt(shift);
	$self->{_geneLength} = $geneLength;
	} # End of method.

sub getClass {
	return shift->{_class};
	} # End of method.

sub setClass {
	my $self = shift;
	my $class = $self->checkIsInt(shift);
	$self->{_class} = $class;
	} # End of method.

sub toString {
	
	my $self = shift;
	my $geneNumber 	= $self->getGeneNumber;
	my $strand 		= $self->getStrand;
	my $start		= $self->getStart;
	my $end			= $self->getEnd;
	my $geneLength	= $self->getGeneLength;
	my $class		= $self->getClass;
		
	return sprintf(
		"%5d%9s%12s%12s%13d%9d",
		$geneNumber,
		$strand,
		$start,
		$end,
		$geneLength,
		$class
		);	
		
	}

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

