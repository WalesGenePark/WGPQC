#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 20/07/2009 12:43:36
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
package Kea::IO::GeneMark::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::GeneMark::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::GeneMark::IReaderHandler);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::IO::GeneMark::OrfCollection;
use Kea::IO::GeneMark::OrfFactory; 

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $orfCollection = Kea::IO::GeneMark::OrfCollection->new("");
	
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

sub _nextLine {
	
	my $self 		= shift;
	my $geneNumber 	= shift;
	my $strand 		= shift;
	my $start		= shift;
	my $end			= shift;
	my $geneLength	= shift;
	my $class		= shift;
	
	my $orfCollection = $self->{_orfCollection};
	
	my $orf = Kea::IO::GeneMark::OrfFactory->createOrf(
		-geneNumber => $geneNumber,
		-strand		=> $strand,
		-start		=> $start,
		-end		=> $end,
		-geneLength	=> $geneLength,
		-class		=> $class
		);
	
	$orfCollection->add($orf);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getOrfCollection {
	
	my $self = shift;
	return $self->{_orfCollection};
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

