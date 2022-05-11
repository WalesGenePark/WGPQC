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

# CLASS NAME
package Kea::Sequence::CodonFactory;
use Kea::Object;
our @ISA = qw(Kea::Object);

use strict;
use warnings;

use constant TRUE	=> 1;
use constant FALSE	=> 0;


use Kea::Sequence::_Codon;
use Kea::Sequence::CodonCollection;

use constant STOP_OPAL => "*";
use constant STOP_OCHRE => "#";
use constant STOP_AMBER => "+";

use constant UNKNOWN => "X";
use constant SELENOCYSTEINE => "U";

################################################################################

# CLASS FIELDS

our %_aa = ( 
	GCU => "A", GCC => "A", GCA => "A", GCG => "A",								# Ala
	CGU => "R", CGC => "R", CGA => "R", CGG => "R", AGA => "R", AGG => "R",		# Arg
	AAU => "N", AAC => "N",														# Asn
	GAU => "D", GAC => "D",														# Asp
	UGU => "C", UGC => "C",														# Cys
	CAA => "Q", CAG => "Q",														# Gin
	GAA => "E", GAG => "E",														# Glu
	GGU => "G", GGC => "G", GGA => "G", GGG => "G",								# Gly
	CAU => "H", CAC => "H",														# His
	AUU => "I", AUC => "I", AUA => "I",											# Ile
	AUG => "M",																	# Met and START
	UUA => "L", UUG => "L", CUU => "L", CUC => "L", CUA => "L", CUG => "L",		# Leu
	AAA => "K", AAG => "K", 													# Lys
	UUU => "F", UUC => "F", 													# Phe
	CCU => "P", CCC => "P", CCA => "P", CCG => "P", 							# Pro
	UCU => "S", UCC => "S", UCA => "S", UCG => "S", AGU => "S", AGC => "S", 	# Ser
	ACU => "T", ACC => "T", ACA => "T", ACG => "T", ACS => "T",					# Thr
	UGG => "W", 																# Trp
	UAU => "Y", UAC => "Y", 													# Tyr
	GUU => "V", GUC => "V", GUA => "V", GUG => "V", 							# Val
	UAG => STOP_AMBER, UGA => STOP_OPAL, UAA => STOP_OCHRE						# STOP
	);


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

sub createCodon {

	my $self 	= shift;
	my $codon 	= $self->check(shift);

	$codon =~ tr/a-z/A-Z/;
	$codon =~ tr/T/U/;
	
	$self->throw("Not a codon: $codon")
		if length($codon) != 3 || $codon =~ /[^ACGURN]/;
	
	if (exists $_aa{$codon}) {
		return Kea::Sequence::_Codon->new($codon, $_aa{$codon});
		}
	else {
		$self->warn("Degenerate codon $codon to be represented by " . UNKNOWN . ".");
		return Kea::Sequence::_Codon->new($codon, UNKNOWN);
		}
	
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createCodonCollection {

	my $self 		= shift;
	my $sequence 	= $self->check(shift);
	
	$sequence =~ tr/a-z/A-Z/;
	$sequence =~ tr/T/U/;
	
	my $n = length($sequence);
	if ($n % 3 != 0) {
		$self->throw(
			"At $n bp, sequence is not a sensible length to encode protein"
			);
		}
	
	
	
	my $codonCollection = Kea::Sequence::CodonCollection->new;
	for (my $i = 0; $i < $n; $i = $i + 3) {
		# Get next codon.
		my $codonSeq = substr($sequence, $i, 3);
		
		my $aa = $_aa{$codonSeq};
		if (!defined $aa) {
			$aa = UNKNOWN;
			}
		
		
		$codonCollection->add(
			Kea::Sequence::_Codon->new(
				$codonSeq,
				$aa
				)
			);
		}
	
	return $codonCollection;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getCodonHash {
	return %_aa;
	} # end of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

