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

## Purpose	: Parses GenBank files storing genomic sequence data (i.e., single file devoted to single genome).
package Kea::Parsers::GenBankGenomeFileParser;

use constant TRUE => 1;
use constant FALSE => 0;

use strict;
use warnings;

use Kea::Utilities::DNAUtility;
use Kea::GenBank::Feature::CDS;

## Purpose    : Parses GENOME GenBank files.
################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

## Purpose    : Constructor.
## Returns    : n/a.
## Parameters : n/a.
## Throws     : n/a.
sub new {
	my $className = shift;
	my $self = {
       
        };
	bless(
		$self,
		$className
		);
    
	return $self;
	} # End of constructor.

################################################################################

# METHODS

## Purpose    : Parse file represented by supplied FILEHANDLE.
## Returns    : n/a.
## Parameters : Reference to FILEHANDLE for GenBank infile.
## Throws     : n/a.
sub parse {
    my $self = shift;
    my $filehandle = shift;
    
    my $line;
	my $locusName;
	my $sequenceLength;
	my $moleculeType;
	my $genBankDivision;
	my $modificationDate;
	my $definition;
	my $accession;
	my @geneNames;
	my @geneProducts;
    my @positions;
    my @protein_ids;
	my @locusTags;
    my @GIs;
    my @translations;
    my $translation;
    my $DNA;
    my $readingTranslation = FALSE;
    my $readingDNA = FALSE;

	# Initialise object for processing CDS features.
	my $cdsObj = Kea::GenBank::Feature::CDS->new;
	
    while(<$filehandle>) {
	
        $line = $_;
		
		# Process LOCUS line
		# e.g.
		# LOCUS       CP000025             1777831 bp    DNA     circular BCT 11-JAN-2005
		if ($line =~ m/^LOCUS\s+(\w+\d+)\s+(\d+)\s+bp\s+(\w+)\s+(\w+\s*\w+)\s+(\d\d-\w\w\w-\d\d\d\d)\s*$/) {
			$locusName = $1;
			$sequenceLength = $2;
			$moleculeType = $3;
			$genBankDivision = $4;
			$modificationDate = $5;
			}
		
		# Store DESCRIPTION.
		# e.g.
		#DEFINITION  Campylobacter jejuni RM1221, complete genome.
		if ($line =~ m/^DEFINITION\s+(.+)$/) {
			$definition = $1;
			}
		
		# Store accession number.
		# e.g.
		#ACCESSION   CP000025
		if ($line =~ m/^ACCESSION\s+(\w+).*$/) {
			$accession = $1;
			}
		
		# Process each cds separately.
		if ($line =~ m/^\s+CDS/) {
			push(my @buffer, $line);
			while ($line = <$filehandle>) {
				if ($line =~ m/^\s+gene/ || $line =~ m/^ORIGIN/) {
					last;
					}
				else {push(@buffer, $line);}
				}
			# process cds.
			$cdsObj->process(@buffer);
			# Extract data.
			push(@positions, $cdsObj->getCDSPosition());
			push(@geneNames, $cdsObj->getGeneName());
			push(@geneProducts, $cdsObj->getProductDescription());
			push(@protein_ids, $cdsObj->getProteinId());
			push(@GIs, $cdsObj->getProteinGI());
			push(@translations, $cdsObj->getTranslation());
			push(@locusTags, $cdsObj->getLocusTag());
			}
		
		# Finally store dna sequence.
		# e.g.
		#        1 atgaatccaa gccaaatact tgaaaattta aaaaaagaat taagtgaaaa cgaatacgaa
		if ($line =~ m/^\s+1\s(\w{10})\s(\w{10})\s(\w{10})\s(\w{10})\s(\w{10})\s(\w{10})\s*$/) {
			$DNA = $1 . $2 . $3 . $4 . $5 . $6;
			}
		elsif ($DNA && $line =~ m/^\s*\d+\s(.*)\s*$/) {
			my $tmp = $1;
			$tmp =~ s/\s//g;
			$DNA = $DNA . $tmp;
			}
        
        } # End of while - no lines remaining in file.
	
    $self->{_cdsPositions} = \@positions;
    $self->{_proteinIDs} = \@protein_ids;
    $self->{_proteinGIs} = \@GIs;
    $self->{_translations} = \@translations;
    $self->{_dna} = $DNA;
	
	$self->{_locusName} = $locusName or die "Parsing failed: no locus name found in supplied GenBank file.  Is your file correctly formatted?\n";
	$self->{_sequenceLength} = $sequenceLength or die "Parsing failed: no sequence length found in supplied GenBank file.  Is your file correctly formatted?\n";
	$self->{_moleculeType} = $moleculeType or die "Parsing failed: no molecule type found in supplied GenBank file.  Is your file correctly formatted?\n";
	$self->{_genBankDivision} = $genBankDivision or die "Parsing failed: no GenBank division found in supplied GenBank file.  Is your file correctly formatted?\n";
	$self->{_modificationDate} = $modificationDate or die "Parsing failed: no modification date found in supplied GenBank file.  Is your file correctly formatted?\n";
	
	$self->{_definition} = $definition;
	$self->{_accession} = $accession;
	$self->{_geneNames} = \@geneNames;
	$self->{_geneProducts} = \@geneProducts;
	$self->{_locusTags} = \@locusTags;

    } # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose    : Returns LOCUS name.  
