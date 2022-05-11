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
package Kea::Utilities::CDSUtility;
use Kea::Object;
use Kea::Utilities::DNAUtility; 
our @ISA = qw(Kea::Object Kea::Utilities::DNAUtility);

use strict;
use warnings;

use constant TRUE 					=> 1;
use constant FALSE 					=> 0;
#use constant STOP 					=> "*";
use constant UNKNOWN 				=> "X";
use constant SELENOCYSTEINE 		=> "U";
use constant PYRROLYSINE 			=> "O";

use constant IGNORE_STOP_DEFAULT 	=> TRUE;
use constant STRICT_DEFAULT 		=> FALSE;
use constant IS_BACTERIAL_DEFAULT 	=> TRUE;

use Kea::Sequence::CodonFactory;
use Kea::Properties;

################################################################################

# CLASS FIELDS

our $startCodonRegex = "(AUG|GUG|UUG|CUG|AUU|AUC|AUA)";
our $stopCodonRegex = "(UAG|UGA|UAA)";

our $OUT = *STDERR;

################################################################################

# CONSTRUCTOR

sub new {
	my $className = shift;
	my %args = @_;
	
	if (!exists $args{-showInformationMessages}) {$args{-showInformationMessages} = TRUE;}
	if (!exists $args{-showWarningMessages}) {$args{-showWarningMessages} = TRUE;}
	if (!exists $args{-showErrorMessages}) {$args{-showErrorMessages} = TRUE;}
	if (!exists $args{-informationMessagesToLog}) {$args{-informationMessagesToLog} = FALSE;}
	
	my %aa = Kea::Sequence::CodonFactory->getCodonHash;
	
	my $self = {
		_showInformationMessages => $args{-showInformationMessages},
		_showWarningMessages => $args{-showWarningMessages},
		_showErrorMessages => $args{-showErrorMessages},
		_aaHash => \%aa
		};
	
	if ($args{-informationMessagesToLog} == TRUE) {
		
		open(OUT, ">information.log") or die "Could not create information.log\n";
		$OUT = *OUT;
		
		}
	
	bless(
		$self,
		$className
		);
	return $self;
	} # End of constructor.

################################################################################

# METHODS

