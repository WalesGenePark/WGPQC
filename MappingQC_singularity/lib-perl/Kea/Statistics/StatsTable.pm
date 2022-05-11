#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 27/03/2008 15:40:07
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
package Kea::Statistics::StatsTable;
use Kea::Object;
our @ISA = qw(Kea::Object);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";
use constant NaN 		=> 0;

use Kea::Statistics::Toolkit;
use Kea::Number;

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

sub getTableAsSingleLine {
	
	my $self = shift;
	my $data = $self->checkIsArrayRef(shift);
	
	my $sd		= NaN;
	my $min 	= NaN;
	my $max 	= NaN;
	my $range 	= NaN;
	my $median 	= NaN;
	my $q1		= NaN;
	my $q3		= NaN;
	
	my $stats = Kea::Statistics::Toolkit->new;
	
	my $n 		= $stats->getN(@$data);
	my $sum 	= $stats->getSum(@$data);
	my $mean 	= $stats->getArithmeticMean(@$data);
	my $mode 	= $stats->getMode(@$data);
	
	if ($n > 2) {
		$sd			= $stats->getStandardDeviation(1, @$data);
		$min 		= $stats->getMinimum(@$data);
		$max 		= $stats->getMaximum(@$data);
		$range 		= $stats->getRange(@$data);
		$median 	= $stats->getMedian(@$data);
		$q1			= $stats->getQ1(@$data);
		$q3			= $stats->getQ3(@$data);
		}
	
	my $number = Kea::Number->new;
	
	my $text = sprintf(
		"%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s",
		#"n=%s\tsum=%s\tmean=%s\tsd=%s\tmedian=%s\tmode=%s\tq1=%s\tq3=%s\tmin=%s\tmax=%s\trange=%s",
		$number->format($n),
		$number->format($sum),
		$number->format($number->roundup($mean, 2)),
		$number->format($number->roundup($sd, 2)),
		$number->format($number->roundup($median, 2)),
		$number->format($number->roundup($mode, 2)),
		$number->format($q1),
		$number->format($q3),
		$number->format($min),
		$number->format($max),
		$number->format($range)
		);
	
	return $text;
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getTableAsString {
	
	my $self = shift;
	my $data = $self->checkIsArrayRef(shift);
	
	my $sd		= NaN;
	my $min 	= NaN;
	my $max 	= NaN;
	my $range 	= NaN;
	my $median 	= NaN;
	my $q1		= NaN;
	my $q3		= NaN;
	
	my $stats = Kea::Statistics::Toolkit->new;
	
	my $n 		= $stats->getN(@$data);
	my $sum 	= $stats->getSum(@$data);
	my $mean 	= $stats->getArithmeticMean(@$data);
	my $mode 	= $stats->getMode(@$data);
	
	if ($n > 2) {
		$sd			= $stats->getStandardDeviation(1, @$data);
		$min 		= $stats->getMinimum(@$data);
		$max 		= $stats->getMaximum(@$data);
		$range 		= $stats->getRange(@$data);
		$median 	= $stats->getMedian(@$data);
		$q1			= $stats->getQ1(@$data);
		$q3			= $stats->getQ3(@$data);
		}
	
	my $number = Kea::Number->new;
	
	my $text = sprintf(
		"\n\t===============================\n" . 
		"\t%-10s %20s\n" .
		"\t===============================\n" . 
		"\t%-10s %20s\n" .
		"\t%-10s %20s\n" .
		"\t%-10s %20s\n" .
		"\t%-10s %20s\n" .
		"\t%-10s %20s\n" .
		"\t%-10s %20s\n" .
		"\t%-10s %20s\n" .
		"\t%-10s %20s\n" .
		"\t%-10s %20s\n" .
		"\t%-10s %20s\n" .
		"\t%-10s %20s\n" .
		"\t===============================\n",
		"Statistic",	"Value",
		"n", 			$number->format($n),
		"sum",			$number->format($sum),
		"mean",			$number->format($number->roundup($mean, 2)),
		"sd",			$number->format($number->roundup($sd, 2)),
		"median",		$number->format($number->roundup($median, 2)),
		"mode",			$number->format($number->roundup($mode, 2)),
		"q1",			$number->format($q1),
		"q3",			$number->format($q3),
		"min",			$number->format($min),
		"max",			$number->format($max),
		"range",		$number->format($range)
		);
	
	return $text;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub show {
	print shift->getTableAsString(shift) . "\n";
	} # End of method.

sub showAsSingleLine {
	print shift->getTableAsSingleLine(shift) . "\n";		
	}

################################################################################

#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

