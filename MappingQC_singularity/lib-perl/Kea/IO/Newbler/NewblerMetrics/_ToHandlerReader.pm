#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 30/01/2009 15:57:56
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
package Kea::IO::NewblerMetrics::_ToHandlerReader;
use Kea::Object;
use Kea::IO::IReader;
our @ISA = qw(Kea::Object Kea::IO::IReader);
 
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
	my $self = {
		
		};
	bless(
		$self,
		$className
		);
	return $self;
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $processRunMetrics = sub {
	
	my $self 		= shift;
	my $FILEHANDLE 	= shift;
	my $handler 	= shift;
	
	while (<$FILEHANDLE>) {
		
		chomp;
		return if (/^\}/);
		
		if (/^\s+totalNumberOfReads\s+=\s+(\d+);$/) {
			$handler->_totalNumberOfReads($1);
			}
		
		elsif (/^\s+totalNumberOfBases\s+=\s+(\d+);$/) {
			$handler->_totalNumberOfBases($1);
			}
		
		elsif (/^\s+numberSearches\s+=\s+(\d+);$/) {
			$handler->_numberOfSearches($1);
			}
		
		elsif (/^\s+seedHitsFound\s+=\s+(\d+),\s+([\d\.]+);$/) {
			$handler->_seedHitsFound($1, $2);
			}
		
		elsif (/^\s+overlapsFound\s+=\s+(\d+),\s+([\d\.]+),\s+([\d\.]+)\%;$/) {
			$handler->_overlapsFound($1, $2, $3);
			}
		
		elsif (/^\s+overlapsReported\s+=\s+(\d+),\s+([\d\.]+), ([\d\.]+)\%;$/) {
			$handler->_overlapsReported($1, $2, $3);
			}
		
		elsif (/^overlapsUsed\s+=\s+(\d+),\s+([\d\.]+),\s+([\d\.]+)\%;$/) {
			$handler->_overlapsUsed($1, $2, $3);
			}
		
		}
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $processReadAlignmentResults = sub {
	
	my $self 		= shift;
	my $FILEHANDLE 	= shift;
	my $handler 	= shift;
	
	while (<$FILEHANDLE>) {
		
		chomp;
		return if (/^\}/);
		
		if (/^\s+numAlignedReads\s+=\s+(\d+),\s+([\d\.]+)\%;$/) {
			$handler->_numAlignedReads($1, $2);
			}
		
		elsif (/^\s+numAlignedBases\s+=\s+(\d+),\s+([\d\.]+)\%;$/) {
			$handler->_numAlignedBases($1, $2);
			}
		
		elsif (/^\s+inferredReadError\s+=\s+([\d\.]+)\%,\s+(\d+);$/) {
			$handler->_inferredReadError($1, $2);
			}
		
		}
	
	}; # End of method. 

#///////////////////////////////////////////////////////////////////////////////

my $processLargeContigsMetrics = sub {
	
	my $self 		= shift;
	my $FILEHANDLE 	= shift;
	my $handler 	= shift;
	
	while (<$FILEHANDLE>) {
		
		chomp;
		return if (/^\s+\}/);
		
		if (/^\s+numberOfContigs\s+=\s+(\d+);$/) {
			$handler->_numberOfLargeContigs($1);
			}
		
		elsif (/^\s+numberOfBases\s+=\s+(\d+);$/) {
			$handler->_numberOfLargeContigBases($1);
			}
		
		elsif (/^\s+avgContigSize\s+=\s+(\d+);$/) {
			$handler->_avgLargeContigSize($1);
			}
		
        elsif (/^\s+N50ContigSize\s+=\s+(\d+);$/) {
			$handler->_N50ContigSize($1);
			} 

		elsif (/^\s+largestContigSize\s+=\s+(\s+);$/) {
			$handler->_largestContigSize($1);
			}
                
		elsif (/^\s+Q40PlusBases\s+=\s+(\d+),\s+([\d\.]+)\%;$/) {
			$handler->_Q40PlusBases($1, $2);
			}
                
		elsif (/^\s+Q39MinusBases\s+=\s+(\d+),\s+([\d\.]+)\%;$/) {
			$handler->_Q39MinusBases($1, $2);
			}

		}
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $processAllContigMetrics = sub {
	
	my $self 		= shift;
	my $FILEHANDLE 	= shift;
	my $handler 	= shift;
	
	while (<$FILEHANDLE>) {
	
		chomp;
		return if (/^\}$/);
		
		if (/^\s+numberOfContigs\s+=\s+(\d+);/) {
			$handler->_numberOfContigs($1);
			}
	
		elsif (/^\s+numberOfBases\s+=\s+(\d+);$/) {
			$handler->_numberOfBases($1);
			}
	
		}
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $processConsensusResults = sub {
	
	my $self 		= shift;
	my $FILEHANDLE 	= shift;
	my $handler 	= shift;
	
	while (<$FILEHANDLE>) {
	
		chomp;
		return if (/^\}$/);
	
		if (/^\s+numAlignedReads\s+=\s+(\d+),\s+([\d\.]+)\%;$/) {
			$handler->_numAlignedReads($1, $2);
			}
		
		elsif (/^\s+numAlignedBases\s+=\s+(\d+),\s+([\d\.]+)\%;$/) {
			$handler->_numAlignedBases($1, $2);
			}
		
		elsif (/^\s+inferredReadError\s+=\s+([\d\.]+)\%,\s+(\d+);$/) {
			$handler->_inferredReadError($1, $2);
			}
		
		
                
		
		elsif (/^\s+numberAssembled\s+=\s+(\d+);$/) {
			$handler->_numberAssembled($1);
			}
		
		elsif (/^\s+numberPartial\s+=\s+(\d+);$/) {
			$handler->_numberPartial($1);
			}
	
		elsif (/^\s+numberSingleton\s+=\s+(\d+);$/) {
			$handler->_numberSingletons($1);
			}
	
		elsif (/^\s+numberRepeat\s+=\s+(\d+);$/) {
			$handler->_numberRepeat($1);
			}	
		
        elsif (/^\s+numberOutlier\s+=\s+(\d+);$/) {
			$handler->_numberOutlier($1);
			}
		
		elsif (/^\s+numberTooShort\s+=\s+(\d+);$/) {
			$handler->_numberTooShort($1);
			}
			        
                
		elsif (/^\s+largeContigMetrics$/) {
			$self->$processLargeContigsMetrics($FILEHANDLE, $handler);
			}		
				
		elsif (/^\s+allContigMetrics$/) {
			$self->$processAllContigMetrics($FILEHANDLE, $handler);
			}
	
		}
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub read {

	my $self 		= shift;
	my $FILEHANDLE 	= $self->check(shift);
	
	my $handler =
		$self->check(shift, "Kea::IO::Newbler::NewblerMetrics::IReaderHandler");
	
	while (<$FILEHANDLE>) {
		chomp;
		if (/^runMetrics\s*$/) {
			$self->$processRunMetrics($FILEHANDLE, $handler);
			}
		
		elsif (/^readAlignmentResults\s*$/) {
			$self->$processReadAlignmentResults($FILEHANDLE, $handler);
			}
		
		elsif (/^consensusResults\s*$/) {
			$self->$processConsensusResults($FILEHANDLE, $handler);
			}
		
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

