#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 03/04/2008 09:33:15
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
##  NOTE: Parser fragile, as currently written - assumes line-breaks between  ##
## xml elements - ok for now, but longer-term should replace with more        ##
##Êrobust approach - e.g., using XML::Parser Module.                          ##
################################################################################

# CLASS NAME
package Kea::IO::NCBI::Traceinfo::_ToHandlerReader;
use Kea::Object;
use Kea::IO::IReader;
our @ISA = qw(Kea::Object Kea::IO::IReader);
 
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
	my $self = {};
	bless(
		$self,
		$className
		);
	return $self;
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $processTrace = sub {
	
	my $self = shift;
	my $FILEHANDLE = $self->check(shift);
	my $handler = $self->check(shift, "Kea::IO::NCBI::Traceinfo::IReaderHandler");
	
	while (<$FILEHANDLE>) {
		
		if (/^\s*<\/trace>$/) {
			$handler->_traceEnd;
			return;
			}
		
		#<trace_name>E7FAW9K01BD4ZO</trace_name>
		if (/^\s*<trace_name>(.+)<\/trace_name>$/) {
			$handler->_traceName($1);	
			}
		
		#<trace_type_code>454</trace_type_code>
		if (/^\s*<trace_type_code>(.+)<\/trace_type_code>$/) {
			$handler->_traceTypeCode($1);
			}
		
		#<program_id>454Basecaller</program_id>
		if (/^\s*<program_id>(.+)<\/program_id>$/) {
			$handler->_programId($1);	
			}
		
		#<clip_quality_left>5</clip_quality_left>
		if (/^\s*<clip_quality_left>(\d+)<\/clip_quality_left>$/) {
			$handler->_clipQualityLeft($1);	
			}
		
		#<clip_quality_right>79</clip_quality_right>
		if (/^\s*<clip_quality_right>(\d+)<\/clip_quality_right>$/) {
			$handler->_clipQualityRight($1);	
			}
		
		#<clip_vector_left>5</clip_vector_left>
		if (/^\s*<clip_vector_left>(\d+)<\/clip_vector_left>$/) {
			$handler->_clipVectorLeft($1);	
			}
		
		#<clip_vector_right>79</clip_vector_right>
		if (/^\s*<clip_vector_right>(\d+)<\/clip_vector_right>$/) {
			$handler->_clipVectorRight($1);	
			}
		
		}
	
	# Error if reach this point.
	$self->throw("Incorrect file format: expecting </trace>.");
	
	}; #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

my $processTraceVolume = sub {

	my $self = shift;
	my $FILEHANDLE = $self->check(shift);
	my $handler = $self->check(shift, "Kea::IO::NCBI::Traceinfo::IReaderHandler");
	
	while (<$FILEHANDLE>) {
		
		if (m/^\s*<\/trace_volume>$/) {
			$handler->_traceVolumeEnd;
			return;
			}
		
		if (m/^\s*<trace>$/) {
			$handler->_traceStart;
			$self->$processTrace($FILEHANDLE, $handler);
			}
		
		} # End of while.
	
	# Error if reach this point.
	$self->throw("Incorrect file format: expecting </trace_volume>.");
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub read {

	my $self = shift;
	my $FILEHANDLE = $self->check(shift);
	my $handler = $self->check(shift, "Kea::IO::NCBI::Traceinfo::IReaderHandler");
	
	# First line must be <?xml version="1.0"?>
	chomp(my $line = <$FILEHANDLE>);
	$self->throw("Incorrect file format: expecting xml header: $line.") if
		$line !~ /^<\?xml version="1\.0"\?>$/;

	while (<$FILEHANDLE>) {
		
		if (/^\s*<trace_volume>$/) {
			$handler->_traceVolumeStart;
			$self->$processTraceVolume($FILEHANDLE, $handler);
			}
		
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

=pod

<?xml version="1.0"?>
<trace_volume>
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