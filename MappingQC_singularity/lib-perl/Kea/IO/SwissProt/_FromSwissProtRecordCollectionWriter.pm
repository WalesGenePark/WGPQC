#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 14/05/2008 16:58:49
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
package Kea::IO::SwissProt::_FromSwissProtRecordCollectionWriter;
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
	
	my $swissProtRecordCollection =
		Kea::Object->check(shift, "Kea::IO::SwissProt::SwissProtRecordCollection");
	
	my $self = {
		_swissProtRecordCollection => $swissProtRecordCollection
		};
	
	bless(
		$self,
		$className
		);
	
	return $self;
	
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $formatSequence = sub {
	
	my $self = shift;
	my $sequence = shift;
	
	# Dice sequence into 60 base chunks
	my @buffer;
	for (my $i = 0; $i < length($sequence); $i = $i + 60) {
		my $bases60 = substr($sequence, $i, 60);
		
		# Further dice into 10 base blocks
		my @line;
		for (my $j = 0; $j < length($bases60); $j = $j + 10) {
			my $bases10 = substr($bases60, $j, 10);
			push(@line, $bases10);
			}
		push(@buffer, "     " . join(" ", @line));
		}
	
	return \@buffer;
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub write {

	my $self 						= shift;
	my $FILEHANDLE 					= $self->check(shift);
	my $swissProtRecordCollection 	= $self->{_swissProtRecordCollection};
	
	for (my $i = 0; $i < $swissProtRecordCollection->getSize; $i++) {
		my $swissProtRecord = $swissProtRecordCollection->get($i);	
		
		my @lines;
	
		# ID line
		#=======================================================================
		
		my $idLine;
		# ID   CRAM_CRAAB     STANDARD;      PRT;    46 AA.
		if (defined $swissProtRecord->getMoleculeType) {
			$idLine =
				sprintf(
					"ID   %s     %s;      %s;    %d AA.",
					$swissProtRecord->getEntryName,
					$swissProtRecord->getDataClass,
					$swissProtRecord->getMoleculeType,
					$swissProtRecord->getLength
					);
			}
		#ID   12AH_CLOS4              Reviewed;          29 AA.
		else {
			$idLine =
				sprintf(
					"ID   %s              %s;          %d AA.",
					$swissProtRecord->getEntryName,
					$swissProtRecord->getDataClass,
					$swissProtRecord->getLength
					);
			}
			
		push(@lines, $idLine);
		
		#=======================================================================
		
		
		# AC line
		#=======================================================================
		
		my $acLine = "AC   " . join("; ", @{$swissProtRecord->getAccessions});
		push(@lines, $acLine);
		
		#=======================================================================
		
		
		# DE line
		#=======================================================================
		
		# DE   14 kDa antigen (16 kDa antigen) (HSP 16.3).
		my $deLine = "DE   " . $swissProtRecord->getDescription;
		push(@lines, $deLine);
		
		#=======================================================================
		
		
		
		
		#ÊSequence
		#=======================================================================
		
		#	SQ   SEQUENCE   611 AA;  65927 MW;  625F1B284107B1FC CRC64;
		my $sqLine =
			sprintf(
				"SQ   SEQUENCE   %d AA;  %d MW;  %s CRC64;",
				$swissProtRecord->getLength,
				$swissProtRecord->getMolecularWeight,
				$swissProtRecord->getSequence64bitCRC
				);
		push(@lines, $sqLine);
		
		my $sequence = $swissProtRecord->getSequence;
		my $buffer = $self->$formatSequence($sequence);
		push(@lines, @$buffer);
		
		push(@lines, "//");
		
		#=======================================================================
		
		
		
		foreach my $line (@lines) {
			print $FILEHANDLE "$line\n" or
				$self->throw("Could not print to outfile.");
			} 
			
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

