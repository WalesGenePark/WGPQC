#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 22/07/2009 17:15:36
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
package Kea::IO::GeneMark::_FromOrfCollectionWriter;
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

	my $orfCollection = Kea::Object->check(shift, "Kea::IO::GeneMark::OrfCollection");
	
	my $self = {
		_orfCollection => $orfCollection
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
	my $orfCollection = $self->{_orfCollection};
	my $FILEHANDLE = $self->check(shift);
	
	print $FILEHANDLE "Predicted genes\n";
	print $FILEHANDLE "   Gene    Strand    LeftEnd    RightEnd       Gene     Class\n";
	print $FILEHANDLE "    #                                         Length\n";

	
	
	for (my $i = 0; $i < $orfCollection->getSize; $i++) {
		my $orf = $orfCollection->get($i);
		print $FILEHANDLE $orf->toString . "\n";
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

