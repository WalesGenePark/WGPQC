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
package Kea::IO::Phylip::Matrix::_FromMatrixWriter;
use Kea::IO::IWriter;
our @ISA = "Kea::IO::IWriter";

## Purpose		: 

use strict;
use warnings;
use Carp;

use constant TRUE => 1;
use constant FALSE => 0;

use constant SENSE => "sense";
use constant ANTISENSE => "antisense";

use constant FASTA => "fasta";
use constant EMBL => "embl";
use constant UNKNOWN => "unknown";

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

## Purpose		: Constructor.
## Parameter	: n/a.
## Throws		: n/a.
sub new {
	my $className = shift;
	my $matrix = shift;
	
	if (!$matrix->isa("Kea::Phylogeny::IMatrix")) {
		confess "\nERROR: Wrong type: " . ref($matrix);	
		}
	
	my $self = {
		_matrix => $matrix
		};
	bless(
		$self,
		$className
		);
	return $self;
	} # End of constructor.

################################################################################

#�PRIVATE METHODS

my $trim = sub {
	my $label = shift;
	if (length($label) <= 10) {return $label;}
	else {
		warn "\nWARNING: $label is longer than 10 characters and hs been truncated.\n";
		return substr($label, 0, 10);
		}
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $format = sub {
	my $FH = shift;
	my $label = shift;
	my @values = @_;
	
	# create array of id and values.
	$label = sprintf("%-10s", $label);
	push(my @items, $label);
	foreach my $value (@values) {
		# Ensure number correctly formatted.
		$value = sprintf("%.6f", $value);
		push(@items, "  $value");	
		}

	# Convert to blocks of seven.
	my @lines;
	my @buffer;
	foreach my $item (@items) {
		push(@buffer, $item);
		if (@buffer == 7) {
			push(@lines, join("", @buffer));
			@buffer = ();
			}
		}
	if (@buffer) {
		push(@lines, join("", @buffer));
		} 
	
	# Now print to filehandle.
	foreach my $line (@lines) {
		print $FH "$line\n";
		}
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

## Purpose		: ?????????????.
## Returns		: n/a.
## Parameter	: n/a.
## Throws		: n/a.
sub write {
	my ($self, $FILEHANDLE) = @_;
	
	my $matrix = $self->{_matrix};
	my $n = $matrix->getSize;
	
	printf $FILEHANDLE ("%5s\n", $n);
	for (my $i = 0; $i < $n; $i++) {
		my $label = $trim->($matrix->getLabel($i));
		$format->($FILEHANDLE, $label, $matrix->getRow($i));
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

=pod
   28
id_607      0.000000  1.071321  0.903333  0.922439  0.907369  0.919737
  0.885790  0.892104  0.835723  0.864185  0.891542  0.942368  0.888688
  0.823297  0.815029  0.873977  0.886846  0.854156  0.924020  0.949561
  1.045324  0.908825  0.983704  0.871857  0.999719  0.908835  0.881614
  0.812911
id_803      1.071321  0.000000  1.018911  0.967936  0.892723  0.981592
  0.973279  1.035580  1.172481  0.978653  1.031268  0.967687  1.006279
  0.928408  0.880860  0.983905  0.937047  0.955478  0.983177  0.983742
  1.043863  0.957819  0.857341  1.097072  0.924472  0.979980  0.892877
  0.916680
id_3485     0.903333  1.018911  0.000000  0.784766  0.988181  0.929625
  0.831574  0.922497  0.820933  0.827209  0.997782  0.921695  0.899206
  0.864150  0.833210  0.817858  0.839037  0.916795  0.880771  0.992822
  0.909671  0.839408  0.847557  0.892048  0.791835  0.870811  0.832624
  0.785868
id_3595     0.922439  0.967936  0.784766  0.000000  0.823740  0.874586
  0.793304  0.923558  0.722330  0.790010  0.762982  0.808237  0.752111
  0.714251  0.779187  0.707501  0.768531  0.818437  0.726477  0.850375
  0.799249  0.810722  0.842630  0.748410  0.812481  0.773882  0.763400
  0.718974

=cut
