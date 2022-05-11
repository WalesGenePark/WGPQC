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
package Kea::ThirdParty::Phylip::_DnaDistWrapper;
use Kea::Object;
use Kea::ThirdParty::IWrapper;
our @ISA = qw(Kea::Object Kea::ThirdParty::IWrapper);

use strict;
use warnings;
use File::Copy;
use Expect;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use constant F84 			=> "F84";
use constant KIMURA 		=> "Kimura";				# Kimura 2-parameter
use constant JUKES_CANTOR 	=> "Jukes-Cantor";
use constant LOG_DET 		=> "LogDet";
use constant SIMILARITY 	=> "Similarity table";

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

sub run {
	my ($self, %args) = @_;
	
	my $infile 	= $self->check($args{-infile});
	my $outfile = $self->check($args{-outfile});
	my $d 		= $args{-D} || F84;
	
	
	# Specify infile.
	#========================
	my $args = [];
	$add->($args, $infile);
	
	
	
	
	# Determine model.
	#=====================================================
	if ($d eq F84) {
		# Do nothing!
		}
	elsif ($d eq KIMURA) {
		$add->($args, "d", 1);
		}
	elsif ($d eq JUKES_CANTOR) {
		$add->($args, "d", 2);
		}
	elsif ($d eq LOG_DET) {
		$add->($args, "d", 3);
		}
	elsif ($d eq SIMILARITY) {
		$add->($args, "d", 4);
		}
	else {
		$self->throw("Do not recognise model: $d");
		}
	#=====================================================
	
	
	
	
	# Confirm settings are correct.
	#==============================
	$add->($args, "y", 1);

	
	
	
	
	
	# Run program using Expect
	#===========================================================================
	
	# Initialise expect object.
	my $expect = Expect->new;
	
	# Set pty to raw mode before spawning.  Disables echoing and CR->LF translation
	# and gives a more pipe-like behaviour.
	#$expect->raw_pty(1);
	
	# Forks and executes supplied command.
	$expect->spawn("dnadist") or $self->throw("Could not spawn 'dnadist'.");
	
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
	#=====================================================	
	print ">>> \"outfile\" renamed as \"$outfile\"\n";	
	move("outfile", $outfile);	
		
	
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

=pod
Nucleic acid sequence Distance Matrix program, version 3.67

Settings for this run:
  D  Distance (F84, Kimura, Jukes-Cantor, LogDet)?  F84
  G          Gamma distributed rates across sites?  No
  T                 Transition/transversion ratio?  2.0
  C            One category of substitution rates?  Yes
  W                         Use weights for sites?  No
  F                Use empirical base frequencies?  Yes
  L                       Form of distance matrix?  Square
  M                    Analyze multiple data sets?  No
  I                   Input sequences interleaved?  Yes
  0            Terminal type (IBM PC, ANSI, none)?  ANSI
  1             Print out the data at start of run  No
  2           Print indications of progress of run  Yes

  Y to accept these or type the letter for one to change

=cut
