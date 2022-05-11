#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 08/03/2008 18:03:47 
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
package Kea::IO::Act::Crunch::_FromMummerAlignmentCollectionWriter;
use Kea::Object;
use Kea::IO::IWriter;
our @ISA = qw(Kea::Object Kea::IO::IWriter);

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use Kea::Phylogeny::Distance::ModelFactory;
use Kea::Number;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $mummerAlignmentCollection =
		Kea::Object->check(
			shift,
			"Kea::Alignment::Mummer::MummerAlignmentCollection"
			);
	
	my $self = {
		_mummerAlignmentCollection => $mummerAlignmentCollection
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

sub write {

	my $self 						= shift;
	my $FILEHANDLE 					= $self->check(shift);
	my $mummerAlignmentCollection 	= $self->{_mummerAlignmentCollection};
	
	my $number = Kea::Number->new;
	
	for (my $i = 0; $i < $mummerAlignmentCollection->getSize; $i++) {
		my $mummerAlignment = $mummerAlignmentCollection->get($i);
		
		my $simple =
		Kea::Phylogeny::Distance::ModelFactory->createSimple(
			$mummerAlignment
			);
		
		my $queryStart = $mummerAlignment->getQueryLocation->getStart;
		my $queryEnd = $mummerAlignment->getQueryLocation->getEnd;
		if ($mummerAlignment->getQueryOrientation eq "-") {
			$queryStart = $mummerAlignment->getQueryLocation->getEnd;
			$queryEnd = $mummerAlignment->getQueryLocation->getStart;
			}
		
		my $referenceStart = $mummerAlignment->getReferenceLocation->getStart;
		my $referenceEnd = $mummerAlignment->getReferenceLocation->getEnd;
		if ($mummerAlignment->getReferenceOrientation eq "-") {
			$referenceStart = $mummerAlignment->getReferenceLocation->getEnd;
			$referenceEnd = $mummerAlignment->getReferenceLocation->getStart;
			}
		
		#1336    AL111168        98.20   5434    96      1       464721  470152  499518  494085  0.0     9864
		printf $FILEHANDLE (
			
			"%s\t%s\t%.2f\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%s\t%s\n",
			
			$mummerAlignment->getQueryId,			# Query id
			$mummerAlignment->getReferenceId,		#	Subject id
			$simple->getPercentIdentity,		 	#	% identity
			$simple->getNumberOfSites,				#	alignment length
			0,										#	mismatches
			0, 										#	gap openings
			$queryStart, 							#	q. start
			$queryEnd, 								#	q. end
			$referenceStart, 						#	s. start
			$referenceEnd, 							#	s. end
			0, 										#	e-value
			0										#	bit score
			
			) or
			$self->throw("Could not print to file.");
		
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

