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
package Kea::Alignment::_Row;
use Kea::Alignment::IRow;
use Kea::Object;
our @ISA = qw(Kea::Object Kea::Alignment::IRow); 

use strict;
use warnings;

use constant TRUE 			=> 1;
use constant FALSE 			=> 0;
use constant SENSE 			=> "sense";
use constant ANTISENSE 		=> "antisense";
use constant FASTA 			=> "fasta";
use constant EMBL 			=> "embl";
use constant UNKNOWN 		=> "unknown";
use constant GAP 			=> "-";

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	my $bases = Kea::Object->check(shift);
	
	my $self = {
		_array => $bases
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

sub getSize {
	return scalar(@{shift->{_array}});
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasGaps {
	my $self = shift;
	
	my $bases = $self->{_array};
	foreach my $base (@$bases) {
		if ($base eq GAP) {return TRUE;}
		}
	return FALSE;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getGapCount {
	my $self = shift;
	
	my $bases = $self->{_array};
	my $counter = 0;
	foreach my $base (@$bases) {
		if ($base eq GAP) {
			$counter++;	
			}
		}
	return $counter;
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getProportionBases {
	
	my $self = shift;
	my $total = $self->getSize;
	my $gaps = $self->getGapCount;
	return 1 - $gaps/$total;
	
	} # End of method.


#///////////////////////////////////////////////////////////////////////////////

sub getBaseAt {
	my $self = shift;
	my $i = shift;
	return $self->{_array}->[$i];
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getBases {
	return @{shift->{_array}};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	my $self = shift;
	
	my @array = @{$self->{_array}};
	
	my $text = "[@array]";
	
	return $text;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

