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
package Kea::IO::GenBank::DefaultReaderHandler;
use Kea::IO::GenBank::IReaderHandler;
use Kea::Object;
our @ISA = qw(Kea::Object Kea::IO::GenBank::IReaderHandler);

use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant FASTA 		=> "fasta";
use constant EMBL 		=> "embl";
use constant UNKNOWN 	=> "unknown";
use constant HASH 		=> "HASH";
use constant ARRAY 		=> "ARRAY";

use Kea::IO::RecordFactory;
use Kea::IO::RecordCollection;
use Kea::Utilities::CDSUtility;
use Kea::Utilities::DNAUtility;
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
	
	# Set dna sequence for each cds.
	my $sequence = $self->{_sequence}; 		
	my @features = @{$self->{_features}}; 
	
	# Create record object.
	my $record = Kea::IO::RecordFactory->createRecord($self->{_primaryAccession});
	
	$record->setSequence (			$sequence					);
	$record->setFeatures (			@features					);
	$record->setVersion (			$self->{_version}			);
	$record->setTopology (			$self->{_topology}			);
	$record->setMoleculeType (		$self->{_moleculeType}		);
	#$record->setDataClass (			$self->{_dataClass}			);
	$record->setTaxonomicDivision (	$self->{_taxonomicDivision}	);
	$record->setExpectedLength (	$self->{_expectedLength}	);
	
	#$record->setAccession (		$self->{_accession}			);
	$record->setVersion (			$self->{_version}			);
	$record->setProjectId (			$self->{_projectId}			)				if (defined $self->{_projectId});
	$record->setKeywords (			@{$self->{_keywords}}		)				if (defined $self->{_keywords});
	$record->setSource (			$self->{_source}			)				if (defined $self->{_source});
	$record->setSourcePhylogeny (	$self->{_sourcePhylogeny}	) 				if (defined $self->{_sourcePhylogeny});
	$record->setComment (			$self->{_comment}			) 				if (defined $self->{_comment});
	
	# NOTE: Treating definition and description as synonymns - yes?
	$record->setDescription (		$self->{_definition}		) 				if (defined $self->{_definition});
	
	
	# Reference (only one catered for at present).
	
	# Assume if number present, rest of ref present.
	if (defined $self->{_referenceNumber}) {
	
		my $authorString 	= $self->{_referenceAuthors};
		my $journalString 	= $self->{_referenceJournal};
		my $titleString		= $self->{_referenceTitle};	
	
		my @authors = split(/\s*;\s*/, $authorString);
		my $authorCollection = Kea::Reference::AuthorCollection->new("");
		foreach my $author (@authors) {
			$authorCollection->add(
				Kea::Reference::AuthorFactory->createSimpleAuthor($author)
				);
			}
		
		$record->getReferenceCollection->add(
			Kea::Reference::ReferenceFactory->createReference(
				-number				=> $self->{_referenceNumber},
				-authorCollection	=> $authorCollection,
				-title				=> $titleString,
				-journal			=> $journalString
				)
			);
	
		}
	
	
	
	
	# In addition, allocate dna sequences to cds features - use this as an
	# opportunity to check that sequence defined by cds feature does actually
	# encode for expected translation extracted from embl file.
	#===========================================================================================
	my $utility = Kea::Utilities::CDSUtility->new(
		-showInformationMessages 	=> FALSE,
		-showWarningMessages 		=> FALSE,
		-showErrorMessages 			=> FALSE,
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
					") is not a CDS length - " . $feature->getLocusTag .
					". Press key to continue..."
					);
				<STDIN>;
				}
			
			