## Purpose    : Checks that sequence is a multiple of three.
## Returns    : Returns 1 if true, else 0.
## Parameter : CDS to check.
## Throws     : n/a.
sub hasSensibleLength {
    my ($self, $cds) = @_;
    $self->removeGaps($cds);
    if (length($cds)%3 == 0) {return TRUE;}
    return FALSE;
    } # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAminoAcid {

	my $self 	= shift;
	my $codon 	= $self->check(shift);
	
	# Ensure RNA and uppercase.
	$codon =~ tr/a-z/A-Z/;
	$codon =~ tr/T/U/;
	
	my %aa = %{$self->{_aaHash}};
	
	if (exists($aa{$codon})) {
		return $aa{$codon};
		}
	
	elsif ($codon =~ /^[ACGUMRWSYKBDHVN]{3}$/) {
		$self->warn(
			"Degenerate codon '$codon' - will be represented by '" .
			UNKNOWN . "'."
			);
		return UNKNOWN;
		}
	
	else {
		$self->throw("No match for codon '$codon'.");
		} 
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose		: Converts DNA string to array of codons.
##ÊReturns		: String array.
## Parameter	: CDS string to convert.
## Throws		: Dies if cds is not a multiple of three.
sub convertToCodonArray {

	my $self 	= shift;
	my $cds		= $self->check(shift);
	
	if (!$self->hasSensibleLength($cds)) {
		$self->throw(
			"Supplied string is not a sensible length for coding " .
			"sequence. Length " . length($cds) . " is not a multiple of three!"
			);
		}
	
	my @codons;
	for (my $i = 0; $i < length($cds); $i = $i + 3) {
		push(@codons, substr($cds, $i, 3));
		}
	
	return @codons;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose      : Checks that sequence has typical characteristics of a coding sequence.
## Returns      : Returns 1 if true, else 0.
## Parameter   : CDS to check.
## Throws       : n/a.
sub isLikelyCDS {
    
	my $self = shift;
	my $cds = $self->check(shift);
    
	if (!$self->hasSensibleLength($cds)) {return FALSE;}
    if (!$self->hasStartCodon($cds)) {return FALSE;}
    if (!$self->hasStopCodon($cds)) {return FALSE;}
    
	return TRUE;
    
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose		: Checks that supplied dna string codes for supplied protein string.
##ÊReturns		: Returns true (1) if translation is identical to protein, else false (0).
## Parameter	: -cdsSequence = CDS string to check.
## Parameter	: -proteinSequence = Protein string to compare with.
## Parameter	: -ignoreStopCodon = True (1) if stop codon is to be ignored, else false (0).
## Parameter	: -strict = True (1) to apply rule that all cds sequences have a start and stop codon else false (0).
## Parameter	: -isBacterial = True (1) if sequence is bacterial (hence alternative start codons), else false (0).
## Parameter	: -code = Id code for translation.
## Throws		: n/a.
sub checkCDSCodesToProtein {
	my (
		$self,
		%args
		) = @_;
	
	my $cds = 			exists $args{-cdsSequence} 		? $args{-cdsSequence} 		: die "Value required for -cdsSequence";
	my $protein = 		exists $args{-proteinSequence}	? $args{-proteinSequence}	: die "Value required for -proteinSequence";
	my $ignoreStop = 	exists $args{-ignoreStopCodon}	? $args{-ignoreStopCodon} 	: IGNORE_STOP_DEFAULT;
	my $strict = 		exists $args{-strict} 			? $args{-strict}			: STRICT_DEFAULT;
	my $isBacterial = 	exists $args{-isBacterial}		? $args{-isBacterial}		: IS_BACTERIAL_DEFAULT;
	my $id = 			exists $args{-code}				? $args{-code}				: "";
	
	
	# Convert both sequences to uppercase and remove gaps.
	$cds = $self->toUpperCase($cds);
	$cds = $self->removeGaps($cds);
	$protein = $self->toUpperCase($protein);
	$protein = $self->removeGaps($protein);
	
	# Translate cds.
	my $translation = $self->translate(
		-sequence => $cds,
		-ignoreStopCodon => $ignoreStop, # Ignore stop codon.
		-strict => $strict,  # Apply strict rules.
		-isBacterial => $isBacterial,
		-code => $id
		);
	
	if ($translation eq $protein) {return TRUE;} else {return FALSE;}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose		: Convenience method. Simpler to use than translate().
sub getTranslation {
	
	my $self 		= shift;
	my $sequence 	= $self->check(shift);
	
	if (!$self->isa("Kea::Utilities::CDSUtility")) {
		$self->throw("Method is an instance method only.");
		}
	
	return $self->translate(
		-sequence => $sequence,
		-ignoreStopCodon => TRUE,
		-strict => FALSE,
		-isBacterial => TRUE,
		-code => "Unknown"
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose		: Translates supplied CDS sequence to protein sequence.
## Returns		: Translation as string.
## Parameter	: -sequence = CDS string to convert.
## Parameter	: -ignoreStopCodon = True (1) if stop codon is to be ignored, else false (0).
## Parameter	: -strict = True (1) to apply rule that all cds sequences have a start and stop codon else false (0).
## Parameter	: -isBacterial = True (1) if sequence is bacterial (hence alternative start codons), else false (0).
## Parameter	: -code = Id code for translation.
## Throws		: Dies if stop codon found within translation IF strict is true.
## Throws		: Dies if sequence not of sensible length.
##ÊThrows		: Dies if non-IUB characters encountered.
sub translate {
	my (
		$self,
		%args
		) = @_;
	
	my $seq = 			exists $args{-sequence} 		? $args{-sequence} 		: die "Value required for -sequence";
	my $ignoreStop = 	exists $args{-ignoreStopCodon}	? $args{-ignoreStopCodon} 	: IGNORE_STOP_DEFAULT;
	my $strict = 		exists $args{-strict} 			? $args{-strict}			: STRICT_DEFAULT;
	my $isBacterial = 	exists $args{-isBacterial}		? $args{-isBacterial}		: IS_BACTERIAL_DEFAULT;
	my $id = 			exists $args{-code}				? $args{-code}				: "";
	
	my %aa = %{$self->{_aaHash}};
	
	# Add space to improve look of output.
	if ($id) {$id = " " . $id;}
	
	# Remove gaps.
	$seq = $self->removeGaps($seq);
	
    # Throw exception if not sensible length.
	if ($self->hasSensibleLength($seq) == FALSE) {
	
		$self->throw(
			"Sequence length (" . length($seq) .
			") is not a multiple of three and " .
			"cannot be a cds!"
			);
		}
	
	# Throw exception if non-IUB character encountered.
	if ($self->containsNonIUBCharacters($seq)) {
	
		print "\n[$seq]\n";
	
		$self->throw(
			"Supplied sequence contains non_IUB characters and " .
			"cannot be translated."
			);
		}
    
	# Convert to uppercase
	$seq = $self->toUpperCase($seq);
	
	# Ensure RNA
	$seq =~ tr/T/U/;
	
	# If no recognised start codon.
	if ($seq !~ m/^$startCodonRegex/) {
		if ($strict) {
			$self->throw("CDS$id has no recognised start codon");
			}
		elsif ($self->{_showWarningMessages}) {
			$self->warn("CDS$id has no recognised start codon.");
			}
		}
	
	# If no recognised stop codon.
	if ($seq !~ m/$stopCodonRegex$/) {
		if ($strict) {
			$self->throw("CDS$id has no recognised stop codon");
			}
		elsif ($self->{_showWarningMessages}) {
			$self->warn("CDS$id has no recognised stop codon.");
			}
		}
	
	# Translate.
	my $translation = "";
	my $codon;
	for (my $i = 0; $i < length($seq); $i = $i + 3) {
	
		# Get next codon.
		$codon = substr($seq, $i, 3);
		
		# Accommodate alternative bacterial start codons.
		if ($isBacterial && $i == 0 && $codon =~ m/$startCodonRegex/) {
			if ($codon ne "AUG" && $self->{_showInformationMessages}) {
				$self->message(
					"Non-standard start codon, $codon, detected at start of " .
					"CDS$id and will be interpreted as Methionine."
					);
				}
			$translation = $aa{"AUG"}; # Always add Met.
			}
		
		# inframe stop codon.
		elsif ($codon =~ m/$stopCodonRegex/ && ($i != length($seq)-3)) {
			
			# Special case - inframe UGA could be selenocysteine.
			if ($codon eq "UGA") {
				if ($self->{_showInformationMessages}) {
					$self->message(
						"Stop codon UGA found within CDS$id.  " .
						"Guessing this to be selenocysteine (U)."
						);
					}
				$translation = $translation . SELENOCYSTEINE;
				}
			
			# Special case - inframe TAG could be pyrrolysine.
			elsif ($codon eq "UAG") {
				if ($self->{_showInformationMessages}) {
					$self->message(
						"Stop codon UAG found within CDS$id.  " .
						"Guessing this to be pyrrolysine (O)."
						);
					}
				$translation = $translation . PYRROLYSINE;
				}
			# Otherwise - dodgy!
			else {
				if ($strict) {
				
					$self->throw(
						"Translation$id includes stop codon WITHIN sequence"
						);
					}
				else {
					if ($self->{_showWarningMessages}) {
						$self->warn(
							"Translation$id includes stop codon $codon " .
							"WITHIN sequence!"
							);
						}	
					$translation = $translation . $aa{$codon}; # ADD STOP CODON.
					}
				}
			
			}
		
		# Standard codon coding.
		else {
			if (!defined $aa{$codon}) {
				
				if (Kea::Properties->getProperty("warnings") ne "off") {
					$self->warn(
						"Codon unaccounted for: $codon. " .
						"Will be represented by 'X'."
						);
					}
			
				
				$translation = $translation . UNKNOWN;
				}
			else {
				$translation = $translation . $aa{$codon};
				}
			
			}
		}
	
	# Remove stop codon character (* or + or #) from END of translation.
	if ($ignoreStop) {
		$translation =~ s/[\*\+\#]$//;
		}
	
	
	# Return translation.
	return $translation;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

