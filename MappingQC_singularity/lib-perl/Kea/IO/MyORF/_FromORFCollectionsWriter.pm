#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 05/08/2009 17:53:37
#    Copyright (C) 2009, University of Liverpool.
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
package Kea::IO::MyORF::_FromORFCollectionsWriter;
use Kea::IO::IWriter;
use Kea::Object;
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
	my $orfCollections = shift;
	
	my $self = {
		_orfCollections => $orfCollections
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

sub write {
	
	my $self = shift;
	my $FILEHANDLE = $self->check(shift);
	my $orfCollections = $self->{_orfCollections};
	
	foreach my $orfCollection (@$orfCollections) {
		
		print $FILEHANDLE ">" . $orfCollection->getOverallId . "\n";
		
		for (my $i = 0; $i < $orfCollection->getSize; $i++) {
			my $orf = $orfCollection->get($i);
			
			printf $FILEHANDLE (
				"%s\t%s\t%s\t%s\t%s\t%s\n",
				$orf->getId,
				$orf->getStart,
				$orf->getEnd,
				$orf->getOrientation,
				$orf->getProgram,
				$orf->getNote
				);
			
			}
		
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

