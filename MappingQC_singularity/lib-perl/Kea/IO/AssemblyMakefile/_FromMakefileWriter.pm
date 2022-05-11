#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 05/06/2008 14:04:00
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
package Kea::IO::AssemblyMakefile::_FromMakefileWriter;
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

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	my $makefile =
		Kea::Object->check(
			shift,
			"Kea::IO::AssemblyMakefile::Makefile"
			);
	
	my $self = {
		_makefile => $makefile
		};
	
	bless(
		$self,
		$className
		);
	
	return $self;
	
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $formatSequence = sub {

	my $self = shift;
	my $sequence = shift;
	
	my $text = "\n";
	
	for (my $i = 0; $i < length($sequence); $i = $i+60) {
		$text .= substr($sequence, $i, 60) . "\n";
		}
	
	return $text;
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub write {

	my $self 		= shift;
	my $FILEHANDLE	= shift;
	my $makefile 	= $self->{_makefile};
	
	print $FILEHANDLE "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
	print $FILEHANDLE "<!-- assembly makefile - DO NOT EDIT -->\n\n";
	
	print $FILEHANDLE "<makefile>\n\n";
	
	print $FILEHANDLE "<!-- General information -->\n";
	
	print $FILEHANDLE
		"<primary_accession id=\"" .  $makefile->getPrimaryAccession . "\"/>\n";
	
	print $FILEHANDLE
		"<contig_separator sequence=\"" . $makefile->getContigSeparator . "\"/>\n";	
	
	print $FILEHANDLE
		"<reference_directory uri=\"" . $makefile->getReferenceDirectory . "\"/>\n";
		
	print $FILEHANDLE
		"<best_reference uri=\"" . $makefile->getBestReference . "\"/>\n";	
	
	print $FILEHANDLE
		"<source_contig_file uri=\"" .	$makefile->getSourceContigFile . "\"/>\n";
	
	print $FILEHANDLE
		"<outfile uri=\"" . $makefile->getOutfileName . "\"/>\n";
	
	print $FILEHANDLE "\n";
	

	print $FILEHANDLE "<!-- additional scripts to run -->\n";
	print $FILEHANDLE "<scripts>\n";
	for (my $i = 0; $i < $makefile->getScriptCollection->getSize; $i++) {
		my $script = $makefile->getScriptCollection->get($i);
		print $FILEHANDLE "\t<script name=\"" . $script->getName  . "\" description=\"" . $script->getDescription . "\"/>\n";
		}
	print $FILEHANDLE "</scripts>\n\n";
	
	print $FILEHANDLE "<!-- All data relating to sequence position and orientation goes here -->\n";
	
	print $FILEHANDLE "<positions>\n";
	for (my $i = 0; $i < $makefile->getPositionCollection->getSize; $i++) {
		my $position = $makefile->getPositionCollection->get($i);
		print $FILEHANDLE
			"\t<position id=\"" .
			$position->getId .
			"\" orientation=\"" .
			$position->getOrientation . 
			"\"/>\n";
		}
	print $FILEHANDLE "</positions>\n\n";
	
	print $FILEHANDLE "<!-- Sequence data and associated metadata -->\n";
	
	print $FILEHANDLE "<data>\n\n";
	
	for (my $i = 0; $i < $makefile->getContigCollection->getSize; $i++) {
		my $contig = $makefile->getContigCollection->get($i);
		
		print $FILEHANDLE "<contig id=\"" . $contig->getId . "\">\n";
		print $FILEHANDLE "<note>" . $contig->getNote . "</note>\n";
		print $FILEHANDLE "<sequence>" . $self->$formatSequence($contig->getSequence) . "</sequence>\n";
		print $FILEHANDLE "</contig>\n\n";
		
		}
	
	print $FILEHANDLE "</data>\n\n";
	
	print $FILEHANDLE "</makefile>\n";
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

