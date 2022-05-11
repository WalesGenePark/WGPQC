#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 16/02/2008 17:35:51 
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


#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////

# CLASS NAME
package Kea::File;
use Kea::Object;
our @ISA = qw(Kea::Object);

## Purpose		: 

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

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

sub getSuffix {
	
	my $self = shift;
	my $file = $self->check(shift);
	
	if ($file =~ /^.+\.(.+)$/) {
		return $1;
		}
	
	$self->throw("$file does not have a suffix to remove.");
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub is {
	
	my $self 	= shift;
	my $file 	= $self->check(shift);
	my $format 	= $self->check(shift);
	
	my $suffix = $self->getSuffix($file);
	
	if ($suffix =~ /^$format$/i) {
		return TRUE;
		}
	else {
		return FALSE;	
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub isFasta {
	
	my $self = shift;
	my $file = $self->checkIsFile(shift);
	
	my $suffix = $self->getSuffix($file);
	
	if ($suffix =~ /^fa(s)*$/i || $suffix =~ /^fna$/i) {
		return TRUE;
		}
	else {
		return FALSE;	
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub isEmbl {
	
	my $self = shift;
	my $file = $self->checkIsFile(shift);
	
	my $suffix = $self->getSuffix($file);
	
	if ($suffix =~ /^embl$/i) {
		return TRUE;
		}
	else {
		return FALSE;	
		}
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub isGenBank {
	
	my $self = shift;
	my $file = $self->checkIsFile(shift);
	
	my $suffix = $self->getSuffix($file);
	
	if ($suffix =~ /^gb$/i) {
		return TRUE;
		}
	else {
		return FALSE;	
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

