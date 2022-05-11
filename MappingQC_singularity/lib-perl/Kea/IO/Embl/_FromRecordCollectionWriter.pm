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
package Kea::IO::Embl::_FromRecordCollectionWriter;
use Kea::Object;
use Kea::IO::IWriter;
our @ISA = qw(Kea::Object Kea::IO::IWriter);

use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";

use Kea::Utilities::DNAUtility;
use Kea::IO::RecordFactory;

my %_emblDivisionKey = (

	# embl		Genbank
	#=====================================================
	
    
	BCT		=>	'PRO', # Prokaryote -> bacterial sequences
	UNA		=>	'UNC', #
	PRO		=> 'PRO',
	UNC		=> 'UNC'
	);


# ADD AS REQUIRED.
my %_moleculeTypeKey = (
	'DNA' 			=> 'Genomic DNA',
	'Genomic DNA'	=> 'Genomic DNA',
	'???'			=> '???'
	);

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $recordCollection =
		Kea::Object->check(shift, "Kea::IO::RecordCollection");

	my $self = {
		_recordCollection => $recordCollection
		};
	
	bless(
		$self,
		$className
		);
	return $self;
	
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $formatText = sub {
	
	my $self 		= shift;
	my $header		= $self->check(shift);
	my $rawText		= $self->check(shift);
	
	my @words = split(/\s+/, $rawText);
	
	my $line = "$header  ";
	my $text = "";
	
	foreach my $word (@words) {
		
		if (length("$line $word") >= 80) {
			$text .= "$line\n";
			$line = "$header   $word";
			}
		else {
			$line .= " $word";
			}
		
		}
	
	$text .= "$line\n"; 
	
	return $text;
	
	
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $formatFirstLine = sub {
	
	my $self = shift;
	my $type = shift,
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
	my $translation = shift;
	
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
	my $text = shift;
	my $label = shift;
	
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
	
	$feature->getName eq "CDS" or
		$self->throw("Wrong type passed to method: $feature.");

	my $type = $feature->getName or
		$self->throw("No feature type provided! Expecting 'CDS'.");
	
	my $gene = $feature->getGene;
	
	my $proteinId = $feature->getProteinId;
	
	my $inference = $feature->getInference;
	
	my $exception = $feature->getException;
	
	my $product = $feature->getProduct;
	if ($product) {
		$product = $self->$format($product, "product");
		}
	
	my $orientation = $feature->getOrientation
		or $self->throw(
			"No orientation information provided for CDS with " .
			"protein_id '$proteinId'"
			);
	
	my $hasMultipleStartPositions = $feature->hasMultipleStartPositions;
	
	my $colour = $feature->getColour;
	
	my $locusTag = $feature->getLocusTag;
	
	my $codonStart = $feature->getCodonStart;
#		or confess "\nERROR: No codon_start defined for CDS with protein_id '$proteinId'";
	
	my $translTable = $feature->getTranslTable
		or $self->throw("No transl_table defined for CDS with " .
		"protein_id '$proteinId'."
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
	
	if ($inference) {
		$text = $text . "FT                   /inference=\"$inference\"\n";	
		}
	
	if ($exception) {
		$text = $text . "FT                   /exception=\"$exception\"\n";
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

# Creates feature text.
my $formatGeneFeature = sub {

	my $self = shift;
	my $feature = $self->check(shift, "Kea::IO::Feature::IFeature");
	
	$feature->getName eq "gene" or
		$self->throw("Wrong feature-type passed to method: $feature->getName");

	my $type = $feature->getName or
		$self->throw("No feature type provided! Expecting 'gene'.");
		
	my $gene = $feature->getGene;
	
	my $orientation = $feature->getOrientation or
		$self->throw("No orientation information provided for gene '$gene'.");
	
	my $hasMultipleStartPositions = $feature->hasMultipleStartPositions;
	
	#my @startArray = $feature->getStartArray
	#	or confess "\nERROR: No start position information provided for gene '$gene'";
	#
	#my @endArray = $feature->getEndArray
	#	or confess "\nERROR: No end position information provided for gene '$gene'";
	#
	
	my $isPseudogene = $feature->isPseudo;
	
	my $colour = $feature->getColour;
	
	my $locusTag = $feature->getLocusTag;
	
	my $note = $feature->getNote;
	if ($note) {
		$note = $self->$format($note, "note");
		}
	

	## Construct location data.  May be multiple locations requiring joining.
	#my @locations;
	#for (my $i = 0; $i < scalar(@startArray); $i++){
	#
	#	if ($orientation eq SENSE) {
	#		push(@locations, "$startArray[$i]..$endArray[$i]");
	#		}
	#	else {
	#		push(@locations, "complement($startArray[$i]..$endArray[$i])");
	#		}
	#	}
	
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
	
	if ($isPseudogene) {
		$text = $text . "FT                   /pseudo\n";
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
	
	$feature->getName eq "misc_feature" or
		$self->throw("Wrong feature-type passed to method: $feature->getName.");

	my $type = $feature->getName or
		$self->throw("No feature type provided! Expecting 'Misc'.");
		
	my $gene = $feature->getGene;

	my $orientation = $feature->getOrientation;
	
	# Assume a single location for misc_feature
	my @locations = $feature->getLocations;
	if (@locations > 1) {
		$self->throw("Expecting a single location for a misc_feature.");
		}
	
	my $start = $locations[0]->getStart;
	my $end = $locations[0]->getEnd;
	
	my $colour = $feature->getColour;
	
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

my $formatSourceFeature = sub {
	
	my $self = shift;
	my $feature = $self->check(shift, "Kea::IO::Feature::IFeature");
	
	$feature->getName eq "source" or
		$self->throw("Wrong feature-type passed to method: $feature->getName.");

	my $type = $feature->getName;
	
	my $organism = $feature->getOrganism or
		$self->throw("No organism qualifier specified for source feature.");
	
	#my $start = $feature->getStart or confess "\nERROR: No start position specified for source feature";
	#my $end = $feature->getEnd or confess "\nERROR: No end position specified for source feature";
	
	my $strain = $feature->getStrain;
	
	my $molType = $feature->getMolType or
		$self->throw("No mol_type qualifer specified for source feature.");
	
	my $dbXref = $feature->getDbXref;
	
	my $note = $feature->getNote;
	if ($note) {
		$note = $self->$format($note, "note");
		}
	
	
#	my $location = "$start..$end";
	
	# Should have only one location - check:
	my @locations = $feature->getLocations;
	if (@locations > 1) {
		$self->throw("Only one location expected for source feature.");
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

my $formatGenericFeature = sub {

	my $self = shift;
	my $type = shift;
	my $feature = $self->check(shift, "Kea::IO::Feature::IFeature");
	
	if ($feature->getName ne $type) {
		$self->throw("Wrong type passed to method: " . $feature->getName . ".");
		}
		
	my $product = $feature->getProduct;
	if ($product) {$product = $self->$format($product, "product");}	
		
	my $gene = $feature->getGene;
	
	my $orientation = $feature->getOrientation or
		$self->throw("No orientation information provided for feature $type.");
	
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
	
	if ($gene) {$text = $text . "FT                   /gene=\"$gene\"\n";}
	
	if ($locusTag) {$text = $text . "FT                   /locus_tag=\"$locusTag\"\n";}
	
	if ($colour) {$text = $text . "FT                   /colour=$colour\n";}
	
	if ($product) {$text = $text . $product;}
	
	if ($note) {$text = $text . $note;}
		
	return $text;
	
	};

#///////////////////////////////////////////////////////////////////////////////

my $processRecord = sub {

	my $self 		= shift;
	my $FILEHANDLE 	= shift;
	my $record 		= $self->check(shift, "Kea::IO::IRecord");
	
	
	# Get features sorted by location.	 
	my @features 			= $record->getSortedFeatures;
	
	my $sequence 			= uc($record->getSequence);
	my $length 				= length($sequence);
	my $primaryAccession	= $record->getPrimaryAccession;
	
	
	
	my $version 			= $record->getVersion;
	my $moleculeType 		= $_moleculeTypeKey{$record->getMoleculeType}		if ($record->hasMoleculeType); #	|| $self->throw("Do not recognise " . $record->getMoleculeType . ".");
	my $topology 			= $record->getTopology								if ($record->hasTopology);
	my $taxonomicDivision	= $_emblDivisionKey{$record->getTaxonomicDivision} 	if ($record->hasTaxonomicDivision); #|| $self->throw("Do not recognise " . $record->getTaxonomicDivision . ".");
	my $dataClass			= $record->getDataClass								if ($record->hasDataClass);

	
	my $projectId			= $record->getProjectId 							if ($record->hasProjectId);
	my $description 		= $record->getDescription							if ($record->hasDescription);
	my @keywords			= $record->getKeywords 								if ($record->hasKeywords);
	
	my $comment				= $record->getComment								if ($record->hasComment);
	my $source				= $record->getSource								if ($record->hasSource);
	my $sourcePhylogeny		= $record->getSourcePhylogeny						if ($record->hasSourcePhylogeny);
	
	
	
	
	#Fri Jan 18 13:36:25 2008	
	my @date = split(" ", (localtime));
	my $day 	= $date[2];
	my $month 	= uc($date[1]);
	my $year 	= $date[4];
	
	#my ($day, $month, $year) = (localtime)[3,4,5];
	#$year = $year + 1900;

	
	# Print header stuff.
	
	# ID   CP000025; SV 1; circular; genomic DNA; STD; PRO; 1777831 BP.
	printf $FILEHANDLE (
		"ID   %s; SV %s; %s; %s; %s; %s; %s BP.\nXX\n",
		$primaryAccession,
		$version			|| "???", # if missing
		$topology			|| "???", # if missing
		$moleculeType		|| "???", # If missing
		$dataClass 			|| "STD", # NECESSARY IF CONVERTING FROM GENBANK FOR EXAMPLE.
		$taxonomicDivision	|| "???",
		$length
		);
	
	print $FILEHANDLE "AC   $primaryAccession;\nXX\n";
	
	print $FILEHANDLE "PR   Project:$projectId;\nXX\n" 							if (defined $projectId);
	
	printf $FILEHANDLE ("DT   %d-%s-%d (Created)\nXX\n", $day, $month, $year);
	
	print $FILEHANDLE $self->$formatText("DE", $description) . "XX\n"			if (defined $description);
	
	print $FILEHANDLE "KW   " . join("; ", @keywords) . ".\nXX\n"				if (@keywords);
	
	print $FILEHANDLE "OS   $source\n"											if (defined $source);
	print $FILEHANDLE $self->$formatText("OC", $sourcePhylogeny) . "XX\n"		if (defined $sourcePhylogeny);
	
	
	# References
	my $referenceCollection = $record->getReferenceCollection;
	for (my $i = 0; $i < $referenceCollection->getSize; $i++) {
		my $reference = $referenceCollection->get($i);
		
		my $n = $reference->getNumber;
		my $title = $reference->getTitle;
		my $journal = $reference->getJournal;
		my $authorCollection = $reference->getAuthorCollection;
		my @authors;
		for (my $j = 0; $j < $authorCollection->getSize; $j++) {
			my $author = $authorCollection->get($j);
			push(@authors, $author->toString);
			}
		
		print $FILEHANDLE "RN   [$n]\n";
		print $FILEHANDLE "RP   1-$length\n";
		print $FILEHANDLE $self->$formatText("RA", join(", ", @authors));
		print $FILEHANDLE $self->$formatText("RT", $title);
		print $FILEHANDLE $self->$formatText("RL", $journal);
		print $FILEHANDLE "XX\n";
		
		
		}
	
	print $FILEHANDLE $self->$formatText("CC", $comment) . "XX\n"						if (defined $comment);
	
	
	print $FILEHANDLE "FH   Key             Location/Qualifiers\n";
	print $FILEHANDLE "FH\n";

	
	# Print features.
	for (my $i = 0; $i < scalar(@features); $i++) {
	
		my $featureText = undef;
		if ($features[$i]->getName eq "source") {
			$featureText = $self->$formatSourceFeature($features[$i]);
			}
		
		elsif ($features[$i]->getName eq "CDS") {
			$featureText = $self->$formatCDSFeature($features[$i]);
			}
		
		elsif ($features[$i]->getName eq "gene") {
			$featureText = $self->$formatGeneFeature($features[$i]);
			}
		
		elsif ($features[$i]->getName eq "misc_feature") {
			$featureText = $self->$formatMiscFeature($features[$i]);
			}
		
		elsif ($features[$i]->getName eq "exon") {
			$featureText = $self->$formatGenericFeature("exon", $features[$i]);
			}
		
		elsif ($features[$i]->getName eq "tRNA") {
			$featureText = $self->$formatGenericFeature("tRNA", $features[$i]);
			}
		
		elsif ($features[$i]->getName eq "rRNA") {
			$featureText = $self->$formatGenericFeature("rRNA", $features[$i]);
			}
		
		elsif ($features[$i]->getName eq "misc_RNA") {
			$featureText = $self->$formatGenericFeature("misc_RNA", $features[$i]);
			}
		
		
		elsif ($features[$i]->getName eq "mRNA") {
			$featureText = $self->$formatGenericFeature("mRNA", $features[$i]);
			}
		
		elsif ($features[$i]->getName eq "UTRS") {
			$featureText = $self->$formatGenericFeature("UTRS", $features[$i]);
			}
		
		elsif ($features[$i]->getName eq "TU") {
			$featureText = $self->$formatGenericFeature("TU", $features[$i]);
			}
		
		elsif ($features[$i]->getName eq "pseudo") {
			$featureText = $self->$formatGenericFeature("pseudo", $features[$i]);
			}
		
		elsif ($features[$i]->getName eq "stem_loop") {
			$featureText = $self->$formatGenericFeature("stem_loop", $features[$i]);	
			}
		
		elsif ($features[$i]->getName eq "sig_peptide") {
			$featureText = $self->$formatGenericFeature("sig_peptide", $features[$i]);	
			}
		
		elsif ($features[$i]->getName eq "repeat_region") {
			$featureText = $self->$formatGenericFeature("repeat_region", $features[$i]);	
			}
		
		elsif ($features[$i]->getName eq "terminator") {
			$featureText = $self->$formatGenericFeature("terminator", $features[$i]);	
			}
		
		elsif ($features[$i]->getName eq "-35_signal") {
			$featureText = $self->$formatGenericFeature("-35_signal", $features[$i]);	
			}
		
		elsif ($features[$i]->getName eq "-10_signal") {
			$featureText = $self->$formatGenericFeature("-10_signal", $features[$i]);	
			}
		
		else {
			$self->throw(
				"Unrecognised Feature: " . $features[$i]->getName . ". "
				);	
			}
		print $FILEHANDLE $featureText;
		
		} # End of for loop - no more features.
	
	# Print sequence.
	print $FILEHANDLE "XX\n";
	
	# Count bases.
	my ($As, $Cs, $Gs, $Ts, $others) = Kea::Utilities::DNAUtility->countCanonicalBases($sequence);
	
	
	print $FILEHANDLE "SQ   Sequence $length BP; $As A; $Cs C; $Gs G; $Ts T; $others other;\n";
	
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
		
		printf $FILEHANDLE ("%-70s%10s\n", $string, $counter);
		
		}
	
	print $FILEHANDLE "//\n\n";
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub write {

	my $self = shift;
	my $FILEHANDLE = $self->check(shift);
	
	my $recordCollection = $self->{_recordCollection};
	
	for (my $i = 0; $i < $recordCollection->getSize; $i++) {
		$self->$processRecord($FILEHANDLE, $recordCollection->get($i));
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

=pod

ID   CP000025; SV 1; circular; genomic DNA; STD; PRO; 1777831 BP.
XX
AC   CP000025;
XX
DT   12-JAN-2005 (Rel. 82, Created)
DT   17-APR-2005 (Rel. 83, Last updated, Version 2)
XX
DE   Campylobacter jejuni RM1221, complete genome.

FT   misc_feature    95000..100000
FT                   /colour=255 243 243
FT                   /algorithm="alien_hunter"
FT                   /note="threshold: 10.795"
FT                   /score=13.121


=cut
