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
package Kea::IO::Blast::Tabular::_ToHandlerReader;
use Kea::Object;
use Kea::IO::IReader;
our @ISA = qw(Kea::Object Kea::IO::IReader);

use strict;
use warnings;

use constant TRUE	=> 1;
use constant FALSE	=> 0;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;

	my $self = {
		_in		=> 0,
		_out 	=> 0
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

sub read {

	my $self = shift;
	my $FILEHANDLE = $self->check(shift);
	my $handler = $self->check(shift, "Kea::IO::Blast::Tabular::IReaderHandler");
	
	while (<$FILEHANDLE>) {
	
		chomp;	
	
		$self->{_in}++;
		
		# Fields: Query id, Subject id, % identity, alignment length, mismatches, gap openings, q. start, q. end, s. start, s. end, e-value, bit score
		#c414    gi|30407139|emb|AL111168.1|     92.36   5615    427     1       321489  327101  500066  494452  0.0     7640
		#c414    gi|30407139|emb|AL111168.1|     94.86   4824    233     6       1415808 1420618 1421559 1426380 0.0     7289
		#c414    gi|30407139|emb|AL111168.1|     94.14   4577    262     2       377894  382464  259758  264334  0.0     6865
		#c414    gi|30407139|emb|AL111168.1|     93.56   4317    274     4       1655408 1659722 28583   32897   0.0     6171
		#1336       CAL34212.1      85.95   989     134     3       1       985     1       988     0.0     1416


		if (/^(.+)\t(.+)\t(.+)\t(.+)\t(.+)\t(.+)\t(.+)\t(.+)\t(.+)\t(.+)\t(.+)\t(.+)$/) {
			
			$self->{_out}++;
			
			# Be strict - insist on every line being a separate alignment.
			if ($self->{_in} != $self->{_out}) {
			
				warn "\nOffending line:\n$_\n";
				
				$self->throw(
					"Not all lines in Blast report appear to represent an " .
					"alignment, which should be the case if -m 8 was used."
					);
				}
		
			$handler->_nextAlignment(
				$1,		# Query id
				$2,		# Subject id
				$3,		# % identity
				$4,		# alignment length
				$5,		# mismatches
				$6,		# gap openings
				$7,		# query start
				$8,		# query end
				$9,		# subject start
				$10,	# subject end
				$11,	# e-value
				$12		# bit score
				);
			
			}
	
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

