#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 
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

#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////

# CLASS NAME
package Kea::IO::Orthomcl::_ToHandlerReader;
use Kea::Object;
use Kea::IO::IReader;
our @ISA = qw(Kea::Object Kea::IO::IReader);

## Purpose		: 

use strict;
use warnings;
use Carp;
use Kea::Arg;

use constant TRUE => 1;
use constant FALSE => 0;


################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

## Purpose		: Constructor.
## Parameter	: n/a.
## Throws		: n/a.
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

## Purpose		: ?????????????.
## Returns		: n/a.
## Parameter	: n/a.
## Throws		: n/a.
sub read {

	my $self = shift;
	my $FILEHANDLE = shift;
	my $handler = Kea::Arg->check(shift, "Kea::IO::Orthomcl::IReaderHandler");
	
	while (<$FILEHANDLE>) {
		
		#ORTHOMCL1(2 genes,1 taxa):       orf00112(c414_campylobacter_all_contigs) orf00113(c414_campylobacter_all_contigs)
		if (/^ORTHOMCL(\d+)\((\d+) genes,(\d+) taxa\):\s+(.+)$/) {
			
			my $clusterNumber = $1;
			my $clusterSize = $2;
			my $taxaInCluster = $3;
			my $data = $4;
			
			my @proteinIds;
			my @primaryAccessions;
			# Store protein ids according to genome id.
			# Key = genome id, value = array of protein ids.
			my %proteinIdHash; 
			
			my @proteinInfo = split(" ", $data);
			foreach my $info (@proteinInfo) {
				if ($info =~ m/(.+)\((.+)\)/) {#==========================================================================
					
					# Add current protein code to protein array.
					push(@proteinIds, $1);
					
					# Add current genome code to genome array provided not already in array.
					if (!idExists($2, \@primaryAccessions)) {
						push(@primaryAccessions, $2);
						}
					
					# Store protein id against genome id within hash.
					if (exists $proteinIdHash{$2}) {
						push(@{$proteinIdHash{$2}}, $1);
						}
					else {
						$proteinIdHash{$2} = [$1];
						}
					
					} #===================================================================================================
				}
			
			$handler->nextLine(
				$clusterNumber,
				$clusterSize,
				$taxaInCluster,
				\@proteinIds,
				\@primaryAccessions,
				\%proteinIdHash
				);
			
			} # End of if block - line processed.
		
		
		} # End of while block - no more ORTHOMCL lines remaining.
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub idExists {
	my ($id, $array) = @_;
	
	foreach my $item (@$array) {
		return TRUE if $item eq $id;	
		}
	
	return FALSE;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