=pod						
			# Translate
			my $translation = $utility->translate(
				-sequence 			=> $cds,
				-ignoreStopCodon 	=> TRUE,
				-strict 			=> FALSE
				);
			
			# Check.
			if ($translation ne $feature->getTranslation) {
			
				# offer user the option to accept or reject.
				print "A discrepency between the quoted and actual translation has been detected:\n";
				
				print "CDS Feature: " . $feature->getLocusTag . ":\n\n";
				
				foreach my $location (@locations) {
					print "===>" . $location->toString . "\n";
					}
				
				print "$cds\n\n";
				
				print "Actual DNA translation:\n$translation\n\n";
				print "Quoted translation:\n" . $feature->getTranslation . "\n\n";
				
				my $answer  = "";
				while ($answer !~ /^(y|yes|n|no|s|skip)$/i) {
					print "Is this ok? ('yes' to accept feature, 'no' to abort, 'skip' to ignore feature): ";
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
	#=============================================================================================
	
	# Empty all member fields.
	$self->{_features} 			= [];
	$self->{_primaryAccession} 	= undef;
	$self->{_topology} 			= undef;
	$self->{_moleculeType} 		= undef;
	$self->{_expectedLength} 	= undef;
	$self->{_version} 			= undef;
	$self->{_dataClass} 		= undef;
	$self->{_taxonomicDivision} = undef;
	#$self->{_accession}			= undef;
	$self->{_version}			= undef;
	$self->{_projectId}			= undef;
	$self->{_keywords}			= undef;
	$self->{_source}			= undef;
	$self->{_sourcePhylogeny}	= undef;
	$self->{_referenceNumber}	= undef;
	$self->{_referenceTitle}	= undef;
	$self->{_referenceJournal}	= undef;
	$self->{_referenceAuthors}	= undef;
	$self->{_comment}			= undef;
	$self->{_definition}		= undef;
	
	# Looks like everything's ok!
	return $record;
	
	
	};

################################################################################

# PUBLIC METHODS

sub _nextLocusLine {
	
	my (
		$self,
		$primaryAccession,		# Primary accession number,
		$length,	 			# Sequence length
		$moleculeType,			# molecule type
		$topology,				# Topology: 'circular' or 'linear',
		$taxonomicDivision,		# Taxonomic division (e.g. BCT).
		$date					# Date.
		) = @_;
	
	$self->{_primaryAccession} 	= $primaryAccession;
	$self->{_topology} 			= $topology;
	$self->{_moleculeType} 		= $moleculeType;
	$self->{_expectedLength} 	= $length;
	$self->{_taxonomicDivision} = $taxonomicDivision;
	
	
	#ÊFields used by embl files but not genbank???
#	$self->{_dataClass} 		= "XXX";
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextAccessionLine {
	
	my $self = shift;
	my $accession = $self->check(shift);
	
	# NOT CURRENTLY STORED - CODE USES PRIMARY ACCESSION ONLY.
	#$self->{_accession} = $accession;
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextVersionLine {
	
	my $self = shift;
	my $version = $self->check(shift);
	
	$self->{_version} = $version;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextDefinition {
	
	my $self = shift;
	my $text = $self->check(shift);
	
	$self->{_definition} = $text;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextProjectIdLine {
	
	my $self = shift;
	my $projectId = $self->check(shift);
	
	$self->{_projectId} = $projectId;
	
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextKeywordsLine {
	
	my $self = shift;
	my $text = $self->check(shift);
	
	my @keywords = split(/\s*;\s*/, $text);
	
	$self->{_keywords} = \@keywords;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextSourceOrganismLine {
	
	my $self = shift;
	my $text = $self->check(shift);
	
	$self->{_source} = $text;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextSourcePhylogeny {
	
	my $self = shift;
	my $text = $self->check(shift);
	
	$self->{_sourcePhylogeny} = $text;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextComment {
	
	my $self = shift;
	my $text = $self->check(shift);
	
	$self->{_comment} = $text;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextReferenceNumberLine {
	
	my $self = shift;
	my $number = $self->checkIsInt(shift);
	
	$self->{_referenceNumber} = $number;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextReferenceTitle {
	
	my $self = shift;
	my $text = $self->check(shift);
	
	$self->{_referenceTitle} = $text;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextReferenceJournal {
	
	my $self = shift;
	my $text = $self->check(shift);
	
	$self->{_referenceJournal} = $text;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextReferenceAuthors {
	
	my $self = shift;
	my $text = $self->check(shift);
	
	$self->{_referenceAuthors} = $text;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextSequence {
	
	my $self 		= shift;
	my $sequence 	= $self->check(shift);
	
	my $length = $self->{_expectedLength};
	
	if (length($sequence) != $length) {
		$self->warn(
			"Expected length ($length) does not correspond " .
			"to actual length (" . length($sequence) . ")!"
			);
		}
	
	# Ensure sequence is uppercase.
	$sequence =~ tr/a-z/A-Z/;
	
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

## Purpose		: Returns a Record object encapsulating the genbank file.
sub getRecord {

	my $self = shift;
	
	my @records = @{$self->{_records}};
	
	if (@records > 1) {
		$self->throw("More than one record - use getRecordCollection().");
		}
	
	return $records[0];
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getRecordCollection {
	
	my $self = shift;
	
	my @records = @{$self->{_records}};
	
	my $recordCollection = Kea::IO::RecordCollection->new();
	
	foreach my $record (@records) {
		$recordCollection->add($record);
		}
	
	return $recordCollection;
	
	} #ÊEnd of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

