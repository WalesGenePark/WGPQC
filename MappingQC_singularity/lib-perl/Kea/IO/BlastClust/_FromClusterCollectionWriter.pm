#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 15/02/2008 17:43:14 
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


#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////

# CLASS NAME
package Kea::IO::BlastClust::_FromClusterCollectionWriter;
use Kea::Object;
use Kea::IO::IWriter;
our @ISA = qw(Kea::Object Kea::IO::IWriter);

## Purpose		: 

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
	my $clusterCollection =
		Kea::Object->check(shift, "Kea::Sequence::ClusterCollection");
	
	my $self = {
		_clusterCollection => $clusterCollection
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

	my $self = shift;
	my $FILEHANDLE = $self->check(shift);
	
	my $clusterCollection = $self->{_clusterCollection};
	
	for (my $i = 0; $i < $clusterCollection->getSize; $i++) {
		my $cluster = $clusterCollection->get($i);
		my $sequenceCollection = $cluster->getSequenceCollection;
		
		my @ids;
		for (my $j = 0; $j < $sequenceCollection->getSize; $j++) {
			my $sequence = $sequenceCollection->get($j);
			push(@ids, $sequence->getID);
			}
		# Sort ids to ensure consistent output.
		@ids = sort @ids;
		
		print $FILEHANDLE "@ids \n";
		
		} # End of for loop - no more clusters.
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

