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
package Kea::Alignment::Clustalw;
use Kea::Object;
our @ISA = qw(Kea::Object);

## Purpose		: Wrapper class for the Clustalw program.

use strict;
use warnings;

use constant TRUE => 1;
use constant FALSE => 0;

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

# METHODS

## Purpose		: Runs clustalw.
## Returns		: n/a.
## Parameter	: -infile = Fasta formatted sequence file to align.
## Parameter	: -outfile = Name for alignment file.
## Parameter	: -output = GCG, GDE, PHYLIP, or PIR.
## Parameter	: -type = PROTEIN or DNA.
## Throws		: n/a.
sub run {
	my ($self, %args) = @_;
	
	my $infile = $args{-infile} or $self->throw("No infile provided.  Use -infile flag");
	my $outfile = $args{-outfile};
	my $output = $args{-output};
	my $type = $args{-type};
	
	# Generate clustalw command.
	my $command = "clustalw -infile=$infile";
	if ($outfile) {$command .= " -outfile=$outfile";}
	if ($output) {$command .= " -output=$output";}
	if ($type) {$command .= "-type=$type";} 
	
	print
		"\n".
		"\t--------------------\n".
		"\t Running ClustalW...\n".
		"\t--------------------\n".
		"\n";
	system($command);
	print
		"\n".
		"\t----------------------\n".
		"\t ...ClustalW finished \n".
		"\t----------------------\n".
		"\n";
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

