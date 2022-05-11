#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 11/06/2008 12:41:40
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
package Kea::IO::Pfam::_FromPfamResultCollectionWriter;
use Kea::Object;
use Kea::IO::IWriter;
our @ISA = qw(Kea::Object Kea::IO::IWriter);
 
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
	
	my $pfamResultCollection =
		Kea::Object->check(shift, "Kea::IO::Pfam::PfamResultCollection");
	
	my $self = {
		_pfamResultCollection => $pfamResultCollection
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

sub write {

	my $self 					= shift;
	my $FILEHANDLE 				= $self->check(shift);
	my $pfamResultCollection 	= $self->{_pfamResultCollection};
	
	#AL111168_CAL34182.1   101  319 PF00308.9      1  224   319.3   7.1e-93  Bac_DnaA 
	#AL111168_CAL34182.1   344  413 PF08299.2      1   70    69.5   1.1e-17  Bac_DnaA_C 
	#AL111168_CAL34183.1     1  119 PF00712.10     1  140    45.2   1.8e-11  DNA_pol3_beta 
	#AL111168_CAL34183.1   128  238 PF02767.7      1  125    45.6     2e-13  DNA_pol3_beta_2 
	#AL111168_CAL34183.1   240  354 PF02768.6      1  127    12.3   3.2e-05  DNA_pol3_beta_3 
	#AL111168_CAL34184.1    30  173 PF02518.17     1  127   110.0   6.8e-31  HATPase_c 
	#AL111168_CAL34184.1   219  387 PF00204.16     1  187   280.8   2.8e-81  DNA_gyraseB 
	#AL111168_CAL34184.1   414  525 PF01751.13     1  150    40.1   7.9e-09  Toprim 
	#AL111168_CAL34184.1   692  758 PF00986.12     1   69   154.1   3.8e-43  DNA_gyraseB_C 
	
	for (my $i = 0; $i < $pfamResultCollection->getSize; $i++) {
		my $pfamResult = $pfamResultCollection->get($i);
		my $text = sprintf (
			"%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s",
			$pfamResult->getQueryId,
			$pfamResult->getQueryLocation->getStart,
			$pfamResult->getQueryLocation->getEnd,
			$pfamResult->getHmmId,
			$pfamResult->getHmmLocation->getStart,
			$pfamResult->getHmmLocation->getEnd,
			$pfamResult->getBitScore,
			$pfamResult->getEValue,
			$pfamResult->getHmmName
			);
			
		if ($pfamResult->isNested) {
			$text .= " (nested)";
			}
		
		print $FILEHANDLE $text . "\n" or
			$self->throw("Could not write to outfile: $!");
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

