#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 07/04/2008 10:26:36
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
package Kea::IO::Newbler::Trimfile::_FromTraceCollectionWriter;
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
		Kea::Object->check(shift, "Kea::Assembly::NCBI::Traceinfo::TraceCollection");
	
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

#?PRIVATE METHODS

my $privateMethod = sub {
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub write {

	my $self 			= shift;
	my $FILEHANDLE 		= $self->check(shift);
	my $traceCollection = $self->{_traceCollection};
	
	for (my $i = 0; $i < $traceCollection->getSize; $i++) {
		my $trace = $traceCollection->get($i);
		
		my $id 					= $trace->getTraceName;
		my $clipQualityLeft 	= $trace->getClipQualityLeft;
		my $clipQualityRight 	= $trace->getClipQualityRight;
		my $clipVectorLeft		= $trace->getClipVectorLeft;
		my $clipVectorRight		= $trace->getClipVectorRight;
		
		# Current code does not yet handle vector trimming info.
		if (defined $clipVectorLeft or $clipVectorRight) {
			$self->throw("clip_vector information not currently supported.");
			}
		
		print $FILEHANDLE "$id $clipQualityLeft $clipQualityRight\n" or
			$self->throw("Could not write to outfile.");
			
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

