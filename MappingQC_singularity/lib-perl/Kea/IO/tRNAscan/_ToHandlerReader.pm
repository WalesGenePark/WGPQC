#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 15/05/2008 15:48:34
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
package Kea::IO::tRNAscan::_ToHandlerReader;
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

	my $self = shift;
	my $FILEHANDLE = $self->check(shift);
	my $handler = $self->check(shift, "Kea::IO::tRNAscan::IReaderHandler");
	
	while (<$FILEHANDLE>) {
		
		# Be strict to recognise unexpected lines later.
		if (/^Sequence\s+tRNA\s+Bounds\s+tRNA\s+Anti\s+Intron\s+Bounds\s+Cove$/) {
			next;
			}
		elsif (/^Name\s+tRNA\s+#\s+Begin\s+End\s+Type\s+Codon\s+Begin\s+End\s+Score$/) {
			next;
			}
		elsif (/^[-\s]+$/) {
			next;
			}
		
		#Enterobacter      1       231527  231603  Pro     TGG     0       0       92.73
		elsif (/^(\S+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\w{3}\(*\w*\)*)\s+(\w{3})\s+(\d+)\s+(\d+)\s+(\d+\.\d+)$/) {
			$handler->_nextLine(
				$1,		# Sequence name
				$2,		# tRNA number
				$3,		# tRNA bounds start
				$4,		# tRNA bounds end
				$5,		# tRNA type
				$6,		# Anticodon
				$7,		# Intron bounds start
				$8,		# Intron bounds end
				$9		# Cove score
				);
			}
		
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

=pod
Sequence                tRNA    Bounds  tRNA    Anti    Intron Bounds   Cove
Name            tRNA #  Begin   End     Type    Codon   Begin   End     Score
--------        ------  ----    ------  ----    -----   -----   ----    ------
Enterobacter      1       231527  231603  Pro     TGG     0       0       92.73
Enterobacter      2       239240  239315  Thr     TGT     0       0       91.83
Enterobacter      3       239324  239408  Tyr     GTA     0       0       67.63
Enterobacter      4       239526  239600  Gly     TCC     0       0       64.85
Enterobacter      5       239607  239682  Thr     GGT     0       0       88.70

=cut
