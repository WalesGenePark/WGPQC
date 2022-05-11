#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 24/04/2008 09:07:54
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
package Kea::IO::Embl::_FromGffRecordCollectionWriter;
use Kea::Object;
use Kea::IO::IWriter;
our @ISA = qw(Kea::Object Kea::IO::IWriter);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::Utilities::DNAUtility;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;

	my $gffRecordCollection =
		Kea::Object->check(shift, "Kea::IO::Gff::GffRecordCollection");
	
	my $self = {
		_gffRecordCollection => $gffRecordCollection
		};
	
	bless(
		$self,
		$className
		);
	
	return $self;
	
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $formatFirstLine = sub {
	
	my $self = shift;
	my $type = $self->check(shift);
	my @locationStrings = @_;
	
	# Only one location - single line.
	if (@locationStrings == 1) {
		return sprintf("FT   %-16s%s\n", $type, $locationStrings[0]);;
		}
	
	# Multiple locations - may require multiple lines.
	# Create series of lines, each no more than 52 characters.
	
	my @lines;
	my $line = "join(";
	
	foreach my $locationString (@locationStrings) {
		$line = $line . $locationString . ",";
		if (length($line) >= 48) {
			push(@lines, $line);
			$line = "";
			}
		}
	push (@lines, $line) if length($line) > 0;
	
	# Amend last line, replacing final , with ).
	$lines[$#lines] =~ s/,$/)/;
	
	# Create final block of text and return.	
	my $formattedText = sprintf("FT   %-16s%s\n", $type, $lines[0]);
	if (scalar(@lines) > 1) {
		for (my $i = 1; $i < scalar(@lines); $i++) {
			$formattedText = $formattedText . "FT                   $lines[$i]\n";
			}
		}
	
	return $formattedText;
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

# Formats raw aa sequence into blocks of text as seen in embl formatted file.
my $formatTranslation = sub {

	my $self = shift;
	my $translation = $self->check(shift);
	
	my $text = "/translation=\"$translation\"";
	
	# Dice sequence into 59 character chunks
	my @buffer;
	for (my $i = 0; $i < length($text); $i = $i + 59) {
		my $block = substr($text, $i, 59);
		push(@buffer, $block);
		}
	
	my $formattedText;
	foreach my $block (@buffer) {
		$formattedText = $formattedText . "FT                   $block\n";
		}
	
	return $formattedText;
	
	}; # End of method.


#///////////////////////////////////////////////////////////////////////////////

my $format = sub {

	my $self = shift;
	my $text = $self->check(shift);
	my $label = $self->check(shift);
	
	# Create full text string.
	$text = "/$label=\"$text\"\n";
	
	# Convert to an array of words.
	my @words = split(" ", $text);
	
	# Create series of lines, each no more than 52 characters.
	my @lines;
	my $line;
	foreach my $word (@words) {
		$line = $line . $word;
		if (length($line) >= 52) {
			push(@lines, $line);
			$line = "";
			}
		else {
			$line = $line . " "; # Ensure whitespace between words.
			}
		}
	push (@lines, $line) if length($line) > 0;
	
	# Create final block of text and return.
	$text = "";
	foreach my $line (@lines) {
		$text = $text . "FT                   $line\n";
		}
	return $text;
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

# Creates feature text.
my $formatGenericFeature = sub {

	my $self = shift;
	my $type = shift;
	my $feature = $self->check(shift, "Kea::IO::Feature::IFeature");
	
	if ($feature->getName ne $type) {
		$self->throw(
			"Wrong type passed to method: " . $feature->getName . "."
			);
		}
		
	my $gene = $feature->getGene;
	my $orientation  =$feature->getOrientation or $self->throw(
		"No orientation information provided for gene '$gene'"
		);
	
	my $hasMultipleStartPositions = $feature->hasMultipleStartPositions;
	
	
	my $colour = $feature->getColour;
	my $locusTag = $feature->getLocusTag;
	
	my $note = $feature->getNote;
	if ($note) {
		$note = $self->$format($note, "note");
		}
	
	my @locationStrings;
	my @locationObjects = $feature->getLocations;
	foreach my $location (@locationObjects) {
		if ($orientation eq SENSE) {
			push(@locationStrings, $location->toString);
			}
		else {
			push(@locationStrings, "complement(" . $location->toString . ")");
			}
		} 
	
	# First line of feature:
	my $text = $self->$formatFirstLine($type, @locationStrings);
	
	if ($gene) {
		$text = $text . "FT                   /gene=\"$gene\"\n";
		}
	
	if ($locusTag) {
		$text = $text . "FT                   /locus_tag=\"$locusTag\"\n";
		}
	
	if ($colour) {
		$text = $text . "FT                   /colour=$colour\n";
		}
	
	if ($note) {
		$text = $text . $note;
		}
		
	return $text;
	
	};

#///////////////////////////////////////////////////////////////////////////////

# Creates feature text.
my $formatCDSFeature = sub {

	my $self = shift;
	my $feature = $self->check(shift, "Kea::IO::Feature::IFeature");
	
	$self->throw("Wrong type passed to method: " . $feature->getName . ".") if
		$feature->getName ne "CDS";

	my $type = $feature->getName or
		$self->throw("No feature type provided! Expecting 'CDS'");
	
	my $gene = $feature->getGene;
	
	my $proteinId = $feature->getProteinId;
	
	my $product = $feature->getProduct;
	if ($product) {
		$product = $self->$format($product, "product");
		}
	
	my $orientation = $feature->getOrientation
		or $self->throw(
			"No orientation information provided for CDS " .
			"with protein_id '$proteinId'"
			);
	
	my $hasMultipleStartPositions = $feature->hasMultipleStartPositions;
	
	my $colour = $feature->getColour;
	
	my $locusTag = $feature->getLocusTag;
	
	my $codonStart = $feature->getCodonStart;
#		or confess "\nERROR: No codon_start defined for CDS with protein_id '$proteinId'";
	
	my $translTable = $feature->getTranslTable
		or $self->throw(
			"No transl_table defined for CDS with protein_id '$proteinId'"
			);
	
	my $note = $feature->getNote;
	if ($note) {
		$note = $self->$format($note, "note");
		}
	
	# Get translation, providing cds is not a pseudogene.
	my $isPseudogene = $feature->isPseudo;
	my $translation;
	if (!$isPseudogene) {
		$translation = $feature->getTranslation or
			$self->throw("No translation provided for CDS with " .
			"protein_id '$proteinId'"
			);
		$translation = $self->$formatTranslation($feature->getTranslation);
		}

	
	my @locationStrings;
	my @locationObjects = $feature->getLocations;
	foreach my $location (@locationObjects) {
		if ($orientation eq SENSE) {
			push(@locationStrings, $location->toString);
			}
		else {
			push(@locationStrings, "complement(" . $location->toString . ")");
			}
		} 
	
	# First line of feature:
	my $text = $self->$formatFirstLine($type, @locationStrings);
	
	if ($gene) {
		$text = $text . "FT                   /gene=\"$gene\"\n";
		}
	
	if ($locusTag) {
		$text = $text . "FT                   /locus_tag=\"$locusTag\"\n";
		}
	
	if ($colour) {
		$text = $text . "FT                   /colour=$colour\n";
		}
	
	if ($product) {
		$text = $text . $product;
		}
	
	if ($note) {
		$text = $text . $note;
		}
	
	if ($codonStart) {
		$text = $text . "FT                   /codon_start=$codonStart\n";
		}
	
	$text = $text . "FT                   /transl_table=$translTable\n";
	
	if ($proteinId) {
		$text = $text . "FT                   /protein_id=\"$proteinId\"\n";
		}
	
	if ($isPseudogene) {
		$text = $text . "FT                   /pseudo\n";
		}
	else {
		$text = $text .  $translation;
		}
	
		
	return $text;
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $processGffRecord = sub {
	
	my $self 		= shift;
	my $FILEHANDLE	= $self->check(shift);
	my $gffRecord	= $self->check(shift, "Kea::IO::Gff::IGffRecord");
	
	# Print ID line.
	#===========================================================================
	
	# Attributes
	#	ID=apidb|VIIb;
	#	Name=VIIb;
	#	description=VIIb;
	#	size=5023822;
	#	web_id=VIIb;
	#	molecule_type=dsDNA;
	#	organism_name=Toxoplasma gondii;
	#	translation_table=11;
	#	topology=linear;
	#	localization=nuclear;
	#	Dbxref=ApiDB_ToxoDB:VIIb,taxon:5811
	
	my $primaryAccession = $gffRecord->getPrimaryAccession or
		$self->throw("Missing primary accession");
	
	my $topology = $gffRecord->getAttributes->get("topology") or
		$self->throw("Missing topology: $primaryAccession.");
	
	my $length = $gffRecord->getAttributes->get("size") or
		$self->throw("Missing size information: $primaryAccession.");
	
	# Just in case...	
	$self->throw(
		"Expected length ($length) differs from actual (" .
		length($gffRecord->getSequence) .
		")."
		) if $length != length($gffRecord->getSequence);	
	
	my $moleculeType = $gffRecord->getAttributes->get("molecule_type") or
		$self->throw("Missing molecule type: $primaryAccession");
	
	# Unknowns:
	my $version 			= "???";
	my $dataClass 			= "???";
	my $taxonomicDivision 	= "???";
	
	# ID   CP000025; SV 1; circular; genomic DNA; STD; PRO; 1777831 BP.
	# ID   X56734; SV 1; linear; mRNA; STD; PLN; 1859 BP.
	
	printf $FILEHANDLE (
		"ID   %s; %s; %s; %s; %s; %s; %s BP\n",
		$primaryAccession,	# 1. Primary accession number
		$version,			# 2. Sequence version number
		$topology,			# 3. Topology: 'circular' or 'linear'
		$moleculeType,		# 4. Molecule type
		$dataClass,			# 5. Data class.
		$taxonomicDivision,	# 6. Taxonomic division.
		$length				# 7. Sequence length.
		) or $self->throw("Could not print to outfile.");
	
	#===========================================================================
	
	
	# Other pre-feature information:
	#===========================================================================
	
	#Fri Jan 18 13:36:25 2008	
	my @date = split(" ", (localtime));
	my $day 	= $date[2];
	my $month 	= uc($date[1]);
	my $year 	= $date[4];
	
	my $description = $gffRecord->getAttributes->get("description") or
		$self->throw("Missing description: $primaryAccession");
	
	my $text = "";
	$text .= "XX\n";
	$text .= "AC   $primaryAccession;\n";
	$text .= "XX\n";
	$text .= sprintf ("DT   %d-%s-%d (Created)\n", $day, $month, $year);
	$text .= "XX\n";
	$text .= "DE   $description\n";
	$text .= "XX\n";
	$text .= "FH   Key             Location/Qualifiers\n";
	$text .= "FH\n";
	print $FILEHANDLE $text or $self->throw("Could not print to outfile");
	
	#===========================================================================
	
	
	
	# Print features.
	#===========================================================================
	
	my $featureCollection = $gffRecord->getFeatureCollection;
	
	for (my $i = 0; $i < $featureCollection->getSize; $i++) {
		my $feature = $featureCollection->get($i);
		
		my $featureText = undef;
		#if ($feature->getName eq "source") {
		#	$featureText = $self->$formatSourceFeature($feature);
		#	}
		
		if ($feature->getName eq "CDS") {
			$featureText = $self->$formatCDSFeature($feature);
			}
		
		elsif ($feature->getName eq "gene") {
			$featureText = $self->$formatGenericFeature("gene", $feature);
			}
		
		elsif ($feature->getName eq "exon") {
			$featureText = $self->$formatGenericFeature("exon", $feature);
			}
		
		elsif ($feature->getName eq "tRNA") {
			$featureText = $self->$formatGenericFeature("tRNA", $feature);
			}
		
		elsif ($feature->getName eq "mRNA") {
			$featureText = $self->$formatGenericFeature("mRNA", $feature);
			}
		
		#elsif ($feature->getName eq "misc_feature") {
		#	$featureText = $self->$formatMiscFeature($feature);
		#	}
		
		else {
			$self->throw(
				"Unrecognised Feature: " . $feature->getName . ". "
				);	
			}
		print $FILEHANDLE $featureText or
			$self->throw("Could not print to outfile.");
		
		}
	
	#===========================================================================
	
	
	
	# Print sequence.
	#===========================================================================
	
	my $seqText = "";
	$seqText .= "XX\n";
	
	my $sequence = uc($gffRecord->getSequence);
	
	# Count bases.
	my ($As, $Cs, $Gs, $Ts, $others) =
		Kea::Utilities::DNAUtility->countCanonicalBases($sequence);
	
	$seqText .= sprintf (
		"SQ   Sequence %s BP; %s A; %s C; %s G; %s T; %s other;\n",
		$length,
		$As,
		$Cs,
		$Gs,
		$Ts,
		$others
		);
	
	# Dice sequence into 60 base chunks
	my @buffer;
	for (my $i = 0; $i < length($sequence); $i = $i + 60) {
		my $bases60 = substr($sequence, $i, 60);
		
		# Further dice into 10 base blocks
		my @line;
		for (my $j = 0; $j < length($bases60); $j = $j + 10) {
			my $bases10 = substr($bases60, $j, 10);
			push(@line, $bases10);
			}
		push(@buffer, \@line);
		}
	
	my $counter = 0;
	foreach my $line (@buffer) {
		
		my $string = "    ";

		foreach my $block (@$line) {
			$counter = $counter + length($block);
			$string = "$string $block";
			}
		
		$seqText .= sprintf ("%-70s%10s\n", $string, $counter);
		
		}
	
	$seqText .= "//\n";
	
	print $FILEHANDLE $seqText or $self->throw("Could not print to outfile.");
	
	#===========================================================================
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub write {

	my $self 				= shift;
	my $FILEHANDLE 			= $self->check(shift);
	my $gffRecordCollection = $self->{_gffRecordCollection};
	
	for (my $i = 0; $i < $gffRecordCollection->getSize; $i++) {
		my $gffRecord = $gffRecordCollection->get($i);
		
		my $id = $gffRecord->getPrimaryAccession;
		
		#ÊDue to variable nature of gf files, check for sequence info before
		# proceeding.
		$self->throw("No dna sequence associated with gff record: $id")
			if !$gffRecord->hasSequence;
		$self->throw("No translations associated with gff record: $id.")
			if !$gffRecord->hasTranslations;
		
		# Ok to process.
		$self->$processGffRecord($FILEHANDLE, $gffRecord);
			
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

