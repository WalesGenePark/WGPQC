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
package Kea::Assembly::ContigCollection;
use Kea::Object;
use Kea::ICollection;
our @ISA = qw(Kea::Object Kea::ICollection);

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
	my $overallId = Kea::Object->check(shift) || "null";
	
	
	my $self = {
		_overallId 	=> $overallId,
		_array 		=> []
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

sub getOverallId {
	return shift->{_overallId};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSize {
	return scalar(@{shift->{_array}});
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub get {
	my ($self, $i) = @_;
	return $self->{_array}->[$i];
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAll {
	return @{shift->{_array}};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub add {

	my $self 	= shift;
	my $contig 	= $self->check(shift, "Kea::Assembly::IContig");
	
	push(
		@{$self->{_array}},
		$contig
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	my $self = shift;
	
	my $text = "Size = " . $self->getSize . "\n";
	
	my @contigs = $self->getAll;
	foreach my $contig (@contigs) {
		$text = $text . $contig->toString . "\n";
		}
	
	return $text;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

