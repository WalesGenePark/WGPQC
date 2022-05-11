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
package Kea::IO::GenBank::_ToHandlerReader;
use Kea::Object;
use Kea::IO::IReader;
our @ISA = qw(Kea::Object Kea::IO::IReader);

use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";

use Kea::IO::Feature::FeatureFactory;
use Kea::IO::Location;
use Kea::Properties;

my @_lines;

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

my $getSequence = sub {

	my $self = shift;

=pod
        1 atgaatccaa gccaaatact tgaaaattta aaaaaagaat taagtgaaaa cgaatacgaa
       61 aactatttat caaatttaaa attcaacgaa aaacaaagca aagcagatct tttagttttt
      121 aatgctccaa atgaactcat ggctaaattc atacaaacaa aatacggcaa aaaaatcgcg
      181 catttttatg aagtgcaaag cggaaataaa gccatcataa atatacaagc acaaagtgct
      241 aaacaaagca acaaaagcac aaaaatcgac atagctcata taaaagcaca aagcacgatt
      301 ttaaatcctt cttttacttt tgaaagtttt gttgtagggg attctaacaa atacgcttat
      361 ggagcatgta aagccatagc acataaagac aaacttggaa aactttataa tccaatcttt
      421 gtttatggac ctacaggact tggaaaaaca catttacttc aagcagttgg aaatgcaagc
      481 ttagaaatgg gaaaaaaagt tatttacgct accagtgaaa atttcatcaa cgattttact
	  //
=cut

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

my $extractText = sub {

	my ($self, $firstPart, $addGap, $endCharacter, @lines) = @_;
	
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
		if ($line =~ /^\s+$endCharacter\s*$/) {
			return $text;
			}
		
		# Come to end of text block as indicated by end-character at end of text.
		elsif ($line =~ /^\s+(.+)$endCharacter\s*$/) {
			return $text . "$gap$1";
			}
		
		# No end-character at end of text therefore assume not yet last line.
		elsif ($line =~ /^\s+(.+)\s*$/) {
			$text = $text . "$gap$1";
			}
		else {
			$self->throw("No regex pattern for this line : $line");
			}
		} # End of while - no more lines.
	
	print "\n\nOffending block of text:\n====================================\n@buffer====================================\n\n";
	
	$self->throw(
		"Shouldn't reach this point - perhaps a problem with the " .
		"regular expression!"
		);

		
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

# Creates an instance of IFeature using supplied data.
my $createFeatureObject = sub {
	
	my ($self, $featureType, $beginArray, $endArray, $orientation, @lines) = @_;
	
	my $gene 			= undef;
	my $colour 			= undef;
	my $proteinId 		= undef;
	my $note 			= undef;
	my $locusTag 		= undef;
	my $translation 	= undef;
	my $organism 		= undef;
	my $strain 			= undef;
	my $molType 		= undef;
	my $dbXref 			= undef;
	my $codonStart 		= undef;
	my $translTable 	= undef; #1 - Standard code. 11 - Bacterial and plant plastid code.
	my $pseudo 			= FALSE;
	my $product 		= undef;
	my $estimatedLength	= undef;
	my $rptFamily		= undef;
	
	my @buffer = @lines;
	
	while (my $line = shift @lines) {
	
		chomp ($line);
		
		#                     /organism="Campylobacter jejuni subsp. jejuni NCTC 11168"
		if ($line =~ /^\s+\/organism=\"(.+)/) {
			$organism = $self->$extractText($1, TRUE, "\"", @lines);
			}
		
		#                     /pseudo
		elsif ($line =~ /^\s+\/pseudo/) {
			$pseudo = TRUE;
			}
		
		# 					/estimated_length=100
		elsif ($line =~ /^\s+\/estimated_length=(\d+)/) {
			$estimatedLength = $1;
			}
		
		#					/rpt_family="LINE2"
		elsif ($line =~ /^\s+\/rpt_family=\"(.+)\"/) {
			$rptFamily = $1;
			}
		
		#                   /strain="RM1221"
		elsif ($line =~ /^\s+\/strain=\"(.+)\"/) {
			$strain = $1;
			}
		
		#                   /mol_type="genomic DNA"
		elsif ($line =~ /^\s+\/mol_type=\"(.+)\"/) {
			$molType = $1;
			}
		#                   /db_xref="taxon:195099"
		elsif ($line =~ /^\s+\/db_xref=\"(.+)\"/) {
			$dbXref = $1;
			}
		
		#                   /codon_start=1
		elsif ($line =~ /^\s+\/codon_start=(\d)/) {
			$codonStart = $1;
			}
		
		#                   /transl_table=11
		elsif ($line =~ /^\s+\/transl_table=(\d+)/) {
			$translTable = $1;
			}
		
		
		#                   /gene="dnaA"
		elsif ($line =~ /^\s+\/gene=\"(.+)\"$/) {
			$gene = $1;
			}
		
		#                   /colour=150 120 150
		elsif ($line =~ /^\s+\/colou{0,1}r=(\d+\s\d+\s\d+)$/) {
			$colour = $1;
			}
		
		#                   /locus_tag="CJE0001"
		elsif ($line =~ /^\s+\/locus_tag=\"(.+)\"/) {
			if (defined $locusTag) {
			
				print "@buffer\n";
			
				$self->throw("locus_tag '$locusTag' being redefined to '$1'");
				}
			$locusTag = $1;
			}
		
		
		#                   /note="identified by similarity to SP:P05648; match to
		#                   protein family HMM PF00308; match to protein family HMM
		#                   TIGR00362"
		elsif ($line =~ /^\s+\/note=\"(.+)\"/) {
			$note = $1;		
			}
		
		
		elsif ($line =~ /^\s+\/note=\"(.+)/) {
			$note = $self->$extractText($1, TRUE, "\"", @lines);
			}
		
		#                   /product="chromosomal replication initiator protein DnaA"
		#                   /note="identified by similarity to SP:P05648; match to
		#                   protein family HMM PF00308; match to protein family HMM
		#                   TIGR00362"
		elsif ($line =~ /^\s+\/product=\"(.+)\"/) {
			$product = $1;
			}
		
		elsif ($line =~ /^\s+\/product=\"(.+)/) {
			$product = $self->$extractText($1, TRUE, "\"", @lines);
			}
		
		
		#                   /protein_id="AAW34498.1"
		elsif ($line =~ /^\s+\/protein_id=\"(.+)\"/) {
			$proteinId = $1;
			}
		
		
		#                   /translation="MNPSQILENLKKELSENEYENYLSNLKFNEKQSKADLLVFNAPNE
		#                   LMAKFIQTKYGKKIAHFYEVQSGNKAIINIQAQSAKQSNKSTKIDIAHIKAQSTILNPS
		#                   FTFDSFVVGDSNKYAYGACKAITHKDKLGKLYNPIFVYGPTGLGKTHLLQAVGNASLEM
		#                   GKKVIYATSENFINDFTSNLKNGSLDKFHEKYRNCDVLLIDDVQFLGKTDKIQEEFFFI
		#                   FNEIKNNDGQIIMTSDNPPNMLKGITERLKSRFAHGIIADITPPQLDTKIAIIRKKCEF
		#                   NDINLSNDIINYIATSLGDNIREIEGIIISLNAYATILGQEITLELAKSVMKDHIKEKK
		#                   ENITIDDILSLVCKEFNIKPSDVKSNKKTQNIVTARRIVIYLARALTALTMPQLANYFE
		#                   MKDHTAISHNVKKITEMIENDGSLKAKIEELKNKILVKSQS"
		elsif ($line =~ /^\s+\/translation=\"(.+)/) {
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
		
	# NOTE: must order location objects - order varies in genbank files - need to
	# be consist, therefore ensure location objects always in ascending order.
	@locations = sort {$a->getStart <=> $b->getStart} @locations;
	
	# Now create feature object from collected data.
	my $featureObject = undef;
	
	# CDS feature.	
	if ($featureType eq "CDS") {
		
		# Must have a locus tag. 
		if (!defined $locusTag) {
			$self->warn("No locus_tag could be found for CDS '$proteinId'.");
			$locusTag="UNDEFINED";
			}
		
		# Note: protein_id used as default id code (accession) for translation
		# (e.g. subsequent sequence objects).  However, sometimes not set.
		# So needs to have a value but warn user of this.
		#if (!defined $proteinId) {
		#	$proteinId = $locusTag || $gene;
		#	$self->warn("CDS without a protein_id.  Will use '$proteinId'.");
		#	}
		
		# 03/03/2009 - be stricter...
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
			-translation 	=> $translation,
			-orientation 	=> $orientation,
			-codonStart 	=> $codonStart,
			-translTable 	=> $translTable,
			-proteinId 		=> $proteinId,
			-locusTag 		=> $locusTag,
			-pseudo 		=> $pseudo,
			-product 		=> $product
			);
		
		}
	
	elsif ($featureType eq "gene") {
		
		$featureObject = Kea::IO::Feature::FeatureFactory->createGene(
			#-gene 			=> $gene,
			#-locations 		=> \@locations,
			#-colour 		=> $colour,
			#-note 			=> $note,
			#-orientation 	=> $orientation,
			#-locusTag 		=> $locusTag
			-gene 			=> $gene,
			-locations 		=> \@locations,
			-colour 		=> $colour,
			-note 			=> $note,
			-translation 	=> $translation,
			-orientation 	=> $orientation,
			-codonStart 	=> $codonStart,
			-translTable 	=> $translTable,
			-proteinId 		=> $proteinId,
			-locusTag 		=> $locusTag,
			-pseudo 		=> $pseudo,
			-product 		=> $product
			);
		
		}
	
	elsif ($featureType eq "tRNA") {
		
		$featureObject = Kea::IO::Feature::FeatureFactory->createtRNA(
			#-gene 			=> $gene,
			#-locations 		=> \@locations,
			#-colour 		=> $colour,
			#-note 			=> $note,
			#-orientation 	=> $orientation
			-gene 			=> $gene,
			-locations 		=> \@locations,
			-colour 		=> $colour,
			-note 			=> $note,
			-translation 	=> $translation,
			-orientation 	=> $orientation,
			-codonStart 	=> $codonStart,
			-translTable 	=> $translTable,
			-proteinId 		=> $proteinId,
			-locusTag 		=> $locusTag,
			-pseudo 		=> $pseudo,
			-product 		=> $product
			);
		
		}
	
	elsif ($featureType eq "mRNA") {
		
		$featureObject = Kea::IO::Feature::FeatureFactory->createmRNA(
			#-gene 			=> $gene,
			#-locations 		=> \@locations,
			#-colour 		=> $colour,
			#-note 			=> $note,
			#-orientation 	=> $orientation
			-gene 			=> $gene,
			-locations 		=> \@locations,
			-colour 		=> $colour,
			-note 			=> $note,
			-translation 	=> $translation,
			-orientation 	=> $orientation,
			-codonStart 	=> $codonStart,
			-translTable 	=> $translTable,
			-proteinId 		=> $proteinId,
			-locusTag 		=> $locusTag,
			-pseudo 		=> $pseudo,
			-product 		=> $product
			);
		
		}
	
	elsif ($featureType eq "source") {
		
		$featureObject = Kea::IO::Feature::FeatureFactory->createSource(
			-organism 		=> $organism,
			-locations 		=> \@locations,
			-strain 		=> $strain,
			-molType 		=> $molType,
			-note 			=> $note,
			-dbXref 		=> $dbXref
			);
		}
	
	# All other features.
	
	elsif ($featureType eq "misc_feature") {
	
		$featureObject = Kea::IO::Feature::FeatureFactory->createMisc(
			#-gene 			=> $gene,
			#-locations 	=> \@locations,
			#-colour 		=> $colour,
			#-note 			=> $note,
			#-orientation 	=> $orientation
			-gene 			=> $gene,
			-locations 		=> \@locations,
			-colour 		=> $colour,
			-note 			=> $note,
			-translation 	=> $translation,
			-orientation 	=> $orientation,
			-codonStart 	=> $codonStart,
			-translTable 	=> $translTable,
			-proteinId 		=> $proteinId,
			-locusTag 		=> $locusTag,
			-pseudo 		=> $pseudo,
			-product 		=> $product
			);
		
		}
	
	elsif ($featureType eq "gap") {
		
		$featureObject = Kea::IO::Feature::FeatureFactory->createGap(
			-locations 			=> \@locations,
			-colour 			=> $colour,
			-note 				=> $note,
			-estimatedLength	=> $estimatedLength
			);
		
		}
	
	elsif ($featureType eq "repeat_region") {
		
		$featureObject = Kea::IO::Feature::FeatureFactory->createRepeatRegion(
			-locations 			=> \@locations,
			-colour 			=> $colour,
			-note 				=> $note,
			-rptFamily			=> $rptFamily
			);
		
		}
	
	elsif ($featureType eq "exon") {
		
		$featureObject = Kea::IO::Feature::FeatureFactory->createExon(
			-locations 			=> \@locations,
			-orientation 		=> $orientation,
			-colour 			=> $colour,
			-note 				=> $note
			);
		
		}
	
	
	else {
	
		$self->throw("Not explicitly accounting for feature '$featureType'...");
		
		$featureObject = Kea::IO::Feature::FeatureFactory->create(
			#-name			=> $featureType,
			#-gene 			=> $gene,
			#-locations 		=> \@locations,
			#-colour 		=> $colour,
			#-note 			=> $note,
			#-orientation 	=> $orientation
			-gene 			=> $gene,
			-locations 		=> \@locations,
			-colour 		=> $colour,
			-note 			=> $note,
			-translation 	=> $translation,
			-orientation 	=> $orientation,
			-codonStart 	=> $codonStart,
			-translTable 	=> $translTable,
			-proteinId 		=> $proteinId,
			-locusTag 		=> $locusTag,
			-pseudo 		=> $pseudo,
			-product 		=> $product
			);
		}
	
	return $featureObject;
	
	}; #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

my $processFeature = sub {

	my ($self, $featureType, $begin, $end, $orientation) = @_;
	
	my @buffer;
	
	# Continue reading lines until end of feature is reached.
	while (my $line = shift @_lines) {
		
		# If line is start of next feature - stop, replace line, and return feature.
		# NOTE assume feature start line is of form FT - 3 spaces - some text - spaces - etc. 
		if (
			#     misc_feature    complement(1640931..1641374)
			$line =~ /^\s{5}[\w\-]/ ||
			$line =~ /^ORIGIN/
			) {
			unshift(@_lines, $line);
			
			return $self->$createFeatureObject($featureType, [$begin], [$end], $orientation, @buffer);
			}
		# Otherwise, store line in buffer.
		else {
			push(@buffer, $line);
			}
		
		}
	
	$self->throw("Shouldn't reach this point!");
	
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
				$self->warn("Start and end locations are the wrong way round: $item");
				} 
			
			$orientation = SENSE;
			push(@startArray, $1);
			push(@endArray, $2);
			}
		
		##===============================================
		elsif ($item =~ /^<(\d+)\.\.(\d+)$/) {
		
			$start = $1;
			$end = $2;
			if ($1 > $2) {
				$start = $2;
				$end = $1;
				$self->warn("Start and end locations are the wrong way round: $item");
				} 
		
			$orientation = SENSE;
			push(@startArray, "<$1");
			push(@endArray, $2);
			}
		
		elsif ($item =~ /^(\d+)\.\.>(\d+)$/) {
		
			$start = $1;
			$end = $2;
			if ($1 > $2) {
				$start = $2;
				$end = $1;
				$self->warn("Start and end locations are the wrong way round: $item");
				} 
			
			$orientation = SENSE;
			push(@startArray, $1);
			push(@endArray, ">$2");
			}
		
		##==============================================
		
		elsif ($item =~ /^complement\((\d+)\.\.(\d+)\)$/) {
			
			$start = $1;
			$end = $2;
			if ($1 > $2) {
				$start = $2;
				$end = $1;
				$self->warn("Start and end locations are the wrong way round: $item");
				} 
			
			$orientation = ANTISENSE;
			push(@startArray, $1);
			push(@endArray, $2);
			
			}
		else {
			$self->throw("Haven't accounted for this pattern: $item");	
			}
		
		}
	
	return (\@startArray, \@endArray, $orientation);
	};

