#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 25/07/2008
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

# CLASS NAME
package Kea::IO::Paml::PairwiseCodemlResult::_ToHandlerReader;
use Kea::Object;
use Kea::IO::IReader;
our @ISA = qw(Kea::Object Kea::IO::IReader); 

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

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

################################################################################

# PUBLIC METHODS

sub read {

	my $self 		= shift;
	my $FILEHANDLE 	= $self->check(shift);
	
	my $handler =
		$self->check(shift, "Kea::IO::Paml::PairwiseCodemlResult::IReaderHandler"); 
			
	while (<$FILEHANDLE>) {
		
		#lnL =-2304.472130
		if (/^\s*lnL\s*=\s*(\-\d+\.\d+)$/) {
			$handler->_logLikelihood($1);
			}
		
		#  0.39021  2.85558  0.07391
		elsif (/^\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s*$/) {
			$handler->_kappa($2);
			}
		
		#t= 0.3902  S=   307.4  N=  1108.6  dN/dS= 0.0739  dN= 0.0350  dS= 0.4731
		elsif (/^t=\s*(\d+\.\d+)\s*S=\s*(\d+\.\d+)\s*N=\s*(\d+\.\d+)\s*dN\/dS=\s*(\d+\.\d+)\s*dN=\s*(\d+\.\d+)\s*dS=\s*(\d+\.\d+)\s*$/) {
			$handler->_t($1);
			$handler->_S($2);
			$handler->_N($3);
			$handler->_omega($4);
			$handler->_dN($5);
			$handler->_dS($6);
			}
		
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

