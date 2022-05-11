#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 03/04/2008 10:45:57
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

# INTERFACE NAME
package Kea::Assembly::NCBI::Traceinfo::ITrace;

use strict;
use warnings;
use Kea::Object;

our $_message = "Undefined method.";

################################################################################

sub getTraceName	 	{Kea::Object->throw($_message);}

sub getTraceTypeCode	{Kea::Object->throw($_message);}

sub getProgramId		{Kea::Object->throw($_message);}

sub getClipQualityLeft	{Kea::Object->throw($_message);}

sub getClipQualityRight	{Kea::Object->throw($_message);}

sub setClipQualityLeft	{Kea::Object->throw($_message);}

sub setClipQualityRight	{Kea::Object->throw($_message);}

sub getClipVectorLeft	{Kea::Object->throw($_message);}

sub getClipVectorRight	{Kea::Object->throw($_message);}

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