#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 21/04/2008 14:26:30
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
package Kea::IO::Gff::_ToHandlerReader;
use Kea::Object;
use Kea::IO::IReader;
our @ISA = qw(Kea::Object Kea::IO::IReader);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

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

#ÊPRIVATE METHODS

my $processFasta = sub {
	
	my $self 		= shift;
	my $FILEHANDLE 	= $self->check(shift);
	my $handler		= $self->check(shift, "Kea::IO::Gff::IReaderHandler");
	
	my $header = undef;
	my $sequence = undef;
	
	while (<$FILEHANDLE>) {
		
		next if /^\s*$/;
		
		if (/^>(.+)$/) {
			
			if (defined $sequence) {
	
				$sequence =~ s/[\s\d]//g;
				
				$handler->_nextHeader($header);
				$handler->_nextSequence($sequence);
				$sequence = undef;
				$header = undef;
				}
		
			$header = $1;
			
			}
		
		else {
			$sequence .= $_;
			}
		
		} # End of while - no more lines to parse.
	
	# Process last sequence.
	$handler->_nextHeader($header);
	$sequence =~ s/[\s\d]//g or
		$self->warn("No sequence for header '$header': $sequence");
	$handler->_nextSequence($sequence);

	}; # End of method.

################################################################################

# PUBLIC METHODS

sub read {

	my $self 		= shift;
	my $FILEHANDLE 	= $self->check(shift);
	my $handler		= $self->check(shift, "Kea::IO::Gff::IReaderHandler");
	
	while (<$FILEHANDLE>) {
	
		# ##gff-version   3
		if (/^##gff-version\t(\d)$/) {
			$handler->_version($1);		
			}
		
		# ##feature-ontology      so.obo
		if (/^##feature-ontology\t(.+)\s*$/) {
			$handler->_featureOntology($1);
			}
		
		# ##attribute-ontology    gff3_attributes.obo
		if (/^##attribute-ontology\t(.+)\s*$/) {
			$handler->_attributeOntology($1);
			}
		
		# ##sequence-region       apidb|TGG_994908        1       1001
		if (/^##sequence-region\t(.+)\t(\d+)\t(\d+)\s*$/) {
			$handler->_nextSequenceRegion(
				$1,	# Id
				$2,	# start
				$3	# end
				);
			}
		
		#apidb|XII       ApiDB   exon    131197  131651  .       +       .       ID=apidb|exon_145.m00001-3;Name=exon;description=exon;size=455;Parent=apidb|rna_145.m00001-1
		# Fields are: <seqname> <source> <feature> <start> <end> <score> <strand> <frame> [attributes] [comments]
		if (/^(.+)\t(.+)\t(.+)\t(\d+)\t(\d+)\t(\d*\.\d*)+\t([\.\-\+])\t([0123\.])\t(.+)$/) {
			
			
			
			$handler->_nextLine(
				$1,	# seqname
				$2,	# source
				$3, # feature / type / name e.g. exon (=CDS), gene (=gene), etc.
				$4,	# start
				$5,	# end
				$6,	# score
				$7,	# strand
				$8,	# frame
				$9	# flexible list of key-value pairs separated by semicolons
				);
			
			}
		
		# Capture simpler entries
		#apidb|XII       ApiDB   exon    131197  131651  .       +       .
		#I       unknown source  1       3759208 .       .       .
		#I       unknown mRNA    1883    1924    .       +       .
		#I       unknown mRNA    1976    1986    .       +       .
		#I       unknown mRNA    2041    2133    .       +       .
		#I       unknown mRNA    2186    2347    .       +       .
		#I       unknown mRNA    2409    2756    .       +       .
		#I       unknown mRNA    2833    2873    .       +       .
		#I       unknown mRNA    2931    2995    .       +       .
		#I       unknown mRNA    3065    3087    .       +       .
		#I       unknown mRNA    3140    3268    .       +       .

		elsif (/^(\S+)\t(\S+)\t(\S+)\t(\d+)\t(\d+)\t(\d*\.\d*)\t([\.\-\+])\t([0123\.])\s*$/) {
			
			
			$self->throw(
				"Does not support gff without attributes.");
			
			#$handler->_nextLine(
			#	$1,	# seqname
			#	$2,	# source
			#	$3, # feature / type / name e.g. exon (=CDS), gene (=gene), etc.
			#	$4,	# start
			#	$5,	# end
			#	$6,	# score
			#	$7,	# strand
			#	$8	# frame
			#	);
			
			
		
			}
		
		if (/^##FASTA$/) {
			$self->$processFasta($FILEHANDLE, $handler);
			}
		
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

# See http://www.sequenceontology.org/gff3.shtml for formatting info.