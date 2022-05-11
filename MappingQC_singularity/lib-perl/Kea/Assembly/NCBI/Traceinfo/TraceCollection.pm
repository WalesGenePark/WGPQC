#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 03/04/2008 10:48:26
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
package Kea::Assembly::NCBI::Traceinfo::TraceCollection;
use Kea::Object;
use Kea::ICollection;
our @ISA = qw(Kea::Object Kea::ICollection);

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
	my $overallId = shift || "unknown";
	
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

#�PRIVATE METHODS

my $privateMethod = sub {
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub getOverallId {
	return shift->{_overallId};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setOverallId {

	my $self = shift;
	my $id = $self->check(shift);
	
	$self->{_overallId} = $id;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasOverallId {
	
	my $self = shift;
	
	if (defined $self->{_overallId}) {
		return TRUE;
		}
	else {
		return FALSE;
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSize {
	return scalar(@{shift->{_array}});
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub get {
	
	my $self 	= shift;
	my $i 		= $self->checkIsInt(shift);

	return $self->{_array}->[$i];
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAll {
	return @{shift->{_array}};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub add {

	my $self = shift;
	my $object = $self->check(shift, "Kea::Assembly::NCBI::Traceinfo::ITrace");
	
	push(
		@{$self->{_array}},
		$object
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub isEmpty {
	
	my $self = shift;
	
	if ($self->getSize == 0) {
		return TRUE;
		}
	else {
		return FALSE;
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {

	my $self = shift;
	
	my $text = "";
	
	foreach my $trace (@{$self->{_array}}) {
		$text .= $trace->toString . "\n";
		}
	
	return $text;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

=pod

See: http://www.ncbi.nlm.nih.gov/Traces/trace.cgi?cmd=show&f=rfc&m=main&s=rfc

trace_volume>
        <trace>
                <trace_name>E7FAW9K01BD4ZO</trace_name>
                <trace_type_code>454</trace_type_code>
                <program_id>454Basecaller</program_id>
                <clip_quality_left>5</clip_quality_left>
                <clip_quality_right>79</clip_quality_right>
        </trace>

		
		<trace>
                <trace_name>E7FAW9K02DGW3L</trace_name>
                <trace_type_code>454</trace_type_code>
                <program_id>454Basecaller</program_id>
                <clip_quality_left>5</clip_quality_left>
                <clip_quality_right>101</clip_quality_right>
        </trace>
</trace_volume>
=cut