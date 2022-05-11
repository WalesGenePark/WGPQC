#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 07/03/2008 10:22:59 
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
package Kea::Alignment::Mummer::MummerAlignmentFactory;
use Kea::Object;
our @ISA = qw(Kea::Object);

## Purpose		: 

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use Kea::Alignment::Mummer::_MummerAlignment;

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

sub createMummerAlignment {
	
	my $self = shift;
	my %args = @_;
	
	my $referenceOrientation 	= $self->check($args{-referenceOrientation}); #Ê + or -
	my $referenceFrame			= $self->checkIsInt($args{-referenceFrame});
	my $queryOrientation 		= $self->check($args{-queryOrientation});
	my $queryFrame				= $self->checkIsInt($args{-queryFrame});
	my $referenceLocation 		= $self->check($args{-referenceLocation}, "Kea::IO::Location");
	my $queryLocation			= $self->check($args{-queryLocation}, "Kea::IO::Location");
	my $referenceId 			= $self->check($args{-referenceId});
	my $queryId					= $self->check($args{-queryId});
	
	
	return Kea::Alignment::Mummer::_MummerAlignment->new(
		-referenceOrientation	=> $referenceOrientation,
		-referenceFrame			=> $referenceFrame,
		-referenceLocation 		=> $referenceLocation,
		-queryOrientation		=> $queryOrientation,
		-queryFrame				=> $queryFrame,
		-queryLocation			=> $queryLocation,
		-referenceId			=> $referenceId,
		-queryId				=> $queryId
		);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

