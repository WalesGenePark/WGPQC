#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 05/08/2009 16:52:39
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
package Kea::IO::MyORF::DefaultReaderHandler;
use Kea::IO::MyORF::IReaderHandler;
use Kea::Object;
our @ISA = qw(Kea::Object Kea::IO::MyORF::IReaderHandler);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::IO::MyORF::ORFCollection;
use Kea::IO::MyORF::ORFFactory;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	my $className = shift;
	
	
	my $self = {
		_orfCollections			=> undef,
		_currentORFCollection	=> undef
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

sub _nextHeader {
	
	my $self = shift;
	my $header = $self->check(shift);
	
	my $orfCollection = Kea::IO::MyORF::ORFCollection->new($header);
	push(@{$self->{_orfCollections}}, $orfCollection);
	
	$self->{_currentOrfCollection} = $orfCollection
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextORF {
	
	my $self 		= shift;
	my $id 			= $self->check(shift);
	my $start 		= $self->check(shift);
	my $end			= $self->check(shift);
	my $orientation	= $self->checkIsOrientation(shift);
	my $program		= $self->check(shift);
	my $note 		= $self->check(shift);
	
	$self->{_currentOrfCollection}->add(
		Kea::IO::MyORF::ORFFactory->createORF(
			-id 			=> $id,
			-start			=> $start,
			-end			=> $end,
			-orientation	=> $orientation,
			-program		=> $program,
			-note			=> $note
			)
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getOrfCollections {
	
	my $self = shift;
	
	return $self->{_orfCollections};
	
	} # End of method.

sub getOrfCollectionsMap {
	
	my $self = shift;
	
	my %map;
	foreach my $orfCollection (@{$self->{_orfCollections}}) {
		$map{$orfCollection->getOverallId} = $orfCollection;
		}
	
	return \%map;
	
	} # end of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

