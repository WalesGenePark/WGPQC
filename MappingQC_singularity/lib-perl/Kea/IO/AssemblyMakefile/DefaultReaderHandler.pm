#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 05/06/2008 10:20:19
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
package Kea::IO::AssemblyMakefile::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::AssemblyMakefile::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::AssemblyMakefile::IReaderHandler);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::IO::AssemblyMakefile::Makefile;
use Kea::IO::AssemblyMakefile::_Contig;
use Kea::IO::AssemblyMakefile::_Position;
use Kea::IO::AssemblyMakefile::_Script;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $makefile = Kea::IO::AssemblyMakefile::Makefile->new("");
	
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

my $privateMethod = sub {
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub _primaryAccession {
	
	my $self = shift;
	my $primaryAccession = shift;
	
	$self->{_makefile}->setPrimaryAccession($primaryAccession);
	
#	print "primary accession = $primaryAccession\n";
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _contigSeparator {
	
	my $self = shift;
	my $contigSeparator = shift;
	
	$self->{_makefile}->setContigSeparator($contigSeparator);
	
	
#	print "contig separator = $contigSeparator\n";
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _referenceDirectory {
	
	my $self = shift;
	my $referenceDirectory = shift;
	
	$self->{_makefile}->setReferenceDirectory($referenceDirectory);
	
#	print "reference directory: $referenceDirectory\n";
	
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub _sourceContigFile {
	
	my $self = shift;
	my $sourceContigFile = shift;
	
	$self->{_makefile}->setSourceContigFile($sourceContigFile);
	
#	print "Source contig file: $sourceContigFile\n";
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _outfileName {
	
	my $self = shift;
	my $outfileName = shift;
	
	$self->{_makefile}->setOutfileName($outfileName);
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextPosition {
	
	my $self 		= shift;
	my $id 			= $self->check(shift);
	my $orientation = $self->checkIsOrientation(shift);
	my $joinToNext = shift || "false"; #ÊMay be undefined.
	
	if ($joinToNext =~ /^t(rue)*$/i) {
		$joinToNext = TRUE;
		}
	elsif ($joinToNext =~ /^f(alse)$/i) {
		$joinToNext = FALSE;
		}
	else {
		$self->throw("Unrecognised option: $joinToNext.");
		}
	
	$self->{_makefile}->getPositionCollection->add(
		Kea::IO::AssemblyMakefile::_Position->new(
			-id 			=> $id,
			-orientation 	=> $orientation,
			-joinToNext		=> $joinToNext
			)
		);
	
#	print "position - $id - $orientation\n";
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextContig {
	
	my $self = shift;
	my $id = $self->check(shift);
	my $note = $self->check(shift);
	my $sequence = $self->check(shift);
	
	$self->{_makefile}->getContigCollection->add(
		Kea::IO::AssemblyMakefile::_Contig->new(
			-id 		=> $id,
			-note 		=> $note,
			-sequence 	=> $sequence
			)
		);
	
#	print "contig - $id\n";
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextScript {
	
	my $self = shift;
	my $name = shift;
	my $description = shift;
	
	$self->{_makefile}->getScriptCollection->add(
		Kea::IO::AssemblyMakefile::_Script->new(
			-name 			=> $name,
			-description 	=> $description
			)
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _bestReference {
	
	my $self = shift;
	my $bestReference = shift;
	
	$self->{_makefile}->setBestReference($bestReference);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getMakefile {
	return shift->{_makefile};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

