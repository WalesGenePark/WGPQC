#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 24/04/2008 15:26:34
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
package Kea::IO::Embl::_FromDiffCollectionWriter;
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
	
	my $diffCollection =
		Kea::Object->check(
			shift,
			"Kea::Assembly::Newbler::AllDiffs::DiffCollection"
			);
	
	my $self = {
		_diffCollection => $diffCollection
		};
	
	bless(
		$self,
		$className
		);
	
	return $self;
	
	} # End of constructor.

################################################################################

#?PRIVATE METHODS

my $privateMethod = sub {
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub write {

	my $self 			= shift;
	my $FILEHANDLE 		= $self->check(shift);
	my $colour			= $self->check(shift, "Kea::Graphics::IColour");
	my $diffCollection 	= $self->{_diffCollection};
	
	
	my $beforeId = $diffCollection->getBeforeId;
	my $afterId = $diffCollection->getAfterId;
	
	for (my $i = 0; $i < $diffCollection->getSize; $i++) {
		my $diff = $diffCollection->get($i);
		
		my $note = sprintf(
		"%s vs %s, %s -> [%s]",
		$beforeId,
		$afterId,
		$diff->getBefore,
		join(", ", @{$diff->getAfter})
		);
		
		my $colourString = join(" ", @{$colour->getRgb});
	
		my $text = "";
		$text .= "FT   misc_feature    " . $diff->getLocation->toString . "\n";
		$text .= "FT                   /note=\"$note\"\n";
		$text .= "FT                   /colour=\"" . $colourString . "\"\n";
		
		print $FILEHANDLE $text or $self->throw("");
		
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

