#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 03/04/2008 10:46:25
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
package Kea::Assembly::NCBI::Traceinfo::_Trace;
use Kea::Object;
use Kea::Assembly::NCBI::Traceinfo::ITrace;
our @ISA = qw(Kea::Object Kea::Assembly::NCBI::Traceinfo::ITrace);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";
use constant UNDEF		=> "undef";

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	my %args = @_;
	
	my $self = {
		_traceName 			=> Kea::Object->check($args{-traceName}),
		_traceTypeCode 		=> $args{-traceTypeCode},
		_programId			=> $args{-programId},
		_clipQualityLeft	=> $args{-clipQualityLeft},
		_clipQualityRight	=> $args{-clipQualityRight},
		_clipVectorLeft		=> $args{-clipVectorLeft},
		_clipVectorRight	=> $args{-clipVectorRight}
		};

	bless(
		$self,
		$className
		);
	return $self;
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $checkForUndef = sub {
	
	my $self = shift;
	my $value = shift;
	
	if (defined $value) {return  $value;}
	else {
		return "undef";
		}

	}; # End of method.

################################################################################

# PUBLIC METHODS

sub getTraceName {
	return shift->{_traceName};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getTraceTypeCode {
	return shift->{_traceTypeCode};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getProgramId {
	return shift->{_programId};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setClipQualityLeft {
	
	my $self = shift;
	my $position = $self->checkIsInt(shift);
	
	$self->{_clipQualityLeft} = $position;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getClipQualityLeft {
	return shift->{_clipQualityLeft};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setClipQualityRight {
	
	my $self = shift;
	my $position = $self->checkIsInt(shift);
	
	$self->{_clipQualityRight} = $position;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getClipQualityRight {
	return shift->{_clipQualityRight};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getClipVectorLeft {
	return shift->{_clipVectorLeft};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getClipVectorRight {
	return shift->{_clipVectorRight};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self = shift;
	
	my $traceName 			= $self->getTraceName;
	my $traceTypeCode 		= $self->$checkForUndef($self->getTraceTypeCode);
	my $programId 			= $self->$checkForUndef($self->getProgramId);
	my $clipQualityLeft 	= $self->$checkForUndef($self->getClipQualityLeft);
	my $clipQualityRight 	= $self->$checkForUndef($self->getClipQualityRight);
	my $clipVectorLeft 		= $self->$checkForUndef($self->getClipVectorLeft);
	my $clipVectorRight 	= $self->$checkForUndef($self->getClipVectorRight);
	
	return sprintf(
		
		"%20s %s\n" .
		"%20s %s\n" .
		"%20s %s\n" .
		"%20s %s\n" .
		"%20s %s\n" .
		"%20s %s\n" .
		"%20s %s\n" ,
		
		"trace_name:"			, $traceName,
		"trace_type_code:"		, $traceTypeCode,
		"program_id:"			, $programId,
		"clip_quality_left:"	, $clipQualityLeft,
		"clip_quality_right:"	, $clipQualityRight,
		"clip_vector_left:"		, $clipVectorLeft,
		"clip_vector_right:"	, $clipVectorRight
		);
	
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
