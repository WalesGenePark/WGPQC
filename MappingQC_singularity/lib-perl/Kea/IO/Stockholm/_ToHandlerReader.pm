#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 11/06/2008 17:52:23
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
package Kea::IO::Stockholm::_ToHandlerReader;
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
	my $handler = $self->check(shift, "Kea::IO::Stockholm::IReaderHandler");
	
	if (<$FILEHANDLE> !~ /^# STOCKHOLM 1.0$/) {
		$self->throw("Not valid Stockholm format: missing first line.");
		}
	
	while (<$FILEHANDLE>) {
		
		#=GF ID   14-3-3
		if (/^#=GF ID   (.+)\s*$/) {
			$handler->_nextId($1);
			}
		
		#=GF AC   PF00244.11
		elsif (/^#=GF AC   (.+)\s*$/) {
			$handler->_nextAccession($1);
			}
			
		#=GF DE   14-3-3 protein
		elsif (/^#=GF DE   (.+)\s*$/) {
			$handler->_nextDescription($1);
			}
		
		
		#=GF AU   Finn RD
		#=GF SE   Prosite
		#=GF GA   25.00 25.00; 25.00 25.00;
		#=GF TC   29.40 29.40; 30.60 30.00;
		#=GF NC   24.30 24.30; 21.00 21.00;
		#=GF TP   Domain
		#=GF BM   hmmbuild -F HMM_ls SEED
		#=GF BM   hmmcalibrate --seed 0 HMM_ls
		#=GF BM   hmmbuild -f -F HMM_fs SEED
		#=GF BM   hmmcalibrate --seed 0 HMM_fs
		
		elsif (/^\/\/$/) {
			$handler->_nextEndOfRecord;
			}
		
		
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

