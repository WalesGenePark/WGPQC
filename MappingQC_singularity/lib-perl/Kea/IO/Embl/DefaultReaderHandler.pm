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
package Kea::IO::Embl::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::Embl::IReaderHandler; 
our @ISA = qw(Kea::Object Kea::IO::Embl::IReaderHandler);

use strict;
use warnings;
use File::Copy;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";

use Kea::IO::RecordFactory;
use Kea::Utilities::DNAUtility;
use Kea::Utilities::CDSUtility;
use Kea::IO::RecordCollection;
use Kea::IO::Feature::FeatureCollection;
use Kea::Properties;
use Kea::Reference::ReferenceFactory;
use Kea::Reference::AuthorFactory;
use Kea::Reference::AuthorCollection;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	my $className = shift;
	
	my $self = {
		_features 	=> [],
		_record 	=> []
		};
	bless(
		$self,
		$className
		);
	return $self;
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $createRecord = sub { 
	
	my $self = shift;
	
	my $sequence = $self->{_sequence};
	
	my @features = @{$self->{_features}};
	
	# Create record object.
	my $record =
		Kea::IO::RecordFactory->createRecord(
			$self->{_primaryAccession}
			);
	
	# Store collected data.	
	$record->setSequence($sequence);
	$record->setFeatures(@features);
	$record->setVersion($self->{_version});
	$record->setTopology($self->{_topology});
	$record->setMoleculeType($self->{_moleculeType});
	$record->setDataClass($self->{_dataClass});
	$record->setTaxonomicDivision($self->{_taxonomicDivision});
	$record->setExpectedLength($self->{_expectedLength});
	$record->setProjectId($self->{_projectId}) if (defined $self->{_projectId});
	
	$record->setDescription(join(" ", @{$self->{_description}})) if (defined $self->{_description});;
	$record->setComment(join(" ", @{$self->{_comment}})) if (defined $self->{_comment});
	$record->setSourcePhylogeny(join(" ", @{$self->{_sourcePhylogeny}})) if (defined $self->{_sourcePhylogeny});
	
	# Reference (only one catered for at present).
	
	# Assume if number present, rest of ref present.
	if (defined $self->{_referenceAuthors}) {
	
		my $authorString 	= join(" ", @{$self->{_referenceAuthors}});
		my $journalString 	= join(" ", @{$self->{_referenceJournal}});
		my $titleString		= join(" ", @{$self->{_referenceTitle}});	
	
		my @authors = split(/\s*;\s*/, $authorString);
		my $authorCollection = Kea::Reference::AuthorCollection->new("");
		foreach my $author (@authors) {
			$authorCollection->add(
				Kea::Reference::AuthorFactory->createSimpleAuthor($author)
				);
			}
		
		$record->getReferenceCollection->add(
			Kea::Reference::ReferenceFactory->createReference(
				-number	=> $self->{_referenceNumber},
				-authorCollection => $authorCollection,
				-title => $titleString,
				-journal => $journalString
				)
			);
	
		}
	
		
	
	$record->setKeywords(@{$self->{_keywords}}) if (defined $self->{_keywords});
	$record->setSource($self->{_source}) if (defined $self->{_source});
	
	
	# In addition, allocate dna sequences to cds features - use this as an
	# opportunity to check that sequence defined by cds feature does actually
	# encode for expected translation extracted from embl file.
	#===========================================================================
	my $utility = Kea::Utilities::CDSUtility->new(
		-showInformationMessages	=> FALSE,
		-showWarningMessages 		=> FALSE,
		-showErrorMessages 		=> FALSE,
		-informationMessagesToLog 	=> FALSE
		);
	
	foreach my $feature (@features) {
		if ($feature->getName eq "CDS") {
		
			# No DNA sequence for pseudo.
			if ($feature->isPseudo) {next;}
			
			my @locations = $feature->getLocations;
			
			
			my $cds = "";
			foreach my $location (@locations) {
				$cds = $cds . $record->getSubsequenceAt($location, SENSE);
				}
			if ($feature->getOrientation eq ANTISENSE) {
				$cds = Kea::Utilities::CDSUtility->getReverseComplement($cds);
				}
			
			# 24/03/2009 - code replaces below - no longer checking translation
			# due to complication of truncated sequences (e.g.
			# join(280..720,779..>1142)).  Not worth coding for at this stage.
			$feature->setDNASequence($cds);
			
			if (!$utility->hasSensibleLength($cds)) {
				$self->warn(
					"Gene length (" . length($cds) .
					") is not a CDS length - " . $feature->getLocusTag  .
					". Press key to continue..."
					);
				}
			
			
=pod			
			# Check that specified sequence length is sensible for translation
			my $translation = "null";
			if ($utility->hasSensibleLength($cds)) {
				
				# ok to translate
				$translation = $utility->translate(
					-sequence 			=> $cds,
					-ignoreStopCodon 	=> TRUE,
					-strict 			=> FALSE
					);
			
				}
			
			else {
				
				print $feature->toString . "\n";
				
				$self->warn(
					
					"Gene length (" . length($cds) .
					") is not a CDS length!"
					);
				}
			
			
			

			
			# Check.
			
			if (!defined $feature->getTranslation) {
				$feature->setTranslation("");
				}
	
			if (
				$translation ne $feature->getTranslation
				&&
				Kea::Properties->getProperty("warnings") ne "off"
				) {
			
				# offer user the option to accept or reject.
				print
					"A discrepency between the quoted and actual translation " .
					"has been detected:\n";
				
				print "CDS Feature: " . $feature->getLocusTag . ":\n\n";
				
				foreach my $location (@locations) {
					print "Location: " . $location->toString . "\n";
					}
				
				print "$cds\n\n";
				
				print "Actual DNA translation:\n$translation\n\n";
				print "Quoted translation:\n" . $feature->getTranslation . "\n\n";
				
				my $answer  = "";
				while ($answer !~ /^(y|yes|n|no|s|skip)$/i) {
					print
						"Is this ok? ('yes' to accept feature, 'no' to abort, " .
						"'skip' to ignore feature): ";
					$answer = <STDIN>;
					}
					
				if ($answer =~ /^(y|yes)$/i) {
					$feature->setDNASequence($cds);
					print "Feature accepted with quoted translation.\n";
					}
				elsif ($answer =~ /^(n|no$)/i) {
					print "Suit yourself.\n";
					$self->throw("Incorrect dna sequence for feature");
					}
				elsif ($answer =~ /^(s|skip)$/i) {
					$record->deleteFeature($feature);
					print "Feature will be ignored.\n";
					}
					
				
				}
			else {
				# Set dna.
				$feature->setDNASequence($cds);
				}
		
=cut			
			}	
		}
	#===========================================================================
	
	# Looks like everything's ok!

	
	# Empty all member fields.
	$self->{_features} 			= [];
	$self->{_primaryAccession} 	= undef;
	$self->{_topology} 			= undef;
	$self->{_moleculeType} 		= undef;
	$self->{_expectedLength} 	= undef;
	$self->{_version} 			= undef;
	$self->{_dataClass} 		= undef;
	$self->{_taxonomicDivision} = undef;
	$self->{_projectId} 		= undef;
	$self->{_description}		= undef;
	$self->{_comment}			= undef;
	$self->{_sourcePhylogeny}	= undef;
	$self->{_keywords}			= undef;
	$self->{_source}			= undef;
	$self->{_referenceNumber}	= undef;
	$self->{_referenceTitle}	= undef;
	$self->{_referenceJournal}	= undef;
	$self->{_referenceAuthors}	= undef;
	
	return $record;
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub _nextIDLine {
	my (
		$self,
		$primaryAccession,	# primary accession number
		$version, 		# Sequence version number
		$topology, 		# Topology: 'circular' or 'linear'
		$moleculeType,		# Molecule type
		$dataClass,		# Data class
		$taxonomicDivision,	# Taxonomic division
		$length			# Sequence length
		) = @_;
	
	$self->{_primaryAccession}	= $primaryAccession;
	$self->{_version} 		= $version;
	$self->{_topology} 		= $topology;
	$self->{_moleculeType} 		= $moleculeType;
	$self->{_dataClass} 		= $dataClass;
	$self->{_taxonomicDivision} 	= $taxonomicDivision;
	$self->{_expectedLength} 	= $length;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextAccessionLine {
	my ($self, $accession) = @_;
	$self->{_accession} = $accession;  #ÊNOTE <-----------------------------------------NOT NECESSARILY THE SAME AS PRIMARY ACCESSION ABOVE
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# NOTE: Concatenating description here rather than within reader - probably
# better appraoch, but not consistent with some other methods! May need redesign.
sub _nextDescriptionLine {
	
	my $self = shift;
	my $text = $self->check(shift);
	
	push(@{$self->{_description}}, $text);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# NOTE: Concatenating comment here rather than within reader - probably
# better appraoch, but not consistent with some other methods! May need redesign.
sub _nextCommentLine {
	
	my $self = shift;
	my $text = $self->check(shift);
	
	push(@{$self->{_comment}}, $text);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# NOTE: Concatenating text here rather than within reader - probably
# better appraoch, but not consistent with some other methods! May need redesign.
sub _nextSourcePhylogenyLine {

	my $self = shift;
	my $text = $self->check(shift);
	
	push(@{$self->{_sourcePhylogeny}}, $text);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# NOTE: only accommodating one ref to record at present. 
sub _nextReferenceNumberLine {
	
	my $self = shift;
	my $text = $self->check(shift);
	
	$self->{_referenceNumber} = $text;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# NOTE: only accommodating one ref to record at present. 
sub _nextReferenceJournalLine {
	
	my $self = shift;
	my $text = $self->check(shift);
	
	push(@{$self->{_referenceJournal}}, $text);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# NOTE: only accommodating one ref to record at present.
sub _nextReferenceTitleLine {
	
	my $self = shift;
	my $text = $self->check(shift);
	
	push(@{$self->{_referenceTitle}}, $text);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# NOTE: only accommodating one ref to record at present.
sub _nextReferenceAuthorLine {
	
	my $self = shift;
	my $text = $self->check(shift);
	
	push(@{$self->{_referenceAuthors}}, $text);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextSourceOrganismLine {
	
	my $self = shift;
	my $text = $self->check(shift);
	
	$self->{_source} = $text;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextKeywordsLine {
	
	my $self = shift;
	my $text = $self->check(shift);
	
	my @keywords = split(/\s*;\s*/, $text);
	
	$self->{_keywords} = \@keywords;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextProjectId {
	
	my $self = shift;
	my $projectId = shift;
	
	$self->{_projectId} = $projectId;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _countCanonicalBases {
	
        my $seq = shift;
	
	my %baseCount;
	
	$baseCount{'other'} = 0;
	
	
	for (my $i = 0; $i < length($$seq); $i++) {
		
		my $base = substr($$seq, $i, 1);
		
		$baseCount{'other'}++ if $base !~ /[ACGT]/;
		$baseCount{$base}++;
				
		}
	return \%baseCount;	
		
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextSequence {
	my (
		$self,
		$length,
		$As,
		$Cs,
		$Gs,
		$Ts,
		$others,
		$sequence
		) = @_;
	
	# Ensure working with the same case.	
	$sequence = uc($sequence);

	my $baseCount = _countCanonicalBases(\$sequence);

	
	# Check:
	#my @counts = Kea::Utilities::DNAUtility->countCanonicalBases($sequence);
	
	if ($As != $baseCount->{'A'}) {
		$self->warn(
			"Expected ($As) and actual ($baseCount->{'A'}) counts of A do not match!"
			);
		}
	
	if ($Cs != $baseCount->{'C'}) {
		$self->warn(
			"Expected ($Cs) and actual ($baseCount->{'C'}) counts of C do not match!"
			);
		}
	
	if ($Gs != $baseCount->{'G'}) {
		$self->warn(
			"Expected ($Gs) and actual ($baseCount->{'G'}) counts of G do not match!"
			);
		}
	
	if ($Ts != $baseCount->{'T'}) {
		$self->warn(
			"Expected ($Ts) and actual ($baseCount->{'T'}) counts of T do not match!"
			);
		}
	
	if ($others != $baseCount->{'other'}) {
		$self->warn(
			"Expected ($others) and actual ($baseCount->{'other'}) counts of " .
			"non-canonical bases do not match!"
			);
		}
	
	if (length($sequence) != $length) {
		$self->warn(
			"Expected length ($length) does not correspond to actual length (" .
			length($sequence) . ")!"
			);
		}
	
	# Already done above!
	#$sequence =~ tr/a-z/A-Z/;
	
	$self->{_sequence} = $sequence;
	
	# All data should now haven been collected for this record, so create object.
	push(
		@{$self->{_records}},
		$self->$createRecord # << RECORD CREATED FROM COLLECTED DATA.
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextFeatureObject {
	
	my $self 	= shift;
	my $feature = $self->check(shift, "Kea::IO::Feature::IFeature");
	
	push(@{$self->{_features}}, $feature);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getRecord {

	my $self 	= shift;
	
	# DEBUGGING
	if (!defined $self->{_records}) {
		$self->throw("Undefined _records - check file format is embl!");
		}
	
	my @records = @{$self->{_records}};
	
	if (@records > 1) {
		$self->throw("More than one record - use getRecordCollection().");
		}
	
	return $records[0];
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getRecordCollection {
	
	my $self = shift;
	
	# DEBUGGING
	if (!defined $self->{_records}) {
		$self->throw("Undefined _records - check file format is embl!");
		}
	
	my @records = @{$self->{_records}};
	
	my $recordCollection = Kea::IO::RecordCollection->new();
	
	foreach my $record (@records) {
		$recordCollection->add($record);
		}
	
	return $recordCollection;
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getFeatureCollection {
	
	my $self = shift;
	my $features = $self->{_features};
	
	my $featureCollection = Kea::IO::Feature::FeatureCollection->new("null");
	
	for (my $i = 0; $i < @$features; $i++) {
	
		$featureCollection->add($features->[$i]);
		}
	
	if ($featureCollection->getSize == 0) {
		$self->throw("No features available.");
		}
	
	return $featureCollection;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

