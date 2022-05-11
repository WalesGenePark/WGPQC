#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 03/04/2008 10:53:39
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

################################################################################
## NOTE: Longer-term, make code more robust by rewriting to utilise           ##
## XML::Writer module.                                                        ##
################################################################################

# CLASS NAME
package Kea::IO::NCBI::Traceinfo::_FromTraceCollectionWriter;
use Kea::Object;
use Kea::IO::IWriter;
our @ISA = qw(Kea::Object Kea::IO::IWriter);
 
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
	my $traceCollection =
		Kea::Object->check(
			shift,
			"Kea::Assembly::NCBI::Traceinfo::TraceCollection"
			);
	
	my $self = {
		_traceCollection => $traceCollection
		};
	
	bless(
		$self,
		$className
		);
	
	return $self;
	
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $printElement =sub {
	
	my $self = shift;
	my $FILEHANDLE = $self->check(shift);
	my $element = $self->check(shift);
	
	my $name	= $element->[0];
	my $value	= $element->[1];
	
	return if (!defined $value);
	
	print $FILEHANDLE "\t\t<$name>$value</$name>\n" or
		$self->throw("Could not write to outfile");
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $printTrace = sub {

	my $self = shift;
	my $FILEHANDLE = $self->check(shift);
	my $trace = $self->check(shift, "Kea::Assembly::NCBI::Traceinfo::ITrace");

	#<trace>
	#		<trace_name>E7FAW9K01BD4ZO</trace_name>
	#		<trace_type_code>454</trace_type_code>
	#		<program_id>454Basecaller</program_id>
	#		<clip_quality_left>5</clip_quality_left>
	#		<clip_quality_right>79</clip_quality_right>
	#</trace>
	
	print $FILEHANDLE "\t<trace>\n" or
		$self->throw("Could not write to outfile");
	
	my @elements = (
		["trace_name", 			$trace->getTraceName],
		["trace_type_code", 	$trace->getTraceTypeCode],
		["program_id", 			$trace->getProgramId],
		["clip_quality_left",	$trace->getClipQualityLeft],
		["clip_quality_right", 	$trace->getClipQualityRight],
		["clip_vector_left",	$trace->getClipVectorLeft],
		["clip_vector_right", 	$trace->getClipVectorRight]
		);

	foreach my $element (@elements) {
		$self->$printElement($FILEHANDLE, $element);
		}
	
	print $FILEHANDLE "\t</trace>\n" or
		$self->throw("Could not write to outfile");
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub write {

	my $self = shift;
	my $FILEHANDLE = $self->check(shift);
	my $traceCollection = $self->{_traceCollection};

	print $FILEHANDLE "<?xml version=\"1.0\"?>\n" or
		$self->throw("Could not write to outfile");

	print $FILEHANDLE "<trace_volume>\n" or
		$self->throw("Could not write to outfile");
	
	for (my $i = 0; $i < $traceCollection->getSize; $i++) {
		my $trace = $traceCollection->get($i);
		$self->$printTrace($FILEHANDLE, $trace);
		}
	
	print $FILEHANDLE "</trace_volume>\n" or
		$self->throw("Could not write to outfile");
	
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
