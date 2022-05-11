#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 03/04/2008 09:33:29
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
package Kea::IO::NCBI::Traceinfo::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::NCBI::Traceinfo::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::NCBI::Traceinfo::IReaderHandler);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::Assembly::NCBI::Traceinfo::TraceCollection;
use Kea::Assembly::NCBI::Traceinfo::TraceFactory;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	my $className = shift;
	
my $traceCollection = Kea::Assembly::NCBI::Traceinfo::TraceCollection->new("");
	
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

my $privateMethod = sub {
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub _traceVolumeStart {
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub _traceVolumeEnd {
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub _traceStart {
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub _traceEnd {
	
	my $self = shift;
	
	my $traceCollection = $self->{_traceCollection};
	$traceCollection->add(
		Kea::Assembly::NCBI::Traceinfo::TraceFactory->createTrace(
			-traceName 			=> $self->{_traceName},
			-traceTypeCode 		=> $self->{_traceTypeCode},
			-programId			=> $self->{_programId},
			-clipQualityLeft	=> $self->{_clipQualityLeft},
			-clipQualityRight	=> $self->{_clipQualityRight},
			-clipVectorLeft		=> $self->{_clipVectorLeft},
			-clipVectorRight	=> $self->{_clipVectorRight}
			)
		);
	
	$self->{_traceName} 		= undef;
	$self->{_traceTypeCode}		= undef;
	$self->{_programId}			= undef;
	$self->{_clipQualityLeft}	= undef;
	$self->{_clipQualityRight}	= undef;
	$self->{_clipVectorLeft}	= undef;
	$self->{_clipVectorRight}	= undef;
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub _traceName {
	
	my $self = shift;
	my $name = $self->check(shift);
	
	# Should be undefined at this point - check.
	$self->throw("Trace name already exists.") if defined $self->{_traceName};
	
	$self->{_traceName} = $name;
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub _traceTypeCode {

	my $self = shift;
	my $traceTypeCode = $self->check(shift);
	
	# Should be undefined at this point - check.
	$self->throw("Trace type code already exists.") if defined $self->{_traceTypeCode};
	
	$self->{_traceTypeCode} = $traceTypeCode;
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub _programId {
	
	my $self = shift;
	my $programId = $self->check(shift);
	
	# Should be undefined at this point - check.
	$self->throw("Program id already exists.") if defined $self->{_programId};
	
	$self->{_programId} = $programId;
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub _clipQualityLeft {
	
	my $self = shift;
	my $clipQualityLeft = $self->checkIsInt(shift);
	
	# Should be undefined at this point - check.
	$self->throw("Clip-quality-left position already exists.") if
		defined $self->{_clipQualityLeft};
	
	$self->{_clipQualityLeft} = $clipQualityLeft;
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub _clipQualityRight {
	
	my $self = shift;
	my $clipQualityRight = $self->checkIsInt(shift);
	
	# Should be undefined at this point - check.
	$self->throw(
		"clip_quality_right=$clipQualityRight, replacing " .
		$self->{_clipQualityRight} . "."
		) if
		defined $self->{_clipQualityRight};
	
	$self->{_clipQualityRight} = $clipQualityRight;
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub _clipVectorLeft {
	
	my $self = shift;
	my $clipVectorLeft = $self->checkIsInt(shift);
	
	# Should be undefined at this point - check.
	$self->throw("Clip-vector-left position already exists.") if
		defined $self->{_clipVectorLeft};
	
	$self->{_clipVectorLeft} = $clipVectorLeft;
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub _clipVectorRight {
	
	my $self = shift;
	my $clipVectorRight = $self->checkIsInt(shift);
	
	# Should be undefined at this point - check.
	$self->throw("Clip-vector-right position already exists.") if
		defined $self->{_clipVectorRight};
	
	$self->{_clipVectorRight} = $clipVectorRight;
	
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getTraceCollection {
	return shift->{_traceCollection};
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