#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 05/06/2008 13:46:45
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
package Kea::IO::AssemblyMakefile::MakefileItemCollection;
use Kea::Object;
use Kea::ICollection;
our @ISA = qw(Kea::Object Kea::ICollection);

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
	my $overallId = shift || "unknown";
	
	my $self = {
		_overallId 	=> $overallId,
		_array 		=> []
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

sub getSourceContigFile {
	return shift->{_sourceContigFile};
	} # End of method. 

#///////////////////////////////////////////////////////////////////////////////

sub setSourceContigFile {
	my $self = shift;
	my $sourceContigFile = $self->checkIsFile(shift);
	$self->{_sourceContigFile} = $sourceContigFile;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setReferenceDirectory {
	my $self = shift;
	my $referenceDirectory = $self->checkIsDir(shift);
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

sub getOverallId {
	return shift->{_overallId};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setOverallId {

	my $self = shift;
	my $id = $self->check(shift);
	
	$self->{_overallId} = $id;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasOverallId {
	
	my $self = shift;
	
	if (defined $self->{_overallId}) {
		return TRUE;
		}
	else {
		return FALSE;
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSize {
	return scalar(@{shift->{_array}});
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub get {
	
	my $self 	= shift;
	my $i 		= $self->checkIsInt(shift);

	return $self->{_array}->[$i];
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLast {
	
	my $self = shift;
	return $self->{_array}->[$self->getSize - 1];
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAll {
	return @{shift->{_array}};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub add {

	my $self = shift;
	my $object = $self->check(shift, "Kea::IO::AssemblyMakefile::IMakefileItem");
	
	push(
		@{$self->{_array}},
		$object
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub isEmpty {
	
	my $self = shift;
	
	if ($self->getSize == 0) {
		return TRUE;
		}
	else {
		return FALSE;
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {

	my $self = shift;
	
	my $text = $self->getOverallId . "\n";
	
	my $primaryAccession = $self->getPrimaryAccession;
	my $contigSeparator = $self->getContigSeparator;
	my $referenceDirectory = $self->getReferenceDirectory;
	
	$text .= "Primary accession: $primaryAccession\n";
	$text .= "Contig separator: $contigSeparator\n";
	$text .= "Reference directory: $referenceDirectory\n";
	
	foreach my $object (@{$self->{_array}}) {
		$text = $text . $object->toString . "\n";
		}
	
	return $text;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

