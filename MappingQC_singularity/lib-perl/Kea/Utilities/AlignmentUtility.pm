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
package Kea::Utilities::AlignmentUtility;
use Kea::Object;
our @ISA = "Kea::Object";

## Purpose		: Provides utility methods for alignments.

use strict;
use warnings;

use constant TRUE => 1;
use constant FALSE => 0;

#use Kea::Parsers::Fasta::Parser;
use Kea::Utilities::CDSUtility;

################################################################################

# CLASS FIELDS

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

# PRIVATE METHODS


################################################################################

# METHODS

=pod
## Purpose		: Generates a DNA alignment from a set of dna sequences, using a supplied protein alignment as a guide.
## Returns		: n/a
## Parameter	: -proteinAlignmentFilehandle = Filehandle reference for protein alignment.
## Parameter	: -proteinAlignmentFormat = Format of protein alignment file.
## Parameter	: -dnaFilehandle = Filehandle reference for dna sequences to be aligned.
##ÊParameter	: -dnaFormat = Format of DNA sequence file.
## Parameter	: -dnaAlignmentFilehandle = Filehandle reference for eventual dna alignment.
## Parameter	: -dnaFormat = Format of eventual DNA sequence file.
## Throws		: n/a.
sub generateDNAAlignment {
	my ($self, %args) = @_;
	
	my $proteinAlignmentFilehandle = $args{-proteinAlignmentFilehandle} or die "ERROR: No protein alignment filehandle provided.  Use -proteinAlignmentFilehandle flag. ";
	my $proteinAlignmentFormat = $args{-proteinAlignmentFormat} or die "ERROR: No protein alignment Format provided.  Use -proteinAlignmentFormat flag.";
	my $dnaFilehandle = $args{-dnaFilehandle} or die "ERROR: No dna filehandle provided.  Use -dnaFilehandle flag.";
	my $dnaFormat = $args{-dnaFormat} or die "ERROR: No dna Format provided.  Use -dnaFormat flag.";
	my $dnaAlignmentFilehandle = $args{-dnaAlignmentFilehandle} or die "ERROR: No dna alignment filehandle provided.  Use -dnaAlignmentFilehandle flag.";
	my $dnaAlignmentFormat = $args{-dnaAlignmentFormat} or die "ERROR: no dna alignment Format provided.  Use -dnaAlignmentFormat flag.";
	
	# For now ALL files to be in fasta format!
	
	# Generate hash maps of sequence data.
	my @codes;
	my %proteinAlignment;
	my %dnaSequences;
	my %dnaAlignment;
	
	if ($proteinAlignmentFormat =~ m/^fasta$/i) {
		eval{
			my $parser = Kea::Parsers::Fasta::Parser->new($proteinAlignmentFilehandle);
			%proteinAlignment = $parser->getSequencesAsHash;
			@codes = $parser->getCodes;
			};
		die "ERROR: Parsing failed.  Message: $@.  " if $@;
		
		}
	else {
		die "ERROR: Sorry, method doesn't support '$proteinAlignmentFormat' format for protein alignments.";
		}
	
	if ($dnaFormat =~ m/^fasta$/i) {
		my $parser = Kea::Parsers::Fasta::Parser->new($dnaFilehandle);
		%dnaSequences = $parser->getSequencesAsHash;
		}
	else {
		die "ERROR: Sorry, method does not suport '$dnaFormat' format for dna sequences.";	
		}

	
	# map unaligned dna sequence data to aligned protein data.
	foreach my $code (keys %proteinAlignment) {
		
		my $alignedDNASequence;
		if (exists($dnaSequences{$code})) {
			$alignedDNASequence =
				createDNAAlignmentString(
					-alignedProteinString => $proteinAlignment{$code},
					-dnaString => $dnaSequences{$code}
					);	
			$dnaAlignment{$code} = $alignedDNASequence;
			}
		else {
			die "ERROR: $code not found in supplied DNA sequence file.";
			}
		
		} # End of foreach loop - no more sequences to process.
	
	# Write aligned dna hash to outfile. NOTE: Retain order as for protein alignment.
	if ($dnaAlignmentFormat =~ m/^fasta$/i) {
		foreach my $code (@codes) {
			print $dnaAlignmentFilehandle ">$code\n";
			print $dnaAlignmentFilehandle "$dnaAlignment{$code}\n\n";
			}
		}
	else {
		die "ERROR: Sorry,method does not support '$dnaAlignmentFormat' format for dna alignments.";	
		}
	
	
	
	} # End of method.
=cut
	
#///////////////////////////////////////////////////////////////////////////////

sub createDNAAlignmentString  {
	
	my ($self, %args) = @_;
	
	my $alignedProtein 	= $self->check($args{-alignedProteinString});
	my $dna 			= $self->check($args{-dnaString});
	
	my $utility = Kea::Utilities::CDSUtility->new;
	
	# Convert dna string to codon array.
	my @initialCodons = $utility->convertToCodonArray($dna);
	
	my $alignedDNA;
	my @finalCodons;
	
	# Work through aligned protein string and process each character.
	my @aaArray = split(//, $alignedProtein);
	
	foreach my $aa (@aaArray) {
		if ($aa eq "-") {push(@finalCodons, "---");}
		else {
			# Get codon from $dna.
			my $codon = shift(@initialCodons);
			
			# Get aa (just to check).
			my $aa2 = $utility->getAminoAcid($codon);
			
			if ($aa ne $aa) {
				warn "WARNING: codon '$codon' encountered coding for '$aa2' not '$aa' as expected.";
				}
			# Regardless of outcome add codon to array anyway.
			push(@finalCodons, $codon);
			
			}
		}
	
	
	
	return join("", @finalCodons);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

