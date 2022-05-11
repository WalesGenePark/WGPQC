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
package Kea::Utilities::NucleicAcidUtility;
use Kea::Utilities::SequenceUtility;
our @ISA = qw(Kea::Utilities::SequenceUtility);

## Purpose		: Encapsulates utility methods associated with nucleotide sequence strings.

use strict;
use warnings;

use constant TRUE => 1;
use constant FALSE => 0;

################################################################################

# CLASS FIELDS

our @startCodons = qw(AUG GUG UUG);
our @stopCodons = qw(UAG UGA UAA);

################################################################################

# CONSTRUCTOR

## Purpose		: Constructor.
## Returns		: n/a.
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

# METHODS

## Purpose    	: Checks nucleotide sequence for a start codon.
## Returns    	: Returns 1 if true, else 0.
## Parameter	: Sequence to check.
## Throws     	: n/a.
sub hasStartCodon {
	my ($self, $seq) = @_;
	
	# Throw exception if not nucleic acid.
	# Todo
	
    Kea::Utilities::SequenceUtility->removeGaps($seq);
	Kea::Utilities::SequenceUtility->toUpperCase($seq);
    
	$seq =~ tr/T/U/;
    foreach my $codon (@startCodons) {
        if ($seq =~ m/^$seq/) {return TRUE;}
        }
    return FALSE;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose  	: Checks nucleotide sequence for a stop codon.
## Returns  	: Returns 1 if true, else 0.
## Parameter 	: CDS to check.
## Throws     	: n/a.
sub hasStopCodon {
    my ($self, $seq) = @_;
    Kea::Utilities::SequenceUtility->removeGaps($seq);
    Kea::Utilities::SequenceUtility->toUpperCase($seq);
    $seq =~ tr/T/U/;
    foreach my $codon (@stopCodons) {
        if ($seq =~ m/^$codon/) {return TRUE;}
        }
    return FALSE;
    } # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose		: Determines whether supplied sequence string contains non-IUB base characters.
## Returns		: Returns true (1) if non-IUB characters encountered else false (0).
## Parameter	: Sequence string to check.
## Throws		: n/a.
sub containsNonIUBCharacters {
	my ($self, $seq) = @_;
	
	$seq =~ tr/a-z/A-Z/;
	if ($seq =~ m/[^ACGTUYRMKSWVBDHN]/) {return TRUE;}
	return FALSE;
	
	} # End of method.

sub containsDegenerateCharacters {
	
	my ($self, $seq) = @_;
	
	$seq =~ tr/a-z/A_Z/;
	if ($seq =~ m/[YRMKSWVBDHN]/) {return TRUE;}
	return FALSE;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

