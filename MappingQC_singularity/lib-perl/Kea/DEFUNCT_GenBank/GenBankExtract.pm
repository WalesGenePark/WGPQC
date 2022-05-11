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
package Kea::GenBank::GenBankExtract;
use Kea::Object;
our @ISA = qw(Kea::Object);

use strict;
use warnings;

use constant TRUE => 1;
use constant FALSE => 0;

use Kea::Parsers::GenBankGenomeFileParser; 
use Kea::Utilities::CDSUtility;

use Kea::Sequence::SequenceFactory;
use Kea::IO::Fasta::WriterFactory;

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

# PRIVATE METHODS

my $createFastaFile = sub {
	
	my ($ids, $sequences, $filename) = @_;
	
	open (OUTFILE, ">$filename") or die "Can't create outfile: $filename\n";

	for (my $i = 0; $i < scalar(@$ids); $i++) {
		
		print OUTFILE ">$ids->[$i]\n";
		print OUTFILE "$sequences->[$i]\n\n";
		
		}
	
	close(OUTFILE);
	
#    print "$filename written.'\n";
	
	}; # End of private method.

#///////////////////////////////////////////////////////////////////////////////

my $createGeneProductsListFile = sub {
	
	my ($ids, $geneProducts, $filename) = @_;
	
	open(OUT, ">$filename") or die "Can't create outfile: $filename.\n";
	
	for (my $i = 0; $i < scalar(@$ids); $i++) {
		print OUT $ids->[$i] . "\t" . $geneProducts->[$i] . "\n";
		}
	
	close(OUT);
	
	}; # End of private method.

################################################################################

# PUBLIC METHODS

sub run {
	my ($self, %args) = @_;
	
	my $infileName = $args{-in} 					or die "No infile name has been supplied: use -in tag.\n";
	my $cdsOutfileName = $args{-outCDS} 			or die "No cds outfile name has been supplied: use -outCDS tag\n";
	my $proteinOutfileName = $args{-outTranslation} 	or die "No protein outfile name has been supplied: use -outTranslation tag\n";
	my $geneProductOutfileName = $args{-outProduct};
	my $sequenceOutfileName = $args{-outSequence};
	
	# Open GenBank file.
	open(INFILE, "$infileName") or die "Sorry, can't open $infileName! ";
	print "Opened $infileName\n";
	
	# Parse genbank record.
	my $parser = Kea::Parsers::GenBankGenomeFileParser->new();
	
	# Extract genbank file data and store in parser object.
	$parser->parse(*INFILE);
	close(INFILE);
	
	# Retrieve extracted data of interest.
	my @protein_ids = $parser->getProteinIDs();
	my @protein_GIs = $parser->getProteinGIs();
	my @translations = $parser->getTranslations();
	my @cdsSequences = $parser->getCDSSequencesInSenseOrientation();
	my @positions = $parser->getCDSPositions();
	my $dna = $parser->getDNA();
	
	my $locusName = $parser->getLocusName();
	my $sequenceLength = $parser->getSequenceLength();
	my $moleculeType = $parser->getMoleculeType();
	my $genBankDivision = $parser->getGenBankDivision();
	my $modificationDate = $parser->getModificationDate();
	my $definition = $parser->getDefinition();	
	my $accession = $parser->getAccession();
	
	my @geneNames = $parser->getGeneNames();
	my @geneProducts = $parser->getGeneProducts();
	my @locusTags = $parser->getLocusTags();
	
	# Check all is ok.
	#=========================================
	
	print "=======================================================\n";
	print "Checking parsing:\n";
	print "-------------------------------------------------------\n";
	print "$definition\n";
	print "LOCUS name:\t\t$locusName\n";
	print "Accession:\t\t$accession\n";
	print "Expected size:\t\t$sequenceLength bp\n";
	
	print "Actual size:\t\t" . length($dna) . " bp";
	if (length($dna) == $sequenceLength) {print "\t OK\n";} else {print "\t WRONG!\n";}
	
	print "Molecule type:\t\t$moleculeType\n";
	print "GenBank division:\t$genBankDivision\n";
	print "Modification date:\t$modificationDate\n";
	
	print "-------------------------------------------------------\n";
	
	print "Number of translations:\t\t\t" . scalar(@translations) . "\n";
	
	print "Number of gene names:\t\t\t" . scalar(@geneNames);
	if (scalar(@geneNames) == scalar(@translations)) {print "\t OK\n";} else {print "\t WRONG\n";}
	
	print "Number of products descriptions:\t" . scalar(@geneProducts);
	if (scalar(@geneProducts) == scalar(@translations)) {print "\t OK\n";} else {print "\t WRONG\n";}
	
	print "Number of protein_ids:\t\t\t" . scalar(@protein_ids);
	if (scalar(@protein_ids) == scalar(@translations)) {print "\t OK\n";} else {print "\t WRONG\n";}
	
	print "Number of protein GIs:\t\t\t" . scalar(@protein_GIs);
	if (scalar(@protein_GIs) == scalar(@translations)) {print "\t OK\n";} else {print "\t WRONG\n";}
	
	print "Number of gene names:\t\t\t" . scalar(@geneNames);
	if (scalar(@geneNames) == scalar(@translations)) {print "\t OK\n";} else {print "\t WRONG\n";}
	
	print "Number of locus_tags:\t\t\t" . scalar(@locusTags);
	if (scalar(@locusTags) == scalar(@translations)) {print "\t OK\n";} else {print "\t WRONG\n";}
	
	print "Number of cds sequences:\t\t" . scalar(@cdsSequences);
	if (scalar(@cdsSequences) == scalar(@translations)) {print "\t OK\n";} else {print "\t WRONG\n";}
	
	print "-------------------------------------------------------\n";
	print "\n";
	
	
	#=========================================
	
	my $utility = Kea::Utilities::CDSUtility->new(
		-showInformationMessages => FALSE,
		-showWarningMessages => TRUE,
		-showErrorMessages => TRUE,
		-informationMessagesToLog => FALSE
		);
	
	# Check that cds sequences actually translate to protein translations extracted from file (belt and braces!).
	for	(my $i = 0; $i < scalar(@cdsSequences); $i++) {
		my $cds = $cdsSequences[$i];
		my $protein = $translations[$i];
		my $matches = $utility->checkCDSCodesToProtein(
			-cdsSequence => $cds,
			-proteinSequence => $protein,
			#-isBacterial => TRUE,
			#-strict => FALSE,
			-code => $protein_ids[$i],
			#-ignoreStopCodon => TRUE
			);
		if (!$matches) {
			print "cds does not match translation: protein_id=$protein_ids[$i]\n\n" ;
			}
		}
	
	# Next, generate fasta formatted files for protein and cds sequences.
	$createFastaFile->(\@protein_ids, \@translations, $proteinOutfileName);
	$createFastaFile->(\@protein_ids, \@cdsSequences, $cdsOutfileName);
	
	if ($geneProductOutfileName) {
		$createGeneProductsListFile->(\@protein_ids, \@geneProducts, $geneProductOutfileName);
		}
	
	# Create fasta formatted dna sequence file.
	if ($sequenceOutfileName) {
		open(OUT, ">$sequenceOutfileName") or confess "\nERROR: Could not open $sequenceOutfileName";
		
		my $sf = Kea::Sequence::SequenceFactory->new;
		my $seqObject = $sf->createSequence(
			-id => "reference_genome",
			-sequence => $dna
			);
		my $wf = Kea::IO::Fasta::WriterFactory->new;
		my $writer = $wf->createWriter($seqObject);
		$writer->write(*OUT);
		close(OUT);
		
		}

	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

