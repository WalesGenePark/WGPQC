#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 06/03/2008 16:02:54 
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
package Kea::IO::Mummer::ShowAligns::_ToHandlerReader;
use Kea::Object;
use Kea::IO::IReader;
our @ISA = qw(Kea::Object Kea::IO::IReader);

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

my $processAlignment = sub {

	my $self = shift;
	my $FILEHANDLE = $self->check(shift);
	my $handler =
		$self->check(shift, "Kea::IO::Mummer::ShowAligns::IReaderHandler");
		
	my $refSequence = "";
	my $querySequence = "";
		
	while (<$FILEHANDLE>) {
		
		# End of current alignment.
		#=======================================================================
		
		if (/^--   END alignment \[ ([+-])(\d) (\d+) - (\d+) \| ([+-])(\d) (\d+) - (\d+) \]$/) {
		
			$handler->_nextReferenceSequence($refSequence);
			$handler->_nextQuerySequence($querySequence);
		
			$handler->_nextEndAlignmentLine(
				$1,	# Reference orientation (+ or -)
				$2, # Reference frame (1, 2, 3)
				$3,	# Reference start
				$4,	# Reference end
				$5,	# Query orientation
				$6, # Query frame
				$7,	# Query start
				$8	# Query end.
				);
			
			return;
			}
		
		#=======================================================================
		
		
		
		
		# Aligned sequence data.
		#=======================================================================
		
		if (/^(\d+)\s+([\w\.]+)$/) {
			
			# Append to ref sequence string.
			$refSequence .= $2;
			
			# Next line should be query.
			<$FILEHANDLE> =~ /^(\d+)\s+([\w\.]+)$/ or
				$self->throw("Expecting query sequence after reference.");
			$querySequence .= $2;
				
			# Next line should be difference line.	
			}
		
		#=======================================================================
		
		
		
		} # End of  while.
	
	# Shouldn't reach this point.
	$self->throw("Reached end of file without encountering 'END alignment' line.");
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub read {

	my $self = shift;
	my $FILEHANDLE = $self->check(shift);
	my $handler =
		$self->check(shift, "Kea::IO::Mummer::ShowAligns::IReaderHandler");
	
	
	# First line gives full paths for reference and query sequences.
	#==========================================================================
	<$FILEHANDLE> =~ /^(.+)\s(.+)$/ or
		$self->throw("Could not match first line of file.");
	
	$handler->_referencePath($1);
	$handler->_queryPath($2);
	#===========================================================================
	
	<$FILEHANDLE>;
	<$FILEHANDLE>;
	
	# Extract sequence ids from fourth line of file.
	#===========================================================================
	<$FILEHANDLE> =~ /^-- Alignments between (.+) and (.+)$/ or
		$self->throw("Could not match fourth line of file.");
	
	$handler->_referenceHeaderTag($1);
	$handler->_queryHeaderTag($2);
	#===========================================================================
	
	
	while (<$FILEHANDLE>) {

		
		if (/^-- BEGIN alignment \[ ([+-])(\d) (\d+) - (\d+) \| ([+-])(\d) (\d+) - (\d+) \]$/) {
			
			$handler->_nextBeginAlignmentLine(
				$1,	# Reference orientation (+ or -)
				$2, # Reference frame (1, 2, 3)
				$3,	# Reference start
				$4,	# Reference end
				$5,	# Query orientation
				$6, # Query frame
				$7,	# Query start
				$8	# Query end.
				);
			
			$self->$processAlignment($FILEHANDLE, $handler);
			
			}
		
	
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

=pod
/Users/Kev/work/today/06-03-2008/testing_nucmer_show-aligns_parser/TypeII_pseudochromosome.fas /Users/Kev/work/today/06-03-2008/testing_nucmer_show-aligns_parser/TypeIII_shotgun.fas

============================================================
-- Alignments between Ia and Contig107

-- BEGIN alignment [ +1 1895349 - 1895761 | +1 3224 - 3635 ]


1895349    tttagggtttagtgggtttagggtt....gtttagggtt....gtttag
3224       tttagggttta..gggtttagggtttagggtttagggtttagggtttag
                      ^^            ^^^^          ^^^^      

1895390    ggtggtgtagggtttagggtttagggtttagggtttagggtttagggtt
3271       ggt..t.tagggtttagggtttagggtttagggtttagggtttagggtt
              ^^ ^                                          

1895439    tagggtttagggtttagggtttagggtttagggtttagggtttagggtt
3317       tagggtttagggtttagggtttagggtttagggtttagggtttagggtt
                                                            

1895488    tagggtttagggtttagggtttagggtttagggtttagggtttagggtt
3366       tagggtttagggtttagggtttagggtttagggtttagggtttagggtt
                                                            

1895537    tagggtttagggtttagggtttagggtttagggtttagggtttagggtt
3415       tagggtttagggtttagggtttagggtttagggtttagggtttagggtt
                                                            

1895586    tagggtttagggtttagggtttagggttttttagggtttagggtttagg
3464       tagggtttagggtttagggtttagggttttttagggtttagggtttagg
                                                            

1895635    gtttagggttttttagggtttagggtttagggtttagggtttagggttt
3513       gtttagggtt...tagggtttagggtttaggg.ttagggtttagggttt
                     ^^^                   ^                

1895684    agggtttagggtttagggtttagggtttagggtttagggtttagggttt
3558       agggtttagggtttagggtttagggtttagggtttagggtttagggttt
                                                            

1895733    agggtttagggtttagggtttagggttta
3607       agggtttagggtttagggtttagggttta
                                        


--   END alignment [ +1 1895349 - 1895761 | +1 3224 - 3635 ]
-- BEGIN alignment [ +1 1895330 - 1896408 | +1 2375 - 3447 ]
=cut