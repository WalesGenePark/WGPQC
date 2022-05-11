#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 
#    Copyright (C) 2008, University of Liverpool.
#    Author: Kevin Ashelford.
#
#    Contact details:
#    Email:    k.ashelford@liv.ac.uk
#    Address:  School of Biological Sciences, University of Liverpool, 
#              Biosciences Building, Crown Street, Liverpool, UK. L69 7ZB
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
package Kea::IO::Embl::_ToHandlerReader;
use Kea::Object;
use Kea::IO::IReader;
our @ISA = qw(Kea::Object Kea::IO::IReader);

use strict;
use warnings;
use File::Copy;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;
use constant SENSE 	=> "sense";
use constant ANTISENSE 	=> "antisense";

use Kea::IO::Feature::FeatureFactory;
use Kea::IO::Location;

our @_lines;

use Kea::Properties;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	my $className = shift;
	my $self = {
		_pseudoCount => 0
		};
	bless(
		$self,
		$className
		);
	return $self;
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $extractText = sub {
	my (
		$self,
		$firstPart,
		$addGap,
		$endCharacter,
		@lines
		) = @_;
	
	
	my @buffer = @lines;
	
	# No need to process lines further if text on one line only. Just remove ".
	if ($firstPart =~ /(.+)$endCharacter$/) {
		return $1;
		}
	
	my $gap = "";
	if ($addGap) {$gap = " ";}
	
	# Multiline text.
	my $text = $firstPart;
	while (my $line = shift @lines) {
		chomp $line;
		
		# Current line contains only end-character
		if ($line =~ /^FT\s+$endCharacter\s*$/) {
			return $text;
			}
		
		# Come to end of text block as indicated by end-character at end of text.
		elsif ($line =~ /^FT\s+(.+)$endCharacter\s*$/) {
			return $text . "$gap$1";
			}
		
		# No end-character at end of text therefore assume not yet last line.
		elsif ($line =~ /^FT\s+(.+)\s*$/) {
			$text = $text . "$gap$1";
			}
		else {
			$self->throw("No regex pattern for this line : $line");
			}
		} # End of while - no more lines.
		
		
	$self->throw(
		"Shouldn't reach this point - perhaps a problem with the " .
		"regular expression!"
		);
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $_number = 0;

# Creates an instance of IFeature using supplied data.
my $createFeatureObject = sub {
	
	my (
		$self,
		$featureType,
		$beginArray,
		$endArray,
		$orientation,
		@lines
		) = @_;
	
	my $gene 		= undef;
	my $colour 		= undef;
	my $proteinId 		= undef;
	my $note 		= undef;
	my $locusTag 		= undef;
	my $translation 	= undef;
	my $organism 		= undef;
	my $strain 		= undef;
	my $molType 		= undef;
	my $dbXref 		= undef;
	my $codonStart 		= undef;
	my $translTable 	= undef; #1=Standard. 11=Bacterial and plant plastid.
	my $pseudo 		= FALSE;
	my $product 		= undef; #"unknown";
	my $estimatedLength	= undef;
	my $rptFamily		= undef;
	my $boundMoiety		= undef;
	my $ncRNAClass		= undef;
	my $experiment		= undef;
	my $inference		= undef;
	my $exception 		= undef;
	
	my @buffer = @lines;
	
	while (my $line = shift @lines) {
	
		chomp ($line);
		
		#FT                   /organism="Campylobacter jejuni RM1221"
		if ($line =~ /^FT\s+\/organism=\"(.+)/) {
			$organism = $self->$extractText($1, TRUE, "\"", @lines);
			}
		
		# NOT YET CHECKED...
		elsif ($line =~ /^FT\s+\/estimated_length=(\d+)/) {
			$estimatedLength = $1;
			}
		
		#FT                   /pseudo
		elsif ($line =~ /^FT\s+\/pseudo/) {
			$pseudo = TRUE;
			}
		
		# NOT YET CHECKED...
		elsif ($line =~ /^FT\s+\/rpt_family=\"(.+)\"/) {
			$rptFamily = $1;
			}
		
		#FT                   /strain="RM1221"
		elsif ($line =~ /^FT\s+\/strain=\"(.+)\"/) {
			$strain = $1;
			}
		
		
		elsif ($line =~ /^FT\s+\/inference=\"(.+)\"/) {
			$inference = $1;	
			}
		
		elsif ($line =~ /^FT\s+\/exception=\"(.+)\"/) {
			$exception = $1;
			}
		
		
		#FT                   /mol_type="genomic DNA"
		elsif ($line =~ /^FT\s+\/mol_type=\"(.+)\"/) {
			$molType = $1;
			}
		#FT                   /db_xref="taxon:195099"
		elsif ($line =~ /^FT\s+\/db_xref=\"(.+)\"/) {
			$dbXref = $1;
			}
		
		#FT                   /bound_moiety="adenosylcobalamin"
		elsif ($line =~ /^FT\s+\/bound_moiety=\"(.+)\"/) {
			$boundMoiety = $1;
			}
		
		# FT                   /ncRNA_class="autocatalytically_spliced_intron"
		elsif ($line =~ /^FT\s+\/ncRNA_class=\"(.+)\"/) {
			$ncRNAClass = $1;
			}
		
		#FT                   /codon_start=1
		elsif ($line =~ /^FT\s+\/codon_start=(\d)/) {
			$codonStart = $1;
			}
		
		#FT                   /transl_table=11
		elsif ($line =~ /^FT\s+\/transl_table=(\d+)/) {
			$translTable = $1;
			}
		
		
		#FT                   /gene="dnaA"
		elsif ($line =~ /^FT\s+\/gene=\"(.+)\"$/) {
			$gene = $1;
			}
		
		#FT                   /colour=150 120 150
		elsif ($line =~ /^FT\s+\/colo[u]*r=\"*(\d+\s\d+\s\d+)\"*$/) {
			$colour = $1;
			}
		
		#FT                   /locus_tag="CJE0001"
		#FT                   /locus_tag="Cj0072c"
		elsif ($line =~ /^FT\s+\/locus_tag=\"(.+)\"/) {
			if (defined $locusTag) {
			
				print "@buffer\n";
			
				$self->throw("locus_tag '$locusTag' being redefined to '$1'");
				}
			$locusTag = $1;
			}
		
		#FT                   /product="chromosomal replication initiator protein DnaA"
		
		#FT                   /note="identified by similarity to SP:P05648; match to
		#FT                   protein family HMM PF00308; match to protein family HMM
		#FT                   TIGR00362"
		elsif ($line =~ /^FT\s+\/note=\"(.+)\"/) {
			$note = $1;		
			}
		
		
		
		elsif ($line =~ /^FT\s+\/note=\"(.+)/) {
			$note = $self->$extractText($1, TRUE, "\"", @lines);
			}
		
		#FT                   /product="chromosomal replication initiator protein DnaA"
		#FT                   /note="identified by similarity to SP:P05648; match to
		#FT                   protein family HMM PF00308; match to protein family HMM
		#FT                   TIGR00362"
		elsif ($line =~ /^FT\s+\/product=\"(.+)\"/) {
			$product = $1;
			}
		
		elsif ($line =~ /^FT\s+\/product=\"(.+)/) {
			$product = $self->$extractText($1, TRUE, "\"", @lines);
			}
		
		
		elsif ($line =~ /^FT\s+\/experiment=\"(.+)/) {
			$experiment = $self->$extractText($1, TRUE, "\"", @lines);
			}
		
		
		#FT                   /db_xref="GOA:Q5HXF5"
		#FT                   /db_xref="InterPro:IPR001957"
		#FT                   /db_xref="InterPro:IPR003593"
		#FT                   /db_xref="InterPro:IPR010921"
		#FT                   /db_xref="InterPro:IPR013159"
		#FT                   /db_xref="InterPro:IPR013317"
		#FT                   /db_xref="UniProtKB/Swiss-Prot:Q5HXF5"
		#FT                   /protein_id="AAW34498.1"
		elsif ($line =~ /^FT\s+\/protein_id=\"(.+)\"/) {
			$proteinId = $1;
			}
		
		
		#FT                   /translation="MNPSQILENLKKELSENEYENYLSNLKFNEKQSKADLLVFNAPNE
		#FT                   LMAKFIQTKYGKKIAHFYEVQSGNKAIINIQAQSAKQSNKSTKIDIAHIKAQSTILNPS
		#FT                   FTFDSFVVGDSNKYAYGACKAITHKDKLGKLYNPIFVYGPTGLGKTHLLQAVGNASLEM
		#FT                   GKKVIYATSENFINDFTSNLKNGSLDKFHEKYRNCDVLLIDDVQFLGKTDKIQEEFFFI
		#FT                   FNEIKNNDGQIIMTSDNPPNMLKGITERLKSRFAHGIIADITPPQLDTKIAIIRKKCEF
		#FT                   NDINLSNDIINYIATSLGDNIREIEGIIISLNAYATILGQEITLELAKSVMKDHIKEKK
		#FT                   ENITIDDILSLVCKEFNIKPSDVKSNKKTQNIVTARRIVIYLARALTALTMPQLANYFE
		#FT                   MKDHTAISHNVKKITEMIENDGSLKAKIEELKNKILVKSQS"
		elsif ($line =~ /^FT\s+\/translation=\"(.+)/) {
			$translation = $self->$extractText($1, FALSE, "\"", @lines);
			}
		
		} # End of while - no more lines to process.
	
	# Create location objects for feature.
		my @locations;
		for (my $i = 0; $i < @$beginArray; $i++) {
			push(
				@locations,
				Kea::IO::Location->new(
					$beginArray->[$i],
					$endArray->[$i]
					)
				);
		
			}
		# Just in case still used later.  Force to use Location objects.
		$beginArray = undef;
		$endArray = undef;
		
	# NOTE: must order location objects - order varies in embl files - need to
	# be consist, therefore ensure location objects always in ascending order.
	@locations = sort {$a->getStart <=> $b->getStart} @locations;
	
	# Now create feature object from collected data.
	my $featureObject = undef;
	
	# CDS feature.	
	if ($featureType eq "CDS") {
		
		# Must have a locus tag. 
		if (!defined $locusTag) {
			
			foreach my $location (@locations) {
				print "[" . $location->toString() . "]\n";		
				}
			
			
			$self->throw("No locus_tag could be found for CDS at '$proteinId'.");
			}
		
		# Note: protein_id used as default id code (accession) for translation
		# (e.g. subsequent sequence objects).  However, sometimes not set.
		# So needs to have a value but warn user of this.
		#if (!defined $proteinId) {
		#	$proteinId = $locusTag || $gene || "null_" . $_number++;
		#	$self->warn("CDS without a protein_id.  Will use '$proteinId'");
		#	}
		
		# 02/03/2009 - be stricter...
		# 24/03/2009 - not so strict downloaded GenBank record found to lack
		# feature
        if (!defined $translTable) {
            $translTable = 1;
            $self->warn("CDS without a transl_table value.  Using '1'.");
            }
        
		if ($pseudo) {
			$self->{_pseudoCount}++;
			#print "INFORMATION: CDS with locus_tag '$locusTag' represents a pseudogene and therefore has no translation.\n";
			#if (defined $translation) {
			#	print "Except this CDS does have a translation:\n$translation\n\n";
			#	}
			}
		
		$featureObject = Kea::IO::Feature::FeatureFactory->createCDS(
			-gene 			=> $gene,
			-locations 		=> \@locations,
			-colour 		=> $colour,
			-note 			=> $note,
			-translation 		=> $translation,
			-orientation 		=> $orientation,
			-codonStart 		=> $codonStart,
			-translTable 		=> $translTable,
			-proteinId 		=> $proteinId,
			-locusTag 		=> $locusTag,
			-pseudo 		=> $pseudo,
			-product 		=> $product,
			-inference		=> $inference,
			-exception		=> $exception
			);
		}
	
	elsif ($featureType eq "gene") {
		
		$featureObject = Kea::IO::Feature::FeatureFactory->createGene(
			-gene 			=> $gene,
			-locations 		=> \@locations,
			-colour 		=> $colour,
			-note 			=> $note,
			-translation 		=> $translation,
			-orientation 		=> $orientation,
			-codonStart 		=> $codonStart,
			-translTable 		=> $translTable,
			-proteinId 		=> $proteinId,
			-locusTag 		=> $locusTag,
			-pseudo 		=> $pseudo,
			-product 		=> $product
		
			#-gene 			=> $gene,
			#-locations 		=> \@locations,
			#-colour 		=> $colour,
			#-note 			=> $note,
			#-orientation 		=> $orientation,
			#-locusTag 		=> $locusTag
			);
		
		}
	
	elsif ($featureType eq "tRNA") {
		
		$featureObject = Kea::IO::Feature::FeatureFactory->createtRNA(
		
			-gene 			=> $gene,
			-locations 		=> \@locations,
			-colour 		=> $colour,
			-note 			=> $note,
			-translation 		=> $translation,
			-orientation 		=> $orientation,
			-codonStart 		=> $codonStart,
			-translTable 		=> $translTable,
			-proteinId 		=> $proteinId,
			-locusTag 		=> $locusTag,
			-pseudo 		=> $pseudo,
			-product 		=> $product
		
			#-gene 			=> $gene,
			#-locations 		=> \@locations,
			#-colour 		=> $colour,
			#-note 			=> $note,
			#-orientation 		=> $orientation	
			);
		
		}
	
	elsif ($featureType eq "mRNA") {
		
		$featureObject = Kea::IO::Feature::FeatureFactory->createmRNA(
		
			-gene 			=> $gene,
			-locations 		=> \@locations,
			-colour 		=> $colour,
			-note 			=> $note,
			-translation 		=> $translation,
			-orientation 		=> $orientation,
			-codonStart 		=> $codonStart,
			-translTable 		=> $translTable,
			-proteinId 		=> $proteinId,
			-locusTag 		=> $locusTag,
			-pseudo 		=> $pseudo,
			-product 		=> $product
		
			#-gene 			=> $gene,
			#-locations 		=> \@locations,
			#-colour 		=> $colour,
			#-note 			=> $note,
			#-orientation 		=> $orientation	
			);
		
		}
	
	elsif ($featureType eq "rRNA") {
	
		$featureObject = Kea::IO::Feature::FeatureFactory->createrRNA(
		
			-gene 			=> $gene,
			-locations 		=> \@locations,
			-colour 		=> $colour,
			-note 			=> $note,
			-orientation 		=> $orientation,
			-locusTag 		=> $locusTag,
			-product 		=> $product
		
			);
		
		}
	
	
	
	elsif ($featureType eq "source") {
		
		$featureObject = Kea::IO::Feature::FeatureFactory->createSource(
		
			-gene 			=> $gene,
			-locations 		=> \@locations,
			-colour 		=> $colour,
			-note 			=> $note,
			-translation 		=> $translation,
			-orientation 		=> $orientation,
			-codonStart 		=> $codonStart,
			-translTable 		=> $translTable,
			-proteinId 		=> $proteinId,
			-locusTag 		=> $locusTag,
			-pseudo 		=> $pseudo,
			-product 		=> $product,
		
			-organism 		=> $organism,
			-locations 		=> \@locations,
			-strain 		=> $strain,
			-molType 		=> $molType,
			-dbXref 		=> $dbXref
			);
		}
	
	# All other features.
	
	elsif ($featureType eq "misc_feature") {
	
		$featureObject = Kea::IO::Feature::FeatureFactory->createMisc(
		
			-gene 			=> $gene,
			-locations 		=> \@locations,
			-colour 		=> $colour,
			-note 			=> $note,
			-translation 		=> $translation,
			-orientation 		=> $orientation,
			-codonStart 		=> $codonStart,
			-translTable 		=> $translTable,
			-proteinId 		=> $proteinId,
			-locusTag 		=> $locusTag,
			-pseudo 		=> $pseudo,
			-product 		=> $product
		
			#-gene 			=> $gene,
			#-locations 		=> \@locations,
			#-colour 		=> $colour,
			#-note 			=> $note,
			#-orientation 	=> $orientation
			);
		
		}
	
	elsif ($featureType eq "misc_RNA") {
	
		$featureObject = Kea::IO::Feature::FeatureFactory->createMiscRNA(
		
			-gene 		=> $gene,
			-locations 	=> \@locations,
			-colour 	=> $colour,
			-note 		=> $note,
			-orientation 	=> $orientation,
			-locusTag 	=> $locusTag,
			-product 	=> $product
		
			);
		
		}
	
	elsif ($featureType eq "gap") {
		
		$featureObject = Kea::IO::Feature::FeatureFactory->createGap(
			-locations 		=> \@locations,
			-colour 		=> $colour,
			-note 			=> $note,
			-estimatedLength	=> $estimatedLength
			);
		
		}
	
	
	elsif ($featureType eq "repeat_region") {
		
		$featureObject = Kea::IO::Feature::FeatureFactory->createRepeatRegion(
			-locations 	=> \@locations,
			-colour 	=> $colour,
			-note 		=> $note,
			-orientation 	=> $orientation,
			-rptFamily	=> $rptFamily
			);
		
		}
	
	elsif ($featureType eq "snp") {
		
		$featureObject = Kea::IO::Feature::FeatureFactory->createSnp(
			-locations 	=> \@locations,
			-colour 	=> $colour,
			-note 		=> $note
			);
		
		}
	
	elsif ($featureType eq "misc_binding") {
		
		$featureObject = Kea::IO::Feature::FeatureFactory->createMiscBinding(
			-locations 	=> \@locations,
			-boundMoiety 	=> $boundMoiety,
			-note 		=> $note
			);
		
		}
	
	
	elsif ($featureType eq "ncRNA") {
		
		$featureObject = Kea::IO::Feature::FeatureFactory->createNcRNA(
			-locations 	=> \@locations,
			-ncRNAClass 	=> $ncRNAClass,
			-note 		=> $note,
			-locusTag	=> $locusTag
			);
		
		}
	
	
	elsif ($featureType eq "sig_peptide") {
		
		$featureObject = Kea::IO::Feature::FeatureFactory->createSigPeptide(
			-locations 	=> \@locations,
			-note 		=> $note,
			-orientation 	=> $orientation
			);
		
		}
	
	elsif ($featureType eq "stem_loop") {
		
		$featureObject = Kea::IO::Feature::FeatureFactory->createStemLoop(
			-locations 	=> \@locations,
			-orientation 	=> $orientation
			);
		
		}
	
	
	elsif ($featureType eq "terminator") {
		
		$featureObject = Kea::IO::Feature::FeatureFactory->createTerminator(
			-locations 	=> \@locations,
			-note		=> $note,
			-orientation 	=> $orientation
			);
		
		}
	
	
	elsif ($featureType eq "-35_signal") {
		
		$featureObject = Kea::IO::Feature::FeatureFactory->createMinus35Signal(
			-locations 	=> \@locations,
			-orientation 	=> $orientation
			);
		
		}
	
	
	elsif ($featureType eq "-10_signal") {
		
		$featureObject = Kea::IO::Feature::FeatureFactory->createMinus10Signal(
			-locations 	=> \@locations,
			-orientation 	=> $orientation
			);
		
		}
	
	elsif ($featureType eq "variation") {
		
		$featureObject = Kea::IO::Feature::FeatureFactory->createMinus10Signal(
			-locations 	=> \@locations,
			-note		=> $note,
			-locusTag	=> $locusTag,
			-experiment	=> $experiment
			);
		
		}
	
	
	elsif ($featureType eq "tmRNA") {
		
		$featureObject = Kea::IO::Feature::FeatureFactory->createTmRNA(
			-locations 	=> \@locations,
			-orientation 	=> $orientation,
			-gene		=> $gene,
			-locusTag	=> $locusTag,
			-product	=> $product
			);
		
		}
	

	
	else {
	
		$self->warn("Not explicitly accounting for feature '$featureType'...");
		
		$featureObject = Kea::IO::Feature::FeatureFactory->create(
			#-name		=> $featureType,
			#-gene 		=> $gene,
			#-locations 	=> \@locations,
			#-colour 	=> $colour,
			#-note 		=> $note,
			#-orientation 	=> $orientation
			
			-gene 		=> $gene,
			-locations 	=> \@locations,
			-colour 	=> $colour,
			-note 		=> $note,
			-translation 	=> $translation,
			-orientation 	=> $orientation,
			-codonStart 	=> $codonStart,
			-translTable 	=> $translTable,
			-proteinId 	=> $proteinId,
			-locusTag 	=> $locusTag,
			-pseudo 	=> $pseudo,
			-product 	=> $product
			);
		}
	
	return $featureObject;
	
	}; #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

my $processFeature = sub {

	my (
		$self,
		$featureType,
		$begin,
		$end,
		$orientation
		) = @_;
	
	my @buffer;
	
	# Continue reading lines until end of feature is reached.
	while (my $line = shift @_lines) {
		
		# If line is start of next feature - stop, replace line, and return
		# feature.
		# NOTE assume feature start line is of form FT - 3 spaces - some text -
		# spaces - etc. 
		if (
		#	$line =~ m/^FT\s{3}[\w\-\_]+\s+(join\()*(complement\()*\d+\.\./ ||
			$line =~ m/^FT\s{3}[\w\-\_]+\s+(join\()*(complement\()*/ ||
			$line =~ m/^XX/ ||
			$line =~ /^SQ/
			) {
			unshift(@_lines, $line);
			return
				$self->$createFeatureObject(
					$featureType,
					[$begin],
					[$end],
					$orientation,
					@buffer
					);
			}
		# Otherwise, store line in buffer.
		else {
			push(@buffer, $line);
			}
		
		}
	
	
	
	
	# Previously didn't allow - but not good for feature files only - may need
	# to change...
	return $self->$createFeatureObject(
		$featureType,
		[$begin],
		[$end],
		$orientation,
		@buffer
		);
	#$self->throw("Shouldn't reach this point!");
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $getSequence = sub {

	my $self = shift;
	
	#     atgaatccaa gccaaatact tgaaaattta aaaaaagaat taagtgaaaa cgaatacgaa        60
	#     aactatttat caaatttaaa attcaacgaa aaacaaagca aagcagatct tttagttttc       120
	#     aacgctccaa atgaactcat ggctaaattc atacaaacaa aatacggtaa aaaaatcgca       180
	#     catttttatg aagtgcaaag tggaaataaa gccatcataa atatacaagc acaaagtgct       240
	#     aaacaaagta acaaaagcac aaaaatcgac atagctcata taaaagcaca aagcacaatt       300
	#     ttaaatcctt cttttacttt tgacagtttt gttgtggggg attctaacaa atacgcttat       360
	
	my $sequence;
	
	foreach my $line (@_lines) {
		
		if ($line =~ /^\/\//) {
			return $sequence;
			}
		
		$line =~ s/[\s+\d+]//g;
		$sequence = $sequence . $line;
			
		}
	
	$self->throw("Should not reach this point!");
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $extractCoordsFromText = sub {

	my $self = shift;
	my $text = shift;
	my @startArray;
	my @endArray;
	my $orientation;
	
	my @buffer = split(",", $text);
	my ($start, $end);
	foreach my $item (@buffer) {
		if ($item =~ /^(\d+)\.\.(\d+)$/) {
		
			$start = $1;
			$end = $2;
			if ($1 > $2) {
				$start = $2;
				$end = $1;
				$self->warn(
					"Start and end locations are the wrong way round: $item"
					);
				} 
			
			$orientation = SENSE;
			push(@startArray, $1);
			push(@endArray, $2);
			}
		
		# THIS REGION WAS COMMENTED OUT - WHY?
		##====================
		
		# Handles location info with < character
		elsif ($item =~ /^\<(\d+)\.\.(\d+)$/) {
		
			$start = $1;
			$end = $2;
			if ($1 > $2) {
				$start = $2;
				$end = $1;
				$self->warn(
					"Start and end locations are the wrong way round: $item"
					);
				} 
			
			$orientation = SENSE;
			push(@startArray, "<$1");
			push(@endArray, $2);
			}
		
		elsif ($item =~ /^(\d+)\.\.\>(\d+)$/) {
		
			$start = $1;
			$end = $2;
			if ($1 > $2) {
				$start = $2;
				$end = $1;
				$self->warn(
					"Start and end locations are the wrong way round: $item"
					);
				} 
			
			$orientation = SENSE;
			push(@startArray, $1);
			push(@endArray, ">$2");
			}
		
		##=================
		
		elsif ($item =~ /^complement\((\d+)\.\.(\d+)\)$/) {
			
			$start = $1;
			$end = $2;
			if ($1 > $2) {
				$start = $2;
				$end = $1;
				$self->warn(
					"Start and end locations are the wrong way round: $item"
					);
				} 
			
			$orientation = ANTISENSE;
			push(@startArray, $1);
			push(@endArray, $2);
			
			}
		
		
		
		elsif ($item == 1) {
			$self->warn("Location indicates circular record BUT THIS FEATURE YET TO BE CODED FOR!");
			}
		
		else {
			$self->throw("Haven't accounted for this pattern: $item from @buffer");	
			}
		
		}
	
	return (\@startArray, \@endArray, $orientation);
	};

#///////////////////////////////////////////////////////////////////////////////

my $processFeatureWithJoin = sub {
	
	#FT   CDS             join(66985..67113,67229..67411,67411..67602,67602..67940,
	#FT                   67942..68203,68205..68278,68277..68504)
	
	#FT   CDS             join(complement(83654..83893),complement(83292..83654))
	
	#FT   CDS             join(167050..167295,167297..167794)
	
	#FT   CDS             join(206063..206308,206308..206691,206724..206939,
	#FT                   206939..206974,206974..207063,207095..207310,
	#FT                   207314..207637,207636..207770,207775..207843,
	#FT                   207843..207980,208012..208203,208203..208337,
	#FT                   208336..208473,208475..208666,208673..208846,
	#FT                   208852..208950,208954..209055,209055..209195)
	
	#FT   CDS             join(complement(268591..268809),complement(267638..268597),
	#FT                   complement(267516..267629))
	
	
	my $self = shift;
	push(my @buffer, shift);
	
	# Continue reading lines until end of feature is reached.
	while (my $line = shift @_lines) {
		
		# If line is start of next feature - stop, replace line, and stop.
		# NOTE assume feature start line is of form FT - 3 spaces - some text - spaces - etc. 
		if (
		#	$line =~ m/^FT\s{3}[\w\-\_]+\s+(join\()*(complement\()*\d+\.\./ ||
			$line =~ m/^FT\s{3}[\w\-\_]+\s+(join\()*(complement\()*/ ||
			$line =~ m/^XX/ ||
			$line =~ /^SQ/
			) {
			unshift(@_lines, $line);
			last;
			}
		# Otherwise, store line in buffer.
		else {
			push(@buffer, $line);
			}
		
		}
	
	# Now process.
	my $featureType;
	
	# Process first line.
	my $line = shift(@buffer); 
	my $text;
	if ($line =~ /^FT\s{3}([\w\-\_]+)\s+join\((.+)/) {
		$featureType = $1;
		$text = $2;
		}
	else {
		$self->throw("Haven't accounted for this situation: \nline = $line");	
		}
	
	$text = $self->$extractText($text, FALSE, "\\)", @buffer);
	
	my ($startArray, $endArray, $orientation) =
		$self->$extractCoordsFromText($text);
	
	
	return
		$self->$createFeatureObject(
			$featureType,
			$startArray,
			$endArray,
			$orientation,
			@buffer
			);
	
	
	};

################################################################################

# PUBLIC METHODS

sub read {

	my $self 		= shift;
	my $FILEHANDLE 	= $self->check(shift);
	my $handler 	= $self->check(shift, "Kea::IO::Embl::IReaderHandler");
		
	# Create array of line strings from infile.
	# NOT VERY SCALABLE - currently not a problem, but MAY NEED TO CHANGE THIS.
	@_lines = <$FILEHANDLE>;	
		
	while (my $line = shift @_lines) {
	
		chomp $line;

		# FOLLOWING DUPLICATES BELOW
		#ID   AL111168; SV 1; circular; genomic DNA; STD; PRO; 1641481 BP.
		#ID   CP000025; SV 1; circular; genomic DNA; STD; PRO; 1777831 BP.
		#ID   CP000538; SV 1; circular; genomic DNA; STD; PRO; 1616554 BP.
		#ID   CP000768; SV 1; circular; genomic DNA; STD; PRO; 1845106 BP.
		#ID   CP000814; SV 1; circular; genomic DNA; STD; PRO; 1628115 BP.
		if ($line =~ /^ID\s+(\w+); SV (\d+); (\w+); ([\w\s]+); (\w+); (\w+); (\d+) BP.$/) {
			
			
			$handler->_nextIDLine(
				$1,	# primary accession number
				$2, 	# Sequence version number
				$3, 	# Topology: 'circular' or 'linear'
				$4,	# Molecule type
				$5,	# Data class
				$6,	# Taxonomic division
				$7	# Sequence length
				);	
			
			}
	
		# ID   1336; SV 1; ???; genomic DNA; ???; ???; 1691770 BP
		elsif ($line =~ /^ID\s+(\S+); (.+); (\S+); (.+); (\S+); (\S+); (\d+) BP\.{0,1}$/) {
				
			$handler->_nextIDLine(
				$1,	# primary accession number
				$2, 	# Sequence version number
				$3, 	# Topology: 'circular' or 'linear'
				$4,	# Molecule type
				$5,	# Data class
				$6,	# Taxonomic division
				$7	# Sequence length
				);	
				
			}
		
		
		# ID   apidb|Ia; ???; linear; dsDNA; ???; ???; 1896408 BP
		# ID   1336; SV 1; ???; genomic DNA; ???; ???; 1691770 BP.
		elsif ($line =~ /^ID\s+(\S+);\s+S*V*\s*(\S+);\s+(\S+);\s+(\S+);\s+(\S+);\s+(\S+);\s+(\d+)\s+BP\.*\s*$/) {
			
			$handler->_nextIDLine(
				$1,	# primary accession number
				$2, 	# Sequence version number
				$3, 	# Topology: 'circular' or 'linear'
				$4,	# Molecule type
				$5,	# Data class
				$6,	# Taxonomic division
				$7	# Sequence length
				);
			}
		
		# ID   CP000025; SV 1; circular; genomic DNA; STD; PRO; 1777831 BP.
#		elsif ($line =~ /^ID\s+(.+);\s+SV\s+(.+);\s+(.+);\s+(.+);\s+(.+);\s+(.+);\s+(\d+)\s+BP\.*\s*$/) {
#			
#			$handler->_nextIDLine(
#				$1,		# primary accession number
#				$2, 	# Sequence version number
#				$3, 	# Topology: 'circular' or 'linear'
#				$4,		# Molecule type
#				$5,		# Data class
#				$6,		# Taxonomic division
#				$7		# Sequence length
#				);	
#				
#			}
		# ID   STYPHCT18  standard; circular genomic DNA; CON; 4809037 BP.
		elsif ($line =~ /^ID\s+(\S+)\s+(\w+);\s+(\w+)\s+([\w\s]+);\s+(\w+);\s+(\d+)\s+BP\.*\s*$/) {
		    
		    $handler->_nextIDLine(
			$1,     # Primary accession number.
			$2,     # Sequence version 'number'.
			$3,		# Topology
					$4,		# molecule type
					"???",	# Data class ($5 ???)
					"???",	# Taxonomic division ($5 ???)
					$6		# Sequence length.
			);
		    
		    }
		
		# ID   NZ_ACJA02000005standard; DNA; BCT; 39837 BP.
		elsif ($line =~ /^ID\s+(\S+);\s+(\S+);\s+(\S+);\s+(\d+)\s+BP/) {
		#elsif ($line =~ /^ID\s+(\S+);\s+(\w+)\s+(\w+);\s+(\d+)\s+BP\.*\s*$/) {
		    
		    $handler->_nextIDLine(
			$1,     # Primary accession number.
			1,      # Sequence version 'number'.
			"Unknown",		# Topology
			$2,		# molecule type
			"???",	# Data class ($5 ???)
			"???",	# Taxonomic division ($5 ???)
			$4		# Sequence length.
			);
		    
		    }
		
		
		# AC   CP000025;
		elsif ($line =~ /^AC\s+(.+);/) {
			$handler->_nextAccessionLine($1);
			}
		
		
		# PR = Project
		# PR   Project:27797;
		elsif ($line =~ /^PR\s+Project:(\d+);/) {
			$handler->_nextProjectId($1);
			}
		
		
		# DE = Description.
		elsif ($line =~ /^DE\s+(.+)$/) {
			$handler->_nextDescriptionLine($1);
			}
		
		# KW = keyword(s).
		elsif ($line =~ /^KW\s+(.+)\.$/) {
			$handler->_nextKeywordsLine($1);
			}
		
		# OS = source.
		elsif ($line =~ /^OS\s+(.+)$/) {
			$handler->_nextSourceOrganismLine($1)
			}
		
		# OC = source phylogeny
		elsif ($line =~ /^OC\s+(.+)$/) {
			$handler->_nextSourcePhylogenyLine($1);
			}
		
		# RN = Reference number
		elsif ($line =~ /^RN\s+\[(\d+)\]$/) {
			$handler->_nextReferenceNumberLine($1);
			}
		
		# RA = Reference authors
		elsif ($line =~ /^RA\s+(.+)$/) {
			$handler->_nextReferenceAuthorLine($1);
			}
		
		#ÊRT = Reference titles
		elsif ($line =~ /^RT\s+(.+)$/) {
			$handler->_nextReferenceTitleLine($1);
			}
		# RL = Reference journal.
		elsif ($line =~ /^RL\s+(.+)$/) {
			$handler->_nextReferenceJournalLine($1);
			}
		
		# CC = Comment
		elsif ($line =~ /^CC\s+(.+)$/) {
			$handler->_nextCommentLine($1);
			}
		
		
		
		# Some sort of feature (sense).
		elsif ($line =~ m/^FT\s{3}([\w\-\_]+)\s+(\d+)\.\.(\d+)\s*$/) {
			$handler->_nextFeatureObject(
				$self->$processFeature($1, $2, $3, SENSE)
				);
			}
		
		elsif ($line =~ m/^FT\s{3}([\w\-\_]+)\s+<(\d+)\.\.(\d+)\s*$/) {
			$handler->_nextFeatureObject(
				$self->$processFeature($1, "<$2", $3, SENSE)
				);
			}
		elsif ($line =~ m/^FT\s{3}([\w\-\_]+)\s+(\d+)\.\.>(\d+)\s*$/) {
		
			$handler->_nextFeatureObject(
				$self->$processFeature($1, "$2", ">$3", SENSE)
				);
			}
		
		
		
		# Some sort of feature (antisense).
		elsif ($line =~ m/^FT\s{3}([\w\-\_]+)\s+complement\((\d+)\.\.(\d+)\)\s*$/) {
			$handler->_nextFeatureObject(
				$self->$processFeature($1, $2, $3, ANTISENSE)
				);
			}
		
		elsif ($line =~ m/^FT\s{3}([\w\-\_]+)\s+complement\(<(\d+)\.\.(\d+)\)\s*$/) {
			$handler->_nextFeatureObject(
				$self->$processFeature($1, "<$2", $3, ANTISENSE)
				);
			}
		
		elsif ($line =~ m/^FT\s{3}([\w\-\_]+)\s+complement\((\d+)\.\.>(\d+)\)\s*$/) {
			$handler->_nextFeatureObject(
				$self->$processFeature($1, $2, ">$3", ANTISENSE)
				);
			}
		
		
		
		# Feature with complex coordinates.
		elsif ($line =~ m/^FT\s{3}([\w\-\_]+)\s+join\(/) {
			my $feature = $self->$processFeatureWithJoin($line);
			$handler->_nextFeatureObject($feature);
			}
		
		#SQ   Sequence 1777831 BP; 621543 A; 270571 C; 268221 G; 617496 T; 0 other;
		#SQ   Sequence 375136 BP; 128059 A; 65246 C; 52857 G; 128974 T; 0 other;
		elsif ($line =~ /^SQ\s+Sequence\s+(\d+)\s+BP\;\s+(\d+)\s+A\;\s+(\d+)\s+C\;\s+(\d+)\s+G\;\s+(\d+)\s+T\;\s+(\d+)\s+other\;/) {
			
			my $length = $1;
			my $As = $2;
			my $Cs = $3;
			my $Gs = $4;
			my $Ts = $5;
			my $others = $6;
			my $sequence = $self->$getSequence();		
						
			$handler->_nextSequence($length, $As, $Cs, $Gs, $Ts, $others, $sequence);
			}
		
		}
	
	if ($self->{_pseudoCount}) {
		
		if (Kea::Properties->getProperty("warnings") ne "off") {
			$self->warn(
				$self->{_pseudoCount} . " pseudo genes encountered in embl infile."
				);
			}
		
		
		}
	
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;