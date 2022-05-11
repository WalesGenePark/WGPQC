#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 20/07/2009 12:43:58
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
package Kea::IO::GeneMark::_ToHandlerReader;
use Kea::Object;
use Kea::IO::IReader;
our @ISA = qw(Kea::Object Kea::IO::IReader);
 
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

sub read {
	
	my $self 		= shift;
	my $FILEHANDLE 	= $self->check(shift);
	my $handler 	= $self->check(shift, "Kea::IO::GeneMark::IReaderHandler");
	
	
	while(<$FILEHANDLE>) {
		
		if (/^\s*(\d+)\s+([-+])\s+(<{0,1}\d+)\s+(>{0,1}\d+)\s+(\d+)\s+(\d+)$/) {
			my $geneNumber 	= $1;
			my $strand 		= $2;
			my $start		= $3;
			my $end			= $4;
			my $geneLength	= $5;
			my $class		= $6;
			
			$handler->_nextLine(
				$geneNumber,
				$strand,
				$start,
				$end,
				$geneLength,
				$class
				);
			
			}
		else {
			
		}
		
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

=pod
GeneMark.hmm PROKARYOTIC (Version 2.6p)
Sequence file name: TMP.fas,    RBS: Y
Model file name: TMP.mod_hmm_combined.mod
Model organism: GeneMarkS_default_gcode_11
Tue Jul 21 10:18:31 2009

Predicted genes
   Gene    Strand    LeftEnd    RightEnd       Gene     Class
    #                                         Length
    1        -          <1        1950         1950        1
    2        -        2017        3162         1146        1
    3        -        3318        5000         1683        1
    4        +        5329        6102          774        1
    5        -        6125        6604          480        1
    6        +        6879        7313          435        1
    7        +        7306        7611          306        1
    8        -        7679        8209          531        1
    9        +        8346        8711          366        1
   10        -        8781       10457         1677        1
   11        +       10625       11185          561        1
   12        +       11275       13188         1914        1
   13        +       13304       14437         1134        1
   14        +       14530       15300          771        1
   15        +       15483       16619         1137        1
   16        +       16631       17281          651        1
   17        +       17301       20522         3222        1
   18        +       20519       20995          477        1
   19        +       21006       21413          408        1
   20        -       21454       21768          315        1
   21        +       21863       22486          624        1
   22        +       22676       24604         1929        1
=cut