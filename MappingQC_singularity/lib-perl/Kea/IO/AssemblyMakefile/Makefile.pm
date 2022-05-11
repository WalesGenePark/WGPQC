#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 06/06/2008 13:17:51
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
package Kea::IO::AssemblyMakefile::Makefile;
use Kea::Object;
our @ISA = qw(Kea::Object);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::IO::AssemblyMakefile::ContigCollection;
use Kea::IO::AssemblyMakefile::PositionCollection;
use Kea::IO::AssemblyMakefile::ScriptCollection;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $positionCollection = Kea::IO::AssemblyMakefile::PositionCollection->new("");
	my $contigCollection = Kea::IO::AssemblyMakefile::ContigCollection->new("");
	my $scriptCollection = Kea::IO::AssemblyMakefile::ScriptCollection->new("");
	
	my $self = {
		_positionCollection => $positionCollection,
		_contigCollection 	=> $contigCollection,
		_scriptCollection	=> $scriptCollection
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

sub getScriptCollection {
	return shift->{_scriptCollection};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSourceContigFile {
	return shift->{_sourceContigFile};
	} # End of method. 

#///////////////////////////////////////////////////////////////////////////////

sub setSourceContigFile {
	my $self = shift;
	my $sourceContigFile = $self->check(shift);
	$self->{_sourceContigFile} = $sourceContigFile;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setReferenceDirectory {
	my $self = shift;
	my $referenceDirectory = $self->check(shift);
	$self->{_referenceDirectory} = $referenceDirectory;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getReferenceDirectory {
	return shift->{_referenceDirectory};
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub setPrimaryAccession {
	my $self = shift;
	my $primaryAccession = $self->check(shift);
	$self->{_primaryAccession} = $primaryAccession;
	} # End of method.

sub getPrimaryAccession {
	return shift->{_primaryAccession};
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub setContigSeparator {
	my $self = shift;
	my $contigSeparator = $self->check(shift);
	$self->{_contigSeparator} = $contigSeparator;
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getContigSeparator {
	return shift->{_contigSeparator};
	} # End of method.


#///////////////////////////////////////////////////////////////////////////////

sub getPositionCollection {
	return shift->{_positionCollection};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setPositionCollection {
	my $self = shift;
	my $positionCollection = shift;
	$self->{_positionCollection} = $positionCollection;
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getContigCollection {
	return shift->{_contigCollection};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setContigCollection {
	my $self = shift;
	my $contigCollection = shift;
	$self->{_contigCollection} = $contigCollection;
	} # End of method. 

#///////////////////////////////////////////////////////////////////////////////

sub getOutfileName {
	return shift->{_outfileName};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setOutfileName {
	my $self = shift;
	my $outfileName = $self->check(shift);
	$self->{_outfileName} = $outfileName;
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub getBestReference {
	return shift->{_bestReference};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setBestReference {
	my $self = shift;
	my $bestReference = $self->check(shift);
	$self->{_bestReference} = $bestReference;
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