#///////////////////////////////////////////////////////////////////////////////

my $processFeatureWithJoin = sub {

	
	#   CDS             join(66985..67113,67229..67411,67411..67602,67602..67940,
	#                   67942..68203,68205..68278,68277..68504)
	
	#   CDS             join(complement(83654..83893),complement(83292..83654))
	
	#   CDS             join(167050..167295,167297..167794)
	
	#   CDS             join(206063..206308,206308..206691,206724..206939,
	#                   206939..206974,206974..207063,207095..207310,
	#                   207314..207637,207636..207770,207775..207843,
	#                   207843..207980,208012..208203,208203..208337,
	#                   208336..208473,208475..208666,208673..208846,
	#                   208852..208950,208954..209055,209055..209195)
	
	#   CDS             join(complement(268591..268809),complement(267638..268597),
	#                   complement(267516..267629))
	
	
	my $self = shift;
	push(my @buffer, shift);
	
	# Continue reading lines until end of feature is reached.
	while (my $line = shift @_lines) {
		
		# If line is start of next feature - stop, replace line, and stop.
		# NOTE assume feature start line is of form 5 spaces - some text - spaces - etc. 
		if (
			$line =~ m/^\s{5}[\w\-\_]+\s+(join\()*(complement\()*/ ||
			$line =~ m/^ORIGIN/ 
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
	if ($line =~ /^\s{5}([\w\-\_]+)\s+join\((.+)/) {
		$featureType = $1;
		$text = $2;
		}
	else {
		$self->throw("Haven't accounted for this situation: \nline = $line");	
		}
	
	$text = $self->$extractText($text, FALSE, "\\)", @buffer);
	
	my ($startArray, $endArray, $orientation) = $self->$extractCoordsFromText($text);

	
	return $self->$createFeatureObject($featureType, $startArray, $endArray, $orientation, @buffer);
	
	};

#///////////////////////////////////////////////////////////////////////////////

my $getRemainingElementText = sub {

	my $self = shift;
	my $lines = shift;
	
	my @text;
	
	while (my $line = shift(@$lines)) {
	
		# Next element encountered.
		if ($line =~ /^\s{0,2}\w+\s+(.+)$/) {
			# Put line back.
			unshift(@$lines, $line);
			# Return concatenated string.
			return join(" ", @text);
			}
		# Next line of current element encountered.
		elsif ($line =~ /^\s{12}(.+)$/) {
			# Add to buffer.
			push(@text, $1);
			}
	
		}
	
	$self->throw("Unexpectedly reached end of file.");
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub read {
	
	my $self 		= shift;
	my $FILEHANDLE 	= $self->check(shift);
	my $handler		= $self->check(shift, "Kea::IO::GenBank::IReaderHandler");
	
	# Create array of line strings from infile.
	@_lines = <$FILEHANDLE>;
		
	while (my $line = shift @_lines) {
	
		chomp $line;
		
		#LOCUS       AAFL01000001          375136 bp    DNA     linear   BCT 07-JAN-2005
		if ($line =~ /^LOCUS\s{7}(\S+)\s+(\d+)\s+bp\s+(\w+)\s+(\w+)\s+(\w+)\s+(\d+\-\w{3}\-\d{4})/) {
			
			$handler->_nextLocusLine(
				$1,		# Primary accession number,
				$2, 	# Sequence length
				$3,		# molecule type
				$4,		# Topology: 'circular' or 'linear',
				$5,		# taxonomic division.
				$6		# Date.
				);
			
			}
		
		# LOCUS       I 3759208 bp DNA HTG 14-MAY-2009
		elsif ($line =~ /^LOCUS\s+(\S+)\s+(\d+)\s+bp\s+(\w+)\s+(\w+)\s+(\d+\-\w{3}\-\d{4})/) {
			
			#print "$line\n";
			
			$handler->_nextLocusLine(
				$1,		# Primary accession number,
				$2, 	# Sequence length
				$3,		# molecule type
				"unknown",		# Topology: 'circular' or 'linear',
				$4,		# taxonomic division.
				$5		# Date.
				);
			
			}
		
		# DEFINITION
		elsif ($line =~ /^DEFINITION\s+(.+)$/) {
			$handler->_nextDefinition("$1 " . $self->$getRemainingElementText(\@_lines));
			}
		

		# ACCESSION
		elsif ($line =~ /^ACCESSION\s+(\S+)/) {
			$handler->_nextAccessionLine($1);
			}
		
		# VERSION
		elsif ($line =~ /^VERSION\s+\w+\.(\d+)/) {
			$handler->_nextVersionLine($1);
			}
		
		elsif ($line =~ /^VERSION\s+(\S+)/) {
			$handler->_nextVersionLine($1);
			}
		
		
		# PROJECT
		# DBLINK
		#ÊOnly parse one - assume that both contain same data - true?
		# NOTE: FOLLOWING ASSUMES A GENOME PROJECT GENBANK RECORD - REASONABLE???
		elsif ($line =~ /^PROJECT\s+GenomeProject:(\d+)$/) {
			$handler->_nextProjectIdLine($1);
			}
		
		
		# KEYWORDS
		elsif ($line =~ /^KEYWORDS\s+(.+)\.{0,1}$/) {
			$handler->_nextKeywordsLine($1);
			}
		
		# SOURCE
		elsif ($line =~ /^SOURCE\s+(.+)$/) {
			$handler->_nextSourceOrganismLine($1);
			}
		
		# ORGANISM
		elsif ($line =~ /^\s+ORGANISM\s+/) {
			# Ignore first line as will (should?) be identical to source line. 
			$handler->_nextSourcePhylogeny($self->$getRemainingElementText(\@_lines));
			}
		
		# REFERENCE
		elsif ($line =~ /REFERENCE\s+(\d+)\s+/) {
			$handler->_nextReferenceNumberLine($1);
			}
		
		# AUTHORS
		elsif ($line =~ /^\s+AUTHORS\s+(.+)$/) {
			$handler->_nextReferenceAuthors("$1 " . $self->$getRemainingElementText(\@_lines));
			}
		
		# TITLE
		elsif ($line =~ /^\s+TITLE\s+(.+)$/) {
			$handler->_nextReferenceTitle("$1 " . $self->$getRemainingElementText(\@_lines));
			}
		
		# JOURNAL
		elsif ($line =~ /^\s+JOURNAL\s+(.+)$/) {
			$handler->_nextReferenceJournal("$1 " . $self->$getRemainingElementText(\@_lines));
			}
		
		# COMMENT
		elsif ($line =~ /^COMMENT\s+(.+)$/) {
			$handler->_nextComment("$1 " . $self->$getRemainingElementText(\@_lines));
			}
		
		# FEATURES
		#=======================================================================
		
		# Some sort of feature (sense).
		#     CDS             105..263
		elsif ($line =~ m/^\s{5}([\w\-\_]+)\s+(\d+)\.\.(\d+)\s*$/) {
			$handler->_nextFeatureObject(
				$self->$processFeature(
					$1,		# feature type
					$2,		# Begin
					$3,		# End	
					SENSE	# Orientation
					)
				);
			} 
		
		# Some sort of feature (antisense).
		#     gene            complement(290..1018)
		elsif ($line =~ m/^\s{5}([\w\-\_]+)\s+complement\((\d+)\.\.(\d+)\)\s*$/) {
			$handler->_nextFeatureObject(
				$self->$processFeature($1, $2, $3, ANTISENSE)
				);
			}
		
		# Feature with complex coordinates.
		#    gene            join(46424..49000,49002..50156)
		elsif ($line =~ m/^\s{5}([\w\-\_]+)\s+join\(/) {
			my $feature = $self->$processFeatureWithJoin($line);
			$handler->_nextFeatureObject($feature);
			}
		
		
		
		
		
		# SEQUENCE
		#=======================================================================
		
		
		
		#ORIGIN
		elsif ($line =~ /^ORIGIN\s*$/) {
			my $sequence = $self->$getSequence();
			$handler->_nextSequence($sequence);
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

