#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 06/03/2008 16:03:44 
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
package Kea::IO::Mummer::ShowAligns::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::Mummer::ShowAligns::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::Mummer::ShowAligns::IReaderHandler);

## Purpose		: 

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use Kea::Alignment::Mummer::MummerAlignmentCollection;
use Kea::Alignment::Mummer::MummerAlignmentFactory;
use Kea::IO::Location;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $mummerAlignmentCollection =
		Kea::Alignment::Mummer::MummerAlignmentCollection->new;
	
	my $self = {
		_currentMummerAlignment 	=> undef,
		_mummerAlignmentCollection 	=> $mummerAlignmentCollection
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

sub _referencePath {

	my $self = shift;
	my $path = $self->check(shift);
	
	$self->{_mummerAlignmentCollection}->setReferenceFilePath($path);

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _queryPath {

	my $self = shift;
	my $path = $self->check(shift);
	
	$self->{_mummerAlignmentCollection}->setQueryFilePath($path);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _referenceHeaderTag {
	
	my $self = shift;
	my $id = $self->check(shift);
	
	$self->{_mummerAlignmentCollection}->setReferenceId($id);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _queryHeaderTag {
	
	my $self = shift;
	my $id = $self->check(shift);
	
	$self->{_mummerAlignmentCollection}->setQueryId($id);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextBeginAlignmentLine {
	
	my $self = shift;
	my $referenceOrientation 	= shift;	# Reference orientation (+ or -)
	my $referenceFrame			= shift;	# Reference frame
	my $referenceStart 			= shift;	# Reference start
	my $referenceEnd			= shift;	# Reference end
	my $queryOrientation		= shift; 	# Query orientation
	my $queryFrame				= shift;	# query frame
	my $queryStart				= shift;	# Query start
	my $queryEnd				= shift;	# Query end.
	
	
	my $referenceLocation;
	if ($referenceOrientation =~ /^-/ && $referenceStart > $referenceEnd) {
		$referenceLocation =
			Kea::IO::Location->new(
				$referenceEnd,
				$referenceStart
				);	
		}
	elsif ($referenceOrientation =~ /^\+/ && $referenceStart < $referenceEnd) {
		$referenceLocation =
			Kea::IO::Location->new(
				$referenceStart,
				$referenceEnd
				);	
		}
	else {
		$self->throw(
			"Query location ($referenceStart..$referenceEnd) does not coincide " .
			"with orientation: $referenceOrientation."
			);
		}
	
	
	my $queryLocation;
	if ($queryOrientation =~ /^-/ && $queryStart > $queryEnd) {
		$queryLocation =
			Kea::IO::Location->new(
				$queryEnd,
				$queryStart
				);	
		}
	elsif ($queryOrientation =~ /^\+/ && $queryStart < $queryEnd) {
		$queryLocation =
			Kea::IO::Location->new(
				$queryStart,
				$queryEnd
				);	
		}
	else {
		$self->throw(
			"Query location ($queryStart..$queryEnd) does not coincide " .
			"with orientation: $queryOrientation."
			);
		}
	
	
	
	my $referenceId = $self->{_mummerAlignmentCollection}->getReferenceId;
	my $queryId		= $self->{_mummerAlignmentCollection}->getQueryId;
	
	my $mummerAlignment =
		Kea::Alignment::Mummer::MummerAlignmentFactory->createMummerAlignment(
			-referenceOrientation	=> $referenceOrientation,
			-referenceFrame			=> $referenceFrame,
			-referenceLocation		=> $referenceLocation,
			-queryOrientation		=> $queryOrientation,
			-queryFrame				=> $queryFrame,
			-queryLocation			=> $queryLocation,
			-referenceId			=> $referenceId,
			-queryId				=> $queryId
			);
	
	$self->{_currentMummerAlignment} = $mummerAlignment;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextEndAlignmentLine {
	
	my $self = shift;
	my $referenceOrientation 	= shift;	# Reference orientation (+ or -)
	my $referenceFrame			= shift;	# Reference frame
	my $referenceStart 			= shift;	# Reference start
	my $referenceEnd			= shift;	# Reference end
	my $queryOrientation		= shift; 	# Query orientation
	my $queryFrame				= shift;	# query frame
	my $queryStart				= shift;	# Query start
	my $queryEnd				= shift;	# Query end.
	
	# Check that these values correspond to those stored at beginning.
	my $mummerAlignment = $self->{_currentMummerAlignment};
	
	my $referenceLocation;
	if ($referenceOrientation =~ /^-/ && $referenceStart > $referenceEnd) {
		$referenceLocation =
			Kea::IO::Location->new(
				$referenceEnd,
				$referenceStart
				);	
		}
	elsif ($referenceOrientation =~ /^\+/ && $referenceStart < $referenceEnd) {
		$referenceLocation =
			Kea::IO::Location->new(
				$referenceStart,
				$referenceEnd
				);	
		}
	else {
		$self->throw(
			"Query location ($referenceStart..$referenceEnd) does not coincide " .
			"with orientation: $referenceOrientation."
			);
		}
	
	
	my $queryLocation;
	if ($queryOrientation =~ /^-/ && $queryStart > $queryEnd) {
		$queryLocation =
			Kea::IO::Location->new(
				$queryEnd,
				$queryStart
				);	
		}
	elsif ($queryOrientation =~ /^\+/ && $queryStart < $queryEnd) {
		$queryLocation =
			Kea::IO::Location->new(
				$queryStart,
				$queryEnd
				);	
		}
	else {
		$self->throw(
			"Query location ($queryStart..$queryEnd) does not coincide " .
			"with orientation: $queryOrientation."
			);
		}
	
	
	if ($referenceOrientation ne $mummerAlignment->getReferenceOrientation) {
		$self->throw(
			"BEGIN and END mismatch: Reference orientation " .
			$mummerAlignment->getReferenceOrientation . 
			" vs $referenceOrientation."
			);
		}
	
	if ($referenceFrame	ne $mummerAlignment->getReferenceFrame) {
		$self->throw(
			"BEGIN and END mismatch: Reference frame " .
			$mummerAlignment->getReferenceFrame .
			" vs $referenceFrame."
			);
		}
	
	if (!$referenceLocation->equals($mummerAlignment->getReferenceLocation)) {
		$self->throw(
			"BEGIN and END mismatch: Reference location " .
			$mummerAlignment->getReferenceLocation->toString .
			" vs " . $referenceLocation->toString . "."
			);
		}
	
	if ($queryOrientation ne $mummerAlignment->getQueryOrientation) {
		$self->throw(
			"BEGIN and END mismatch: Query orientation " .
			$mummerAlignment->getQueryOrientation .
			" vs $queryOrientation."
			);
		}
	
	if ($queryFrame	ne $mummerAlignment->getQueryFrame) {
		$self->throw(
			"BEGIN and END mismatch: Query frame " .
			$mummerAlignment->getQueryFrame .
			" vs $queryFrame."
			);
		}
	
	if (!$queryLocation->equals($mummerAlignment->getQueryLocation)) {
		$self->throw(
			"BEGIN and END mismatch: Query location " .
			$mummerAlignment->getQueryLocation->toString .
			" vs " . $queryLocation->toString . "."
			);
		}
	
	$self->{_mummerAlignmentCollection}->add(
		$mummerAlignment
		);
	
	$self->{_currentMummerAlignment} = undef;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextReferenceSequence {
	
	my $self = shift;
	my $sequence = $self->check(shift);
	
	$self->{_currentMummerAlignment}->_setReferenceSequence($sequence);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextQuerySequence {
	
	my $self = shift;
	my $sequence = $self->check(shift);
	
	$self->{_currentMummerAlignment}->_setQuerySequence($sequence);
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getMummerAlignmentCollection {
	
	my $self = shift;
	
	my $mummerAlignmentCollection = $self->{_mummerAlignmentCollection};
	
	#ÊCheck that all fields filled.
	if (
		defined $mummerAlignmentCollection->getReferenceFilePath 	&&
		defined $mummerAlignmentCollection->getQueryFilePath		&&
		defined $mummerAlignmentCollection->getReferenceId			&&
		defined $mummerAlignmentCollection->getQueryId				&&
		$mummerAlignmentCollection->getSize > 0
		) {
		return $mummerAlignmentCollection;	
		}
	
	else {
		$self->throw(
			"Incomplete MUMmer alignment collection."
			);
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

