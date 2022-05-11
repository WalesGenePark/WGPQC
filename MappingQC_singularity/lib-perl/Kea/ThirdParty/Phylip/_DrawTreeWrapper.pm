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
package Kea::ThirdParty::Phylip::_DrawTreeWrapper;
use Kea::Object;
use Kea::ThirdParty::IWrapper;
our @ISA = qw(Kea::Object Kea::ThirdParty::IWrapper);

## Purpose		: 

use strict;
use warnings;
use File::Copy;
use Expect;

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

my $add = sub {

	my $list 	= shift;
	my $arg 	= shift;
	my $n 		= shift || 1;
	
	for (my $i = 0; $i < $n; $i++) {
		push(@$list, "$arg\n");
		}
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

## Purpose		: ?????????????.
## Returns		: n/a.
## Parameter	: n/a.
## Throws		: n/a.
sub run {
	my ($self, %args) = @_;
	my $infile 				= $args{-infile}	or $self->throw("No infile provided.");
	my $outfile 			= $args{-outfile}	or $self->throw("No outfile provided.");
	my $fontfile			= $args{-fontfile}	or $self->throw("No fontfile provided.");
	my $paperWidth 			= $args{-paperWidth};
	my $paperHeight			= $args{-paperHeight};
	my $verticalMargin 		= $args{-verticalMargin};
	my $horizontalMargin 	= $args{-horizontalMargin};
	my $characterHeight		= $args{-characterHeight};
	
	# Initialise array for storing program arguments.
	my $args = [];
	
	# Specify infile.
	$add->($args, $infile);
	
	# Specify fontfile.
	$add->($args, $fontfile);
	
	# Make selections
	#=====================================================
	
	# Disable previewing.
	$add->($args, "v");
	$add->($args, "n");
	
	# Define physical paper size
	if (defined $paperWidth && defined $paperHeight) {
		$add->($args, "#");
		$add->($args, "p");
		$add->($args, $paperWidth);
		$add->($args, $paperHeight);
		$add->($args, "m");
		}
	
	# Relative character height.
	if (defined $characterHeight) {
		$add->($args, "c");
		$add->($args, $characterHeight);
		}
	
	# Define margins.
	if (defined $horizontalMargin && defined $verticalMargin) {
		$add->($args, "m");
		$add->($args, $horizontalMargin);
		$add->($args, $verticalMargin);
		}
	
	#if ($d eq F84) {
	#	# Do nothing!
	#	}
	#elsif ($d eq KIMURA) {
	#	$add->($args, "p", 1);
	#	}
	#elsif ($d eq JUKES_CANTOR) {
	#	$add->($args, "p", 2);
	#	}
	#elsif ($d eq LOG_DET) {
	#	$add->($args, "p", 3);
	#	}
	#elsif ($d eq SIMILARITY) {
	#	$add->($args, "p", 4);
	#	}
	#else {
	#	confess "\nERROR: do not recognise model: $d";
	#	}
	#=====================================================
	
	

	# Confirm settings are correct.
	#==============================
	$add->($args, "y", 1);
	#==============================

	
	
	
	
	# Run program using Expect
	#===========================================================================
	
	# Initialise expect object.
	my $expect = Expect->new;
	
	# Set pty to raw mode before spawning.  Disables echoing and CR->LF translation
	# and gives a more pipe-like behaviour.
	#$expect->raw_pty(1);
	
	# Forks and executes supplied command.
	$expect->spawn("drawtree") or $self->throw("Could not spawn 'drawtree'.");
	
	# Sends the given strings to the spawned command.
	$expect->print(@$args);
	
	# Timeout after 2 minutes.
	$expect->expect(120);
	
#	$expect->debug(2);
	
	# When no longer needed, do a soft-close to nicely shut down command or
	# dies after 15 seconds. Not needed as using expect().
#	$expect->soft_close();
			
	#===========================================================================	
	
	

	

	# Rename outfile to that specified.	
	#===========================================================================
	
	print ">>> \"plotfile\" renamed as \"$outfile\"\n";	
	move("plotfile", $outfile);	
	
	#===========================================================================	
	
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;



=pod
 0  Screen type (IBM PC, ANSI)?  ANSI
 P       Final plotting device:  Postscript printer
 V           Previewing device:  X Windows display
 B          Use branch lengths:  Yes
 L             Angle of labels:  branch points to Middle of label
 R            Rotation of tree:  90.0
 I     Iterate to improve tree:  Equal-Daylight algorithm
 D  Try to avoid label overlap?  No
 S      Scale of branch length:  Automatically rescaled
 C   Relative character height:  0.3333
 F                        Font:  Times-Roman
 M          Horizontal margins:  1.65 cm
 M            Vertical margins:  2.16 cm
 #           Page size submenu:  one page per tree

 Y to accept these or type the letter for one to change


=cut
