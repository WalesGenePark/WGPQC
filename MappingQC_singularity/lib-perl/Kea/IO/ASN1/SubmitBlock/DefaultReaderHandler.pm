#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 10/03/2009 10:48:23
#    Copyright (C) 2009, University of Liverpool.
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
package Kea::IO::ASN1::SubmitBlock::DefaultReaderHandler;
use Kea::IO::ASN1::SubmitBlock::IReaderHandler;
use Kea::Object;
our @ISA = qw(Kea::Object Kea::IO::ASN1::SubmitBlock::IReaderHandler);
 
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

my $privateMethod = sub {
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub _submitBlockStart {
	
	my $self = shift;
	
	print "SUBMIT BLOCK START\n";
	# Create SubmitBlockObject.
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextStart {
	
	my $self 	= shift;
	
	print "START\n";
	# Create new element - add as child to current element.
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////


sub _nextStartWithText {
	
	my $self 	= shift;
	my $string	= $self->check(shift);
	
	print "$string\tSTART\n";
	# Start new labelled element - add a child to current element.
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextEnd {
	
	my $self = shift;
	
	print "STOP\n";
	# Close current element, replace with parent.
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextItem {
	
	my $self = shift;
	my $name = shift;
	
	print "$name\n";
	# Store new item in current
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextItemPlusText {
	
	my $self = shift;
	my $name = shift;
	my $text = shift;
	
	print "$name\t$text\n";
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextEndWithItemPlusText {
	
	my $self = shift;
	my $name = shift;
	my $text = shift;
	
	print "$name\t$text\tSTOP\n";
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

