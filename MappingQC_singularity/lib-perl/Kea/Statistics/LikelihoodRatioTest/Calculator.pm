#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 30/07/2008 11:06:03
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
package Kea::Statistics::LikelihoodRatioTest::Calculator;
use Kea::Object;
our @ISA = qw(Kea::Object);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::Statistics::ChiSquareTable;
use Kea::Statistics::LikelihoodRatioTest::_Result;

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

sub run {
	
	my $self 	= shift;
	my %args = @_;
	
	my $lnL0 	= $args{-fixedLnL}  	|| $args{-lnL0};
	my $lnL1 	= $args{-estimatedLnL}	|| $args{-lnL1};
	my $df 		= $args{-df};
	
	# Get chi-square table object.
	my $table = Kea::Statistics::ChiSquareTable->new;

	# Likelihood ratio test.
	my $lrt = 2 * ($lnL1 - $lnL0);
	
	# Get P value result string (in form: upperP < P < lowerP).
	my $result = $table->assess($lrt, $df);
	
	$result =~ m/^(\S+) < P < (\S+)$/ or $self->throw("Regex failed.");
	
	return Kea::Statistics::LikelihoodRatioTest::_Result->new(
		-lrt 	=> $lrt,
		-upperP => $1,
		-lowerP => $2,
		-df		=> $df
		);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

