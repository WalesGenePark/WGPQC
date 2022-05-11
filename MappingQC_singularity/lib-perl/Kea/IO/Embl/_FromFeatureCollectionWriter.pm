#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 10/03/2008 12:51:28
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
package Kea::IO::Embl::_FromFeatureCollectionWriter;
use Kea::Object;
use Kea::IO::IWriter;
our @ISA = qw(Kea::Object Kea::IO::IWriter);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $featureCollection =
		Kea::Object->check(shift, "Kea::IO::Feature::FeatureCollection");
	
	my $self = {
		_featureCollection => $featureCollection
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
my $formatCDSFeature = sub {

	my $self = shift;
	my $feature = $self->check(shift, "Kea::IO::Feature::IFeature");
	
	$self->throw("Wrong type passed to method: " . $feature->getName . ".") if
		$feature->getName ne "CDS";

	my $type = $feature->getName or
		$self->throw("No feature type provided! Expecting 'CDS'");
	
	my $gene = $feature->getGene;
	
	my $proteinId = $feature->getProteinId;
	
	my $inference = $feature->getInference;
	
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
	
	my $translTable = $feature->getTranslTable;
	if (!defined $translTable) {
		$self->warn(
			"No transl_table defined for CDS with protein_id '$proteinId'"
			);
		$translTable = 1;
		}
	
	
	
		
	
	my $note = $feature->getNote;
	if ($note) {
		$note = $self->$format($note, "note");
		}
	
	# Get translation, providing cds is not a pseudogene.
	my $isPseudogene = $feature->isPseudo;
	my $translation;
	if (!$isPseudogene) {
		$translation = $feature->getTranslation or
			$self->warn("No translation provided for CDS with " .
			"protein_id '$proteinId'"
			);
		}
	
	if (defined $translation) {
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
	
	if ($inference) {
		$text = $text . "FT                   /inference=\"$inference\"\n";
		}
	
	
	if ($isPseudogene) {
		$text = $text . "FT                   /pseudo\n";
		}
	elsif (defined $translation) {
		$text = $text .  $translation;
		}
	
		
	return $text;
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

# Creates feature text.
my $formatGeneFeature = sub {

	my $self = shift;
	my $feature = $self->check(shift, "Kea::IO::Feature::IFeature");
	
	if ($feature->getName ne "gene") {
		$self->throw(
			"Wrong type passed to method: " . $feature->getName . "."
			);
		}

	my $type = $feature->getName or
		$self->throw("No feature type provided! Expecting 'gene'"
		);
		
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

my $formatMiscFeature = sub {
	
	my $self = shift;
	my $feature = $self->check(shift, "Kea::IO::Feature::IFeature");
	
	if ($feature->getName ne "misc_feature") {
		$self->throw(
			"Wrong type passed to method: " . $feature->getName . "."
			);
		}

	my $type = $feature->getName or
		$self->throw("No feature type provided! Expecting 'Misc'");
		
	my $gene = $feature->getGene;
	my $orientation = $feature->getOrientation || SENSE;
	
	# Assume a single location for misc_feature
	my @locations = $feature->getLocations;
	
	if (@locations > 1) {
		$self->throw("Expecting a single location for a misc_feature");
		}
	
	my $start = $locations[0]->getStart;
	my $end = $locations[0]->getEnd;
	my $colour = $feature->getColour;
	my $product = $feature->getProduct;
	
	my $note = $feature->getNote;
	my $locusTag = $feature->getLocusTag;
	
	if ($note) {
		$note = $self->$format($note, "note");
		}
	
	
	my $locationString;
	if ($orientation eq ANTISENSE) {
		$locationString = "complement($start..$end)";
		}
	else {
		$locationString = "$start..$end";		
		}
	
	my $text = sprintf("FT   %-16s%s\n", $type, $locationString);
	
	if ($gene) {
		$text = $text . "FT                   /gene=\"$gene\"\n";
		}
	
	if (defined $product) {
		$text = $text . "FT                   /product=\"$product\"\n";
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

my $formatGapFeature = sub {
	
	my $self = shift;
	my $feature = $self->check(shift, "Kea::IO::Feature::IFeature");

	
	# Assume a single location for feature
	my @locations = $feature->getLocations;
	
	if (@locations > 1) {
		$self->throw("Expecting a single location for a gap feature");
		}
	
	my $start 			= $locations[0]->getStart;
	my $end 			= $locations[0]->getEnd;
	my $colour			= $feature->getColour;
	my $estimatedLength	= $feature->getEstimatedLength;
	my $note 			= $feature->getNote;
		
	if ($note) {
		$note = $self->$format($note, "note");
		}
	
	my $locationString = "$start..$end";		
		
	
	my $text = sprintf("FT   %-16s%s\n", "gap", $locationString);
	
	if ($colour) {
		$text = $text . "FT                   /colour=$colour\n";
		}
	
	if ($estimatedLength) {
		$text = $text . "FT                   /estimated_length=$estimatedLength\n";
		}
	
	if ($note) {
		$text = $text . $note;
		}
	
	
	return $text;
	
	};

#///////////////////////////////////////////////////////////////////////////////

my $formatRepeatRegionFeature = sub {
	
	my $self 	= shift;
	my $feature = $self->check(shift, "Kea::IO::Feature::IFeature");

	
	# Assume a single location for feature
	my @locations = $feature->getLocations;
	
	if (@locations > 1) {
		$self->throw("Expecting a single location for a repeat_region feature");
		}
	
	my $start 			= $locations[0]->getStart;
	my $end 			= $locations[0]->getEnd;
	my $colour			= $feature->getColour;
	my $note 			= $feature->getNote;
	my $rptFamily		= $feature->getRptFamily;	
		
	if ($note) {
		$note = $self->$format($note, "note");
		}
	
	my $locationString = "$start..$end";		
		
	
	my $text = sprintf("FT   %-16s%s\n", "repeat_region", $locationString);
	
	if ($colour) {
		$text = $text . "FT                   /colour=$colour\n";
		}
	
	if ($rptFamily) {
		$text = $text . "FT                   /rpt_family=$rptFamily\n";
		}
	
	if ($note) {
		$text = $text . $note;
		}
	
	
	return $text;
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $formatSnpFeature = sub {
	
	my $self 	= shift;
	my $feature = $self->check(shift, "Kea::IO::Feature::IFeature");

	
	# Assume a single location for feature
	my @locations = $feature->getLocations;
	
	if (@locations > 1) {
		$self->throw("Expecting a single location for a snp feature");
		}
	
	my $start 			= $locations[0]->getStart;
	my $end 			= $locations[0]->getEnd;
	my $colour			= $feature->getColour;
	my $note 			= $feature->getNote;
		
	if ($note) {
		$note = $self->$format($note, "note");
		}
	
	my $locationString = "$start..$end";		
		
	
	my $text = sprintf("FT   %-16s%s\n", "snp", $locationString);
	
	if ($colour) {
		$text = $text . "FT                   /colour=$colour\n";
		}
	
	if ($note) {
		$text = $text . $note;
		}
	
	
	return $text;
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $formatSourceFeature = sub {
	
	my $self = shift;
	my $feature = $self->check(shift, "Kea::IO::Feature::IFeature");
	
	if ($feature->getName ne "source") {
		$self->throw("Wrong type passed to method: $feature->getName");
		}

	my $type = $feature->getName;
	my $organism = $feature->getOrganism or
		$self->throw("No organism qualifier specified for source feature");
		
	my $strain = $feature->getStrain;
	
	my $molType = $feature->getMolType or $self->throw(
		"No mol_type qualifer specified for source feature"
		);
	
	my $dbXref = $feature->getDbXref;
	my $note = $feature->getNote;
	if ($note) {
		$note = $self->$format($note, "note");
		}
	
	
#	my $location = "$start..$end";
	
	# Should have only one location - check:
	my @locations = $feature->getLocations;
	if (@locations > 1) {
		$self->throw("Only one location expected for source feature");
		}
	
	my $text = sprintf(
		"FT   %-16s%s\n",
		$type,
		$locations[0]->toString
		);
	
	$text = $text . "FT                   /organism=\"$organism\"\n";
	
	if ($strain) {
		$text = $text . "FT                   /strain=\"$strain\"\n";
		}
	
	if ($note) {
		$text = $text . $note;
		}
	
	$text = $text . "FT                   /mol_type=\"$molType\"\n";
	
	if ($dbXref) {
		$text = $text . "FT                   /db_xref=\"$dbXref\"\n";
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
	my $orientation = $feature->getOrientation or $self->throw(
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

################################################################################

# PUBLIC METHODS

sub write {

	my $self 				= shift;
	my $FILEHANDLE			= $self->check(shift);
	my $featureCollection	= $self->{_featureCollection};
	
	# Sort - ensure in order.
	#my $sortedFeatureCollection = Kea::IO::Feature::FeatureCollection->new("");
	#my @features = $featureCollection->getAll;
	#foreach my $feature (sort {$a->getFirstLocation->getStart <=> $b->getFirstLocation->getStart} @features) {
	#	$sortedFeatureCollection->add($feature);
	#	}
	
	
	for (my $i = 0; $i < $featureCollection->getSize; $i++) {
		my $feature = $featureCollection->get($i);
		
		
		my $featureText = undef;
		if ($feature->getName eq "source") {
			$featureText = $self->$formatSourceFeature($feature);
			}
		
		elsif ($feature->getName eq "CDS") {
			$featureText = $self->$formatCDSFeature($feature);
			}
		
		elsif ($feature->getName eq "gene") {
			$featureText = $self->$formatGeneFeature($feature);
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
		
		elsif ($feature->getName eq "UTRS") {
			$featureText = $self->$formatGenericFeature("UTRS", $feature);
			}
		
		elsif ($feature->getName eq "TU") {
			$featureText = $self->$formatGenericFeature("TU", $feature);
			}
		
		elsif ($feature->getName eq "pseudo") {
			$featureText = $self->$formatGenericFeature("pseudo", $feature);
			}
		
		elsif ($feature->getName eq "misc_feature") {
			$featureText = $self->$formatMiscFeature($feature);
			}
		
		elsif ($feature->getName eq "gap") {
			$featureText = $self->$formatGapFeature($feature);
			}
		
		elsif ($feature->getName eq "repeat_region") {
			$featureText = $self->$formatRepeatRegionFeature($feature);
			}
		
		elsif ($feature->getName eq "snp") {
			$featureText = $self->$formatSnpFeature($feature);
			}
		
		
		else {
			$self->throw("Unrecognised Feature: " . $feature->getName . ".");	
			}
		print $FILEHANDLE $featureText;
		
		} # End of for loop - no more features
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

