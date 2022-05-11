#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 12/07/2008 14:58:47
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
package Kea::IO::CGView::XML::_FromRecordWriter;
use Kea::IO::IWriter;
use Kea::Object;
our @ISA = qw(Kea::Object Kea::IO::IWriter);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";
use constant DEFAULT_COLOUR => "rgb(0,255,255)";

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

my $reformatColour = sub {
	
	my $self = shift;
	my $colour = $self->check(shift);
	
	my ($red, $green, $blue) = split(/\s/, $colour);
	
	return "rgb($red,$green,$blue)";
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $processCDS = sub {
	
	my $self = shift;
	my $feature = $self->check(shift, "Kea::IO::Feature::IFeature");
	
	my $text = "";

	my $colour = DEFAULT_COLOUR;
	
	#print $feature->getColour . "\n";
	
	if ($feature->hasColour) {
		$colour = $self->$reformatColour($feature->getColour);
		}
	
	my $start 	= $feature->getFirstLocation->getStart;
	my $end 	= $feature->getLastLocation->getEnd;
	
	$text .= "\t\t<feature color=\"$colour\" decoration=\"arc\">\n";
    $text .= "\t\t\t<featureRange start=\"$start\" stop=\"$end\" />\n";
    $text .= "\t\t</feature>\n";
	
	return $text;
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $processtRNA = sub {
	
	my $self = shift;
	my $feature = $self->check(shift, "Kea::IO::Feature::IFeature");
	
	my $text = "";

	my $colour = "rgb(0,0,0)";

	if ($feature->hasColour) {
		$colour = $self->$reformatColour($feature->getColour);
		}
	
	my $start 	= $feature->getFirstLocation->getStart;
	my $end 	= $feature->getLastLocation->getEnd;
	
	$text .= "\t\t<feature color=\"$colour\" decoration=\"arc\">\n";
    $text .= "\t\t\t<featureRange start=\"$start\" stop=\"$end\" />\n";
    $text .= "\t\t</feature>\n";
	
	return $text;
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $processMisc = sub {
	
	my $self = shift;
	my $feature = $self->check(shift, "Kea::IO::Feature::IFeature");
	
	my $text = "";

	my $colour = DEFAULT_COLOUR;

	if ($feature->hasColour) {
		$colour = $self->$reformatColour($feature->getColour);
		}
	
	my $start 	= $feature->getFirstLocation->getStart;
	my $end 	= $feature->getLastLocation->getEnd;
	
	$text .= "\t\t<feature color=\"$colour\" decoration=\"arc\">\n";
    $text .= "\t\t\t<featureRange start=\"$start\" stop=\"$end\" />\n";
    $text .= "\t\t</feature>\n";
	
	return $text;
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub write {

	my $self 			= shift;
	my $FILEHANDLE 		= $self->check(shift);
	my $backboneRadius 	= $self->check(shift);
	my $backboneColour	= $self->check(shift);
	my $height			= $self->check(shift);
	my $width			= $self->check(shift);
	my $record 			= $self->{_record};
	
	my $size = $record->getLength;
	
	# Todo: more robust xml code generation required.
	my $text = "";
	$text .= "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n";
	$text .=
		"<cgview backboneRadius=\"$backboneRadius\" " .
		"sequenceLength=\"$size\" " .
		"backboneColor=\"$backboneColour\" " .
		"height=\"$height\" " .
		"width=\"$width\">\n";
	$text .= "\n";
	
	my $featureCollection = $record->getFeatureCollection;
	
	#ÊProcess misc features.
	$text .= "\t<featureSlot strand=\"direct\">\n";
	for (my $i = 0; $i < $featureCollection->getSize; $i++) {
		my $feature = $featureCollection->get($i);
		if ($feature->getName eq "misc_feature") {
			$text .= $self->$processtRNA($feature);
			}
		}
	$text .= "\t</featureSlot>\n";
	
	# Process CDS features.
	$text .= "\t<featureSlot strand=\"direct\">\n";
	for (my $i = 0; $i < $featureCollection->getSize; $i++) {
		my $feature = $featureCollection->get($i);
		if ($feature->getName eq "CDS") {
			$text .= $self->$processCDS($feature);
			}
		}
	$text .= "\t</featureSlot>\n";

	#ÊProcess tRNA features.
	$text .= "\t<featureSlot strand=\"reverse\">\n";
	for (my $i = 0; $i < $featureCollection->getSize; $i++) {
		my $feature = $featureCollection->get($i);
		if ($feature->getName eq "tRNA") {
			$text .= $self->$processtRNA($feature);
			}
		}
	$text .= "\t</featureSlot>\n";
	
	
	
	# Process misc features.
	
	
	
    
	$text .= "</cgview>\n";
	
	
	print $FILEHANDLE $text or $self->throw("Could not write to outfile: $!");
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