## Returns    : LOCUS name as string.
## Parameters : n/a.
## Throws     : n/a.
sub getLocusName {return shift->{_locusName};} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose    : Returns sequence length as recorded in LOCUS.  
## Returns    : Sequence size (bp).
## Parameters : n/a.
## Throws     : n/a.
sub getSequenceLength {return shift->{_sequenceLength};} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose    : Returns molecule type as recorded in LOCUS.  
## Returns    : String.
## Parameters : n/a.
## Throws     : n/a.
sub getMoleculeType {return shift->{_moleculeType};} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose    : Returns GenBank division as recorded in LOCUS.  
## Returns    : String.
## Parameters : n/a.
## Throws     : n/a.
sub getGenBankDivision {return shift->{_genBankDivision};} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose    : Returns modification date as recorded in LOCUS.  
## Returns    : String.
## Parameters : n/a.
## Throws     : n/a.
sub getModificationDate {return shift->{_modificationDate};} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose    : Returns DEFINITION.  
## Returns    : String.
## Parameters : n/a.
## Throws     : n/a.
sub getDefinition {return shift->{_definition};} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose    : Returns accession number.  
## Returns    : String.
## Parameters : n/a.
## Throws     : n/a.
sub getAccession {return shift->{_accession};} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose    : Returns array of gene names as recorded in gene feature.  
## Returns    : Array of strings.
## Parameters : n/a.
## Throws     : n/a.
sub getGeneNames {
	my $array = shift->{_geneNames};
	return @$array;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose    : Returns array of locus_tag strings as recorded in gene feature.  
## Returns    : Array of strings.
## Parameters : n/a.
## Throws     : n/a.
sub getLocusTags {
	my $array = shift->{_locusTags};
	return @$array;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose    : Returns array of gene product descriptions as recorded in CDS feature.  
## Returns    : Array of strings.
## Parameters : n/a.
## Throws     : n/a.
sub getGeneProducts {
	my $array = shift->{_geneProducts};
	return @$array;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose    : Returns array of CDS positions.  
## Returns    : Array of position info strings (as represented in file).
## Parameters : n/a.
## Throws     : n/a.
sub getCDSPositions {
	my $self = shift;
    my $arrayRef = $self->{_cdsPositions};
    return @$arrayRef;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose    : Returns array of protein IDs.  
## Returns    : Array of protein-id strings.
## Parameters : n/a.
## Throws     : n/a.
sub getProteinIDs {
	my $self = shift;
    my $arrayRef = $self->{_proteinIDs};
    return @$arrayRef;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose    : Returns array of protein GIs.  
## Returns    : Array of protein-gi strings.
## Parameters : n/a.
## Throws     : n/a.
sub getProteinGIs {
	my $self = shift;
    my $arrayRef = $self->{_proteinGIs};
    return @$arrayRef;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose    : Returns array of translations.  
## Returns    : Array of protein strings.
## Parameters : n/a.
## Throws     : n/a.
sub getTranslations {
	my $self = shift;
    my $arrayRef = $self->{_translations};
    return @$arrayRef; 
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose    : Returns array of cds sequences in SENSE orientation.  
## Returns    : Array of cds strings.
## Parameters : n/a.
## Throws     : n/a.
sub getCDSSequencesInSenseOrientation {
	my $self = shift;
    
    my @positions = $self->getCDSPositions();
    
    my $dna = $self->{_dna};
    my @dnaSequences;
    
    for (my $i = 0; $i < scalar(@positions); $i++) {
		
		my $position_text = $positions[$i];
		
		if ($position_text =~ m/^(\d+)\.\.(\d+)$/) {
			my $sequence = substr($dna, $1-1, $2-$1+1);
			push(@dnaSequences, $sequence);
			}
		
		elsif($position_text =~ m/^complement\((\d+)\.\.(\d+)\)/) {
			my $sequence = substr($dna, $1-1, $2-$1+1);
			
			# REVERSE COMPLEMENT REQUIRED!!!!
			my $reverseComplement = Kea::Utilities::DNAUtility->getReverseComplement($sequence);			
            push(@dnaSequences, $reverseComplement);
            
			}
		# e.g.
		# join(46424..49000,49002..50156)
		elsif ($position_text =~ m/^join\((\d+)\.\.(\d+),(\d+)\.\.(\d+)\)/) {
			my $sequence = substr($dna, $1-1, $2-$1+1);
			$sequence = $sequence . substr($dna, $3-1, $4-$3+1);
			push(@dnaSequences, $sequence);
			}
		
		else {
			die "ERROR: Haven't accounted for position format: '$position_text'";
			}
		
		}
    
    return @dnaSequences;
    
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose    : Returns DNA sequence.  
## Returns    : DNA as string.
## Parameters : n/a.
## Throws     : n/a.
sub getDNA {
	my $self = shift;
    return $self->{_dna};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;