#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 11/06/2008 12:04:15
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
package Kea::IO::Pfam::_ToHandlerReader;
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
	my $handler	 	= $self->check(shift, "Kea::IO::Pfam::IReaderHandler");
	
	while (<$FILEHANDLE>) {
		
		
		# AL111168_CAL34182.1   101  319 PF00308.9      1  224   319.3   7.1e-93  Bac_DnaA 
		# AL111168_CAL34182.1   344  413 PF08299.2      1   70    69.5   1.1e-17  Bac_DnaA_C 
		if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s*$/) {
			$handler->_nextLine(
				$1, # seq id
				$2,	# seq start
				$3,	# seq end
				$4,	# hmm acc
				$5,	# hmm start
				$6,	# hmm end
				$7,	# bit score
				$8,	# e value
				$9	# hmm name
				);
			}
		#1336_ORF_1076          230  352 PF01043.11     1  128   219.8   6.2e-63  SecA_PP_bind (nested)
		elsif (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+\(nested\)\s*$/) {
			$handler->_nextLine(
				$1, # seq id
				$2,	# seq start
				$3,	# seq end
				$4,	# hmm acc
				$5,	# hmm start
				$6,	# hmm end
				$7,	# bit score
				$8,	# e value
				$9,	# hmm name,
				TRUE	# Is nested
				);
			}
		
		else {
			$self->throw("Unexpected line: $_.");
			}
		
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

