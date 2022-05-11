#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 07/04/2008 10:26:08
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
package Kea::IO::Newbler::Trimfile::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::Newbler::Trimfile::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::Newbler::Trimfile::IReaderHandler);
 
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
	
	my $self = {};
	
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

sub _nextLine {

	my $self = shift;
	my $id = $self->check(shift);
	my $startTrimpoint = $self->checkIsInt(shift);
	my $endTrimpoint = $self->checkIsInt(shift);
	
	push(
		@{$self->{_lines}},
		[$id, $startTrimpoint, $endTrimpoint]
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getTraceCollection {
	
	my $self = shift;
	
	my $traceCollection =
		Kea::Assembly::NCBI::Traceinfo::TraceCollection->new("");
	
	my $lines = $self->{_lines};
	
	foreach my $line (@$lines) {
		$traceCollection->add(
			Kea::Assembly::NCBI::Traceinfo::TraceFactory->createTrace(
				-traceName 			=> $line->[0],
				-traceTypeCode 		=> "454",			# Follow mira traceinfo style.
				-programId			=> "54Basecaller",	# Follow mira traceinfo style.
				-clipQualityLeft	=> $line->[1],
				-clipQualityRight	=> $line->[2],
				-clipVectorLeft		=> undef,
				-clipVectorRight	=> undef	
				)
			);
		}
	
	return $traceCollection;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

