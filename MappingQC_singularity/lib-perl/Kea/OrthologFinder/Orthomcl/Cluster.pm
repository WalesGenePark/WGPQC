#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 
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
package Kea::OrthologFinder::Orthomcl::Cluster;

## Purpose		: 

use strict;
use warnings;
use Carp;

use constant TRUE => 1;
use constant FALSE => 0;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

## Purpose		: Constructor.
## Parameter	: n/a.
## Throws		: n/a.
sub new {
	my ($className, %args) = @_;
	
	my $expected = $args{-numberOfProteins};
	my $actual = scalar(@{$args{-proteinIds}});
	confess "\nERROR: Expected number of protein ids ($expected) does not match actual number ($actual)" if $expected != $actual;
	
	$expected = $args{-numberOfGenomes};
	$actual = scalar(@{$args{-primaryAccessions}});
	confess "\nERROR: Expected number of genomes ($expected) does not match number of primary accessions ($actual)" if $expected != $actual;
	
	my $self = {
		_id => $args{-id},
		_numberOfProteins => $args{-numberOfProteins},
		_numberOfGenomes => $args{-numberOfGenomes},
		_proteinIds => $args{-proteinIds},
		_primaryAccessions => $args{-primaryAccessions},
		_proteinIdHash => $args{-proteinIdHash}
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

## Purpose		: ?????????????.
## Returns		: n/a.
## Parameter	: n/a.
## Throws		: n/a.
sub getId {
	return shift->{_id};
	} # End of method.

sub getNumberOfProteins {
	return shift->{_numberOfProteins};
	} # End of method.

sub getSize {
	return shift->{_numberOfProteins};
	} # End of method.

sub getNumberOfGenomes {
	return shift->{_numberOfGenomes};
	} # End ofmethod.

sub getProteinIds {
	return @{shift->{_proteinIds}};	
	}

## Purpose		: Get ids of genomes contributing to cluster. 
sub getPrimaryAccessions {
	return @{shift->{_primaryAccessions}};
	} # End of method.

sub getProteinIdHash {
	return %{shift->{_proteinIdHash}};	
	}

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

