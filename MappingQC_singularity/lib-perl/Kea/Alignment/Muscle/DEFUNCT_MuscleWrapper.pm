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

#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////

# CLASS NAME
package Kea::Alignment::Muscle::_MuscleWrapper;
use Kea::Object;
our @ISA = qw(Kea::Object);

## Purpose		: Wrapper class for Muscle alignment program.

use strict;
use warnings;
use Term::ANSIColor;

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

# METHODS

sub run {
	my ($self, %args) = @_;
	
	my $in 		= $self->checkIsFile($args{-in}); 	# -in <inputfile>    Input file in FASTA format (default stdin)
	my $out 	= $args{-out}; 						# -out <outputfile>  Output alignment in FASTA format (default stdout)
	my $gapopen = $args{-gapopen};
	
#	-diags             Find diagonals (faster for similar sequences)
#	-maxiters <n>      Maximum number of iterations (integer, default 16)
#	-maxhours <h>      Maximum time to iterate in hours (default no limit)
#	-maxmb <m>         Maximum memory to allocate in Mb (default 80% of RAM)
#	-html              Write output in HTML format (default FASTA)
#	-msf               Write output in GCG MSF format (default FASTA)
#	-clw               Write output in CLUSTALW format (default FASTA)
#	-clwstrict         As -clw, with 'CLUSTAL W (1.81)' header
#	-log[a] <logfile>  Log to file (append if -loga, overwrite if -log)
#	-quiet             Do not write progress messages to stderr
#	-stable            Output sequences in input order (default is -group)
#	-group             Group sequences by similarity (this is the default)
#	-version           Display version information and exit

	my $command = "muscle -in $in -out $out";
	
	if (defined $gapopen) {
		$command = $command . " -gapopen $gapopen";	
		}
	
	print color "yellow";
	print
		"\n".
		"\t-------------------\n".
		"\t Running Muscle...\n".
		"\t-------------------\n".
		"\n";
	system($command);
	print $command . "\n";
	print
		"\n".
		"\t---------------------\n".
		"\t ...Muscle finished \n".
		"\t---------------------\n".
		"\n";
	print color "reset";	
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

    
    
