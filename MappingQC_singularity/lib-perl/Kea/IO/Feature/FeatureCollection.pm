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
package Kea::IO::Feature::FeatureCollection;
use Kea::Object;
use Kea::ICollection; 
our @ISA = qw(Kea::Object Kea::ICollection);

use strict;
use warnings;

use constant TRUE => 1;
use constant FALSE => 0;

use Kea::Properties;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	my $className = shift;
	my $id = shift;
	if (!defined $id){
		
		if (Kea::Properties->getProperty("warnings") ne "off") {
			Kea::Object->warn("Overall id for feature collection not specified.");
			}
		
		
		}
	my $self = {
		_array => [],
		_overallId => $id
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

sub getOverallId {
	return shift->{_overallId};
	} # end of method.

sub getSize {
	return scalar(@{shift->{_array}});
	} # End of method.

sub get {
	my $self = shift;
	my $i = $self->check(shift);
	return $self->{_array}->[$i];
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getParents {
	
	my $self = shift;
	
	my @records;
	my @features = $self->getAll;
	foreach my $feature (@features) {
		push(@records, $feature->getParent);
		}
	
	return @records;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasFeaturesFromRecord {
	
	my $self 	= shift;
	my $record 	= $self->check(shift, "Kea::IO::IRecord");
	
	my @features = $self->getAll;
	
	foreach my $feature (@features) {
	
		if ($feature->getParent->equals($record)) {
			return TRUE;
			}
		}
	
	return FALSE;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub countFeaturesFromRecord {
	
	my $self 	= shift;
	my $record 	= $self->check(shift, "Kea::IO::IRecord");
	
	my @features = $self->getAll;
	
	my $counter = 0;
	foreach my $feature (@features) {
	
		if ($feature->getParent->equals($record)) {
			$counter++;
			}
		}
	
	return $counter;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasFeatureWithLocusTag {

	my $self 		= shift;
	my $locusTag 	= $self->check(shift);
	
	$self->throw(
		"Methodology flawed - more than one feature will have same protein_id, " .
		"i.e., CDS and gene features"
		);
	
	foreach my $feature (@{$self->{_array}}) {
		if ($feature->getLocusTag eq $locusTag) {
			return TRUE;
			}
		}
	return FALSE;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getFeatureWithLocusTag {

	my $self 		= shift;
	my $locusTag 	= $self->check(shift);
	
	$self->throw(
		"Methodology flawed - more than one feature will have same protein_id, " .
		"i.e., CDS and gene features"
		);
	
	foreach my $feature (@{$self->{_array}}) {
		if ($feature->getLocusTag eq $locusTag) {
			return $feature;	
			}
		}
	$self->throw("Could not find feature with locus_tag '$locusTag'");
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasFeatureWithUniqueId {

	my $self 		= shift;
	my $uniqueId 	= $self->check(shift);
	
	foreach my $feature (@{$self->{_array}}) {
		if ($feature->getUniqueId eq $uniqueId) {
			return TRUE;
			}
		}
	return FALSE;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getFeatureWithUniqueId {

	my $self 		= shift;
	my $uniqueId 	= $self->check(shift);
	
	foreach my $feature (@{$self->{_array}}) {
		if ($feature->getUniqueId eq $uniqueId) {
			return $feature;	
			}
		}
	$self->throw("Could not find feature with unique id '$uniqueId'");
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAll {
	return @{shift->{_array}};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub add {

	my $self 	= shift;
	my $feature = $self->check(shift, "Kea::IO::Feature::IFeature");
	
	push(@{$self->{_array}}, $feature);

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self = shift;
	
	my $text = "";
	
	my @features = $self->getAll;
	
	foreach my $feature (@features) {
		$text .= $feature->toString . "\n";
		}
	
	return $text;
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

