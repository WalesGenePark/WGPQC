#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 08/05/2008 11:24:19
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
package Kea::IO::NCBI::AGP::_FromAGPObjectCollectionWriter;
use Kea::Object;
use Kea::IO::IWriter;
our @ISA = qw(Kea::Object Kea::IO::IWriter);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;

use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant UNKNOWN	=> "unknown";
use constant NA			=> "not applicable";

use constant GAP		=> "-";

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	my $agpObjectCollection =
		Kea::Object->check(
			shift,
			"Kea::Assembly::NCBI::AGP::AGPObjectCollection"
			);
	
	my $self = {
		_agpObjectCollection => $agpObjectCollection
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

	my $self 		= shift;
	my $FILEHANDLE 		= $self->check(shift);
	my $agpObjectCollection = $self->{_agpObjectCollection};
	
	for (my $i = 0; $i < $agpObjectCollection->getSize; $i++) {
		my $agpObject = $agpObjectCollection->get($i);
		
		my $agpComponentCollection = $agpObject->getAGPComponentCollection;
		for (my $j = 0; $j < $agpComponentCollection->getSize; $j++) {
			my $agpComponent = $agpComponentCollection->get($j);
			
			if ($agpComponent->getComponentType =~ /^[NU]$/) {
				
				# scaffold00002   47449   47477   2       N       29      fragment        yes
				printf $FILEHANDLE (
				
					"%s\t%d\t%d\t%d\t%s\t%d\t%s\t%s\n",
					
					$agpObject->getId,
					$agpComponent->getLocation->getStart,
					$agpComponent->getLocation->getEnd,
					$agpComponent->getPartNumber,
					$agpComponent->getComponentType,
					$agpComponent->getGapLength,
					$agpComponent->getGapType,
					$agpComponent->getLinkage
					
					) or $self->throw("Could not print to outfile.");
				
				}
			else {
				
				my $orientation = undef;
				if 		($agpComponent->getOrientation eq SENSE) 		{$orientation = "+";}
				elsif 	($agpComponent->getOrientation eq ANTISENSE) 	{$orientation = "-";}
				elsif 	($agpComponent->getOrientation eq UNKNOWN) 		{$orientation = "0";}
				elsif 	($agpComponent->getOrientation eq NA) 			{$orientation = "na";}
				else {
					$self->throw(
						"Unsupported orientation: " .
						$agpComponent->getOrientation
						);
					} 
					
				#scaffold00001   1       152535  1       W       contig00002     1       152535  +
				printf $FILEHANDLE (
					
					"%s\t%d\t%d\t%d\t%s\t%s\t%d\t%d\t%s\n",
					
					$agpObject->getId,
					$agpComponent->getLocation->getStart,
					$agpComponent->getLocation->getEnd,
					$agpComponent->getPartNumber,
					$agpComponent->getComponentType,
					$agpComponent->getComponentId,
					$agpComponent->getComponentLocation->getStart,
					$agpComponent->getComponentLocation->getEnd,
					$orientation
					
					) or $self->throw("Could not print to outfile.");
			
				}
			
			}
		
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

