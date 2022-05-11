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
package Kea::IO::Glimmer::ORF;
use Kea::Object;
our @ISA = qw(Kea::Object);

use strict;
use warnings;

use constant TRUE => 1;
use constant FALSE => 0;

use constant SENSE => "sense";
use constant ANTISENSE => "antisense";

use Kea::IO::Location;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	my $className = shift;
	my %args = @_;
	
	my $id = $args{-id};
	
	my $start = $args{-start};
	my $end = $args{-end};
	
	my $orientation = SENSE;
	if ($start > $end) {
		$start = $args{-end};
		$end = $args{-start};
		$orientation = ANTISENSE;
		}
	
	my $size = $end-$start+1;
	
	if ($size % 3) {
		Kea::Object->throw("Orf size wrong for $id - $size is not a multiple of 3");	
		}
	
	my $self = {
		_id => $id,
		_start => $start,
		_end => $end,
		_location => Kea::IO::Location->new($start, $end),
		_size => $size,
		_orientation => $orientation,
		_readingFrame => $args{-readFrame},
		_rawScore => $args{-rawScore}
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

# orf code. e.g. orf00001 
sub getId {return shift->{_id};}

# Start location within contig.
sub getStart {return shift->{_start};}

sub getLocation {return shift->{_location};}

# End position within contig.
sub getEnd {return shift->{_end};}

sub getSize {return shift->{_size};}

sub getOrientation {return shift->{_orientation};}

# Reading frame: -3, -2, -1, +1, +2, +3
sub getReadingFrame {return shift->{_readingFrame};}

sub getRawScore {return shift->{_rawScore};}

sub toString {
	my $self = shift;
	
	my $text = sprintf(
		"ID = %s, start = %s, end = %s, size = %s, %s, reading frame = %s, raw score = %s",
		$self->getId,
		$self->getStart,
		$self->getEnd,
		$self->getSize,
		$self->getOrientation,
		$self->getReadingFrame,
		$self->getRawScore
		);
	
	return $text;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

