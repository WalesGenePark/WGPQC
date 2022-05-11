#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 22/10/2008 15:51:50
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
package Kea::IO::SOLiD::Snps::_ToHandlerReader;
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
	my $handler 	= $self->check(shift, "Kea::IO::SOLiD::Snps::IReaderHandler");
	
	while (<$FILEHANDLE>) {
		
		#  $1     $2      $3       $4       $5    $6/$7   $8/$9    $10     $11    $12/$13 $14/$15  $16
		# # cov   ref     consen  score   confi   F3      R3      score   conf    F3      R3      coord
		# 221     A       G       0.0000  0.0000  0/0     -/-     0.9877  0.8810  218/67  -/-     4211786
		# 525     T       A       0.2344  0.8722  124/50  -/-     0.7450  0.8814  390/65  -/-     11784243
		# 335     T       G       0.0000  0.0000  0/0     -/-     0.9229  0.7987  307/65  -/-     12491281
		# 249     T       G       0.0925  0.8904  23/17   -/-     0.9075  0.8894  226/65  -/-     8450776
		# 209     T       A       0.0000  0.0000  0/0     -/-     0.9779  0.9136  204/65  -/-     11785892
       
		if (
		#       $1     $2     $3       $4          $5         $6       $7          $8        $9         $10          $11       $12       $13          $14       $15      $16
			/^(\d+)\s+(\w)\s+(\w)\s+([\d\.]+)\s+([\d\.]+)\s+([-\d]+)\/([-\d]+)\s+([-\d]+)\/([-\d]+)\s+([\d\.]+)\s+([\d\.]+)\s+([-\d]+)\/([-\d]+)\s+([-\d]+)\/([-\d]+)\s+(\d+)\s*$/
			) {
			$handler->_nextLine(
				$1,		# coverage
				$2,		# ref allele
				$3,		# consensus allele
				$4,		# ref allele score
				$5,		# ref allele confidence value.
				$6,		# F3 total number of reads with ref allele 
				$7,		# F3 number of unique reads with ref allele
				$8,		# R3 total number of reads with ref allele.
				$9,		# R3 number of unique reads with ref allele.
				$10,	# consensus allele score
				$11,	# consensus allele confidence value.
				$12,	# F3 total number of reads with consensus allele.
				$13,	# F3 number of unique reads with consensus allele.
				$14,	# R3 total number of reads with consensus allele.
				$15,	# R3 number of unique reads with consensus allele.
				$16		# snp coordinate within reference.
				);
			}
		
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

