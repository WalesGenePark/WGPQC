#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 20/02/2008 21:03:30 
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
package Kea::Alignment::Pairwise::_DNAStatistics;
use Kea::Object;
use Kea::Alignment::Pairwise::IStatistics;
our @ISA = qw(Kea::Object Kea::Alignment::Pairwise::IStatistics);

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
	
	my $matrix = Kea::Object->check(shift);
	
	my $n = @{$matrix->[0]};
	
	my ($TT, $TC, $TA, $TG) = (0,0,0,0);
	my ($CT, $CC, $CA, $CG) = (0,0,0,0);
	my ($AT, $AC, $AA, $AG) = (0,0,0,0);
	my ($GT, $GC, $GA, $GG) = (0,0,0,0);
	
	for (my $i = 0; $i < $n; $i++) {
		
		my $basePair = uc($matrix->[0]->[$i] . $matrix->[1]->[$i]);
		
		if 		($basePair eq "TT") {$TT++;}
		elsif 	($basePair eq "TC") {$TC++;}
		elsif 	($basePair eq "TA") {$TA++;}
		elsif 	($basePair eq "TG") {$TG++;}
		
		elsif	($basePair eq "CT") {$CT++;}
		elsif 	($basePair eq "CC") {$CC++;}
		elsif 	($basePair eq "CA") {$CA++;}
		elsif 	($basePair eq "CG") {$CG++;}
		
		elsif	($basePair eq "AT") {$AT++;}
		elsif 	($basePair eq "AC") {$AC++;}
		elsif 	($basePair eq "AA") {$AA++;}
		elsif 	($basePair eq "AG") {$AG++;}
		
		elsif	($basePair eq "GT") {$GT++;}
		elsif 	($basePair eq "GC") {$GC++;}
		elsif 	($basePair eq "GA") {$GA++;}
		elsif 	($basePair eq "GG") {$GG++;}
		
		else {
			Kea::Object->throw("Unexpected base pair: $basePair.");
			}
		} 
	
	
	
	my $self = {
		
		_n	=> $n,
		
		_TT => $TT,
		_TC => $TC,
		_TA => $TA,
		_TG => $TG,
		
		_CT => $CT,
		_CC => $CC,
		_CA => $CA,
		_CG => $CG,
		
		_AT => $AT,
		_AC => $AC,
		_AA => $AA,
		_AG => $AG,
		
		_GT => $GT,
		_GC => $GC,
		_GA => $GA,
		_GG => $GG
		
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

sub n {return shift->{_n};} # End of method.

sub TT {return shift->{_TT};} # End of method.
sub TC {return shift->{_TC};} # End of method.
sub TA {return shift->{_TA};} # End of method.
sub TG {return shift->{_TG};} # End of method.

sub CT {return shift->{_CT};} # End of method.
sub CC {return shift->{_CC};} # End of method.
sub CA {return shift->{_CA};} # End of method.
sub CG {return shift->{_CG};} # End of method.

sub AT {return shift->{_AT};} # End of method.
sub AC {return shift->{_AC};} # End of method.
sub AA {return shift->{_AA};} # End of method.
sub AG {return shift->{_AG};} # End of method.

sub GT {return shift->{_GT};} # End of method.
sub GC {return shift->{_GC};} # End of method.
sub GA {return shift->{_GA};} # End of method.
sub GG {return shift->{_GG};} # End of method.

sub freqTT {my $self = shift; return $self->TT / $self->n;} # End of method.
sub freqTC {my $self = shift; return $self->TC / $self->n;} # End of method.
sub freqTA {my $self = shift; return $self->TA / $self->n;} # End of method.
sub freqTG {my $self = shift; return $self->TG / $self->n;} # End of method.

sub freqCT {my $self = shift; return $self->CT / $self->n;} # End of method.
sub freqCC {my $self = shift; return $self->CC / $self->n;} # End of method.
sub freqCA {my $self = shift; return $self->CA / $self->n;} # End of method.
sub freqCG {my $self = shift; return $self->CG / $self->n;} # End of method.

sub freqAT {my $self = shift; return $self->AT / $self->n;} # End of method.
sub freqAC {my $self = shift; return $self->AC / $self->n;} # End of method.
sub freqAA {my $self = shift; return $self->AA / $self->n;} # End of method.
sub freqAG {my $self = shift; return $self->AG / $self->n;} # End of method.

sub freqGT {my $self = shift; return $self->GT / $self->n;} # End of method.
sub freqGC {my $self = shift; return $self->GC / $self->n;} # End of method.
sub freqGA {my $self = shift; return $self->GA / $self->n;} # End of method.
sub freqGG {my $self = shift; return $self->GG / $self->n;} # End of method.


sub sumFreqTi {my $self = shift; return $self->freqTT + $self->freqCT + $self->freqAT + $self->freqGT;}
sub sumFreqCi {my $self = shift; return $self->freqTC + $self->freqCC + $self->freqAC + $self->freqGC;}
sub sumFreqAi {my $self = shift; return $self->freqTA + $self->freqCA + $self->freqAA + $self->freqGA;}
sub sumFreqGi {my $self = shift; return $self->freqTG + $self->freqCG + $self->freqAG + $self->freqGG;}

sub sumFreqTj {my $self = shift; return $self->freqTT + $self->freqTC + $self->freqTA + $self->freqTG;}
sub sumFreqCj {my $self = shift; return $self->freqCT + $self->freqCC + $self->freqCA + $self->freqCG;}
sub sumFreqAj {my $self = shift; return $self->freqAT + $self->freqAC + $self->freqAA + $self->freqAG;}
sub sumFreqGj {my $self = shift; return $self->freqGT + $self->freqGC + $self->freqGA + $self->freqGG;}

sub meanFreqT {my $self = shift; return ($self->sumFreqTi + $self->sumFreqTj) / 2;}
sub meanFreqC {my $self = shift; return ($self->sumFreqCi + $self->sumFreqCj) / 2;}
sub meanFreqA {my $self = shift; return ($self->sumFreqAi + $self->sumFreqAj) / 2;}
sub meanFreqG {my $self = shift; return ($self->sumFreqGi + $self->sumFreqGj) / 2;}

sub meanFreqY {my $self = shift; return ($self->sumFreqCi + $self->sumFreqCj + $self->sumFreqTi + $self->sumFreqTj) / 2;} # End of method.
sub meanFreqR {my $self = shift; return ($self->sumFreqAi + $self->sumFreqAj + $self->sumFreqGi + $self->sumFreqGj) / 2;} # End of method.


# Proportion of sites with transitional differences. 
sub S {my $self = shift; return ($self->freqTC + $self->freqCT + $self->freqAG + $self->freqGA);}

# Proportion of sites with transversional differences.
sub V {
	my $self = shift;
	return (
		$self->freqAT +
		$self->freqTA +
		$self->freqGT +
		$self->freqTG +
		$self->freqCG +
		$self->freqGC +
		$self->freqCA +
		$self->freqAC
		);
	} # End of method.

sub S1 {my $self = shift; return ($self->freqTC + $self->freqCT);} # End of method.
sub S2 {my $self = shift; return ($self->freqAG + $self->freqGA);} # End of method.	
	

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self = shift;
	
	my $text = sprintf(
		"Numbers and frequencies (in parentheses) of sites for the 16 site configurations in the two sequences.\n\n" . 
		"\n================================================================================\n" .
		"                                  Seq 1                                   Sum\n" .
		"-----------------------------------------------------------------------\n" .
		" Seq 2		T		C		A		G\n" .
		"--------------------------------------------------------------------------------\n" .
		"   T   %4s (%.6f)	%4s (%.6f)	%4s (%.6f)	%4s (%.6f)  %.4f\n" .
		"   C   %4s (%.6f)	%4s (%.6f)	%4s (%.6f)	%4s (%.6f)  %.4f\n" .
		"   A   %4s (%.6f)	%4s (%.6f)	%4s (%.6f)	%4s (%.6f)  %.4f\n" .
		"   G   %4s (%.6f)	%4s (%.6f)	%4s (%.6f)	%4s (%.6f)  %.4f\n" .
		"--------------------------------------------------------------------------------\n" .
		"  Sum		%.4f		%.4f		%.4f		%.4f	      %.0f\n" .
		"================================================================================\n\n" .
		"The average base frequencies in the two sequences are %.4f (T), %.4f (C), %.4f (A), and %.4f (G).",
		
		$self->TT, $self->freqTT, $self->CT, $self->freqCT, $self->AT, $self->freqAT, $self->GT, $self->freqGT, $self->sumFreqTi,
		$self->TC, $self->freqTC, $self->CC, $self->freqCC, $self->AC, $self->freqAC, $self->GC, $self->freqGC,	$self->sumFreqCi,
		$self->TA, $self->freqTA, $self->CA, $self->freqCA, $self->AA, $self->freqAA, $self->GA, $self->freqGA, $self->sumFreqAi,
		$self->TG, $self->freqTG, $self->CG, $self->freqCG, $self->AG, $self->freqAG, $self->GG, $self->freqGG,	$self->sumFreqGi,
		
		$self->sumFreqTj, $self->sumFreqCj, $self->sumFreqAj, $self->sumFreqGj,
		
		1,
		
		$self->meanFreqT, $self->meanFreqC, $self->meanFreqA, $self->meanFreqG
		
		);
	
	return $text;	
		
	}

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

