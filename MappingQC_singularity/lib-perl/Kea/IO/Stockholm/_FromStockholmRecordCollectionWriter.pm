#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 11/06/2008 18:25:43
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
package Kea::IO::Stockholm::_FromStockholmRecordCollectionWriter;
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
	
	my $recordCollection =
		Kea::Object->check(shift, "Kea::IO::Stockholm::RecordCollection");
	
	my $self = {
		_recordCollection => $recordCollection
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

sub write {

	my $self				= shift;
	my $FILEHANDLE			= $self->check(shift);
	my $recordCollection	= $self->{_recordCollection};
	
	#	# STOCKHOLM 1.0
	#	#=GF ID   2-Hacid_dh
	#	#=GF AC   PF00389.21
	#	#=GF DE   D-isomer specific 2-hydroxyacid dehydrogenase, catalytic domain
	# 	...
	#	//
	
	print $FILEHANDLE "# STOCKHOLM 1.0\n" or
			$self->throw("Could not write to outfile: $!");;
	
	for (my $i = 0; $i < $recordCollection->getSize; $i++) {
		my $record = $recordCollection->get($i);
		
		print $FILEHANDLE "#=GF ID   " . $record->getId . "\n" or
			$self->throw("Could not write to outfile: $!");
			
		print $FILEHANDLE "#=GF AC   " . $record->getAccession . "\n" or
			$self->throw("Could not write to outfile: $!");
			
		print $FILEHANDLE "#=GF DE   " . $record->getDescription . "\n" or
			$self->throw("Could not write to outfile: $!");
		
		print $FILEHANDLE "\/\/\n" or
			$self->throw("Could not write to outfile: $!");		
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

