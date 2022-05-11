#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 12/02/2009 11:34:27
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
package Kea::IO::NCBI::SequinFeatureTable::_FromRecordWriter;
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
	my $record = Kea::Object->check(shift, "Kea::IO::IRecord");
	
	my $self = {
		_record => $record
		};
	
	bless(
		$self,
		$className
		);
	
	return $self;
	
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $constructSenseHeader = sub {
	
	my $self		= shift;
	my $feature		= shift;
	
	my @locations = $feature->getLocations;
	my $featureName = $feature->getName;
	
	my $string = "";
	
	if (@locations == 1) {
		$string .=
			$locations[0]->getStart .
			"\t" .
			$locations[0]->getEnd .
			"\t" .
			$featureName .
			"\n";
		}
	
	else {
		
		$string .=
			$locations[0]->getStart .
			"\t" .
			$locations[0]->getEnd .
			"\t" .
			$featureName .
			"\n";
		
		for (my $i = 1; $i < @locations; $i++) {
			
			$string .=
				$locations[$i]->getStart .
				"\t" .
				$locations[$i]->getEnd .
				"\n";
			
			}
		
		}
	
	return $string;
	
	};

#///////////////////////////////////////////////////////////////////////////////

my $constructAntisenseHeader = sub {
	
	my $self		= shift;
	my $feature		= shift;
	
	my @locations = $feature->getLocations;
	my $featureName = $feature->getName;
	
	my $string = "";
	
	if (@locations == 1) {
		$string .=
			$locations[0]->getEnd .
			"\t" .
			$locations[0]->getStart .
			"\t" .
			$featureName .
			"\n";
		}
	
	else {
		
		$string .=
			$locations[@locations-1]->getEnd .
			"\t" .
			$locations[@locations-1]->getStart .
			"\t" .
			$featureName .
			"\n";
		
		for (my $i = @locations - 2; $i >= 0; $i--) {
			
			$string .=
				$locations[$i]->getEnd .
				"\t" .
				$locations[$i]->getStart .
				"\n";
			
			}
		
		}
	
	return $string;
	
	};

#///////////////////////////////////////////////////////////////////////////////

my $constructHeader = sub {
	
	my $self		= shift;
	my $feature		= $self->check(shift, "Kea::IO::Feature::IFeature");

	if (!defined $feature->getOrientation || $feature->getOrientation eq SENSE) {
		return $self->$constructSenseHeader($feature);
		}
	else {
		return $self->$constructAntisenseHeader($feature);
		}
	
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $constructQualifierList = sub {
	
	my $self = shift;
	my $feature = shift;
	
	my $key = $feature->getAllQualifiersAsMap;
	
	my $string = "";
	
	foreach (keys %$key) {
		#print "$_ : $key->{$_}\n";
		
		$string .= "\t\t\t$_\t$key->{$_}\n";
		
		}
	
	return $string;
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $processFeature = sub {
	
	my $self = shift;
	my $feature = shift;
	
	my $string  = $self->$constructHeader($feature);
	
	$string .= $self->$constructQualifierList($feature);
	
	return $string;

	}; # End of method.

################################################################################

# PUBLIC METHODS

sub write {

	my $self = shift;
	my $FILEHANDLE = $self->check(shift);
	my $record = $self->{_record};
	
	print $FILEHANDLE ">Feature " . $record->getPrimaryAccession .  "\n";
	
	my $featureCollection = $record->getFeatureCollection;
	for (my $i = 0; $i < $featureCollection->getSize; $i++) {
		my $feature = $featureCollection->get($i);
		
		#if ($feature->getName eq "CDS") {
			
			print $FILEHANDLE $self->$processFeature($feature);
			
		#	}
		
		}
	
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

