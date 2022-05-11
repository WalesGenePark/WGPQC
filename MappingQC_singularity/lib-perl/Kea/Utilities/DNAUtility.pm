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

use strict;
use warnings;

# CLASS NAME
package Kea::Utilities::DNAUtility;
use Kea::Object;
use Kea::Utilities::NucleicAcidUtility;
our @ISA = qw(Kea::Utilities::NucleicAcidUtility Kea::Object);


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

# METHODS

sub getComplement {

	my $self = shift;
	my $dna = shift;
	
	$dna =~ tr/ACGTUYRMKSWVBDHN/TGCAARYKMSWBVHDN/;
    $dna =~ tr/acgtuyrmkswvbdhn/tgcaarykmswbvhdn/;

	return $dna;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getReverseComplement {
    
	my $self = shift;
	my $dna = shift;
	
	$dna = reverse($dna);
	
	$dna =~ tr/ACGTUYRMKSWVBDHN/TGCAARYKMSWBVHDN/;
    $dna =~ tr/acgtuyrmkswvbdhn/tgcaarykmswbvhdn/;
	
	return $dna;
    
    } # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose		: Returns true (1) if sequence contains uracil and is therefore RNA.
## Returns		: 1 if true, else 0.
## Parameter 	: 'DNA' to check.
## Throws		: n/a.
sub containsUracil {
    my ($self, $dna) = @_;
    if ($dna =~ m/[uU]/g) {
        return 1;
        }
    else {
        return 0;
        }
    } # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose		: Counts the number of each base type.
## Returns 		: Array of five digits - [A, C, G, T, other].
## Parameter	: DNA to assess.
sub countCanonicalBases {
	my ($self, $dna) = @_;
	
	if (!defined $dna) {$self->throw("No sequence supplied");} 
	
	$dna =~ tr/a-z/A-Z/;

	my $aCount = 0;
	my $cCount = 0;
	my $gCount = 0;
	my $tCount = 0;
	my $otherCount = 0;

	
	# NOTE: More memory efficient way of processing each character in turn 
	# rather than split string into array and processing that.
	while ($dna =~ /(.)/g) {
		
		if 		($1 eq "A") {$aCount++;}
		elsif 	($1 eq "C") {$cCount++;}
		elsif	($1 eq "G") {$gCount++;}
		elsif	($1 eq "T") {$tCount++;}
		else 		        {$otherCount++;}
		}
	
	return ($aCount, $cCount, $gCount, $tCount, $otherCount);

	
			
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

