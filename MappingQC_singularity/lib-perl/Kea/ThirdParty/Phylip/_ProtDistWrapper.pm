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
package Kea::ThirdParty::Phylip::_ProtDistWrapper;
use Kea::Object;
use Kea::ThirdParty::IWrapper;
our @ISA = qw(Kea::Object Kea::ThirdParty::IWrapper);

## Purpose		: Private wrapper class for protdist.

use strict;
use warnings;
use File::Copy;
use Expect; 

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;

use constant JTT 		=> "JTT"; 			# 0)	Jones-Taylor-Thornton matrix
use constant PMB 		=> "PMB";			# 1) 	Henikoff/Tillier PMB matrix
use constant PAM 		=> "PAM";			# 2) 	Dayhoff PAM matrix
use constant KIMURA 	=> "Kimura";		# 3) 	Kimura formula
use constant SIMILARITY => "Similarity"; 	# 4) 	Similarity table
use constant CATEGORIES => "Categories"; 	# 5) 	Categories model


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
	
	# Get args.
	#===========================================================================
	
	my $infile 	= $args{-infile} 	or $self->throw("No infile provided.");
	my $outfile = $args{-outfile}	or $self->throw("No outfile provided.");
	my $p 		= $args{-P} 		|| JTT;
	
	#===========================================================================
	
	
	
	# Specify infile.
	#===========================================================================
	
	my $args = [];
	$add->($args, $infile);
	
	#===========================================================================
	
	
	
	# Determine model.
	#===========================================================================
	
	if ($p eq JTT) {
		# Do nothing!
		}
	elsif ($p eq PMB) {
		$add->($args, "p", 1);
		}
	elsif ($p eq PAM) {
		$add->($args, "p", 2);
		}
	elsif ($p eq KIMURA) {
		$add->($args, "p", 3);
		}
	elsif ($p eq SIMILARITY) {
		$add->($args, "p", 4);
		}
	elsif ($p eq CATEGORIES) {
		$add->($args, "p", 5);
		}
	else {
		$self->throw("Do not recognise model: $p");
		}
	
	#===========================================================================
	
	
	
	
	# Confirm settings are correct.
	#===========================================================================
	
	$add->($args, "y", 1);

	#===========================================================================
	
	
	
	# Run program using Expect
	#===========================================================================
	
	# Initialise expect object.
	my $expect = Expect->new;
	
	# Set pty to raw mode before spawning.  Disables echoing and CR->LF translation
	# and gives a more pipe-like behaviour.
	#$expect->raw_pty(1);
	
	# Forks and executes supplied command.
	$expect->spawn("protdist") or $self->throw("Could not spawn 'protdist'.");
	
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
	
	if (-e "outfile") {
		print ">>> \"outfile\" renamed as \"$outfile\"\n";	
		move("outfile", $outfile);		
		}
	else {
		$self->throw(
			"'outfile' could not be found, " .
			"suggesting protdist failed to complete."
			);	
		}
	
	#===========================================================================
		
	
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

=pod
 P  Use JTT, PMB, PAM, Kimura, categories model?  Jones-Taylor-Thornton matrix
  G  Gamma distribution of rates among positions?  No
  C           One category of substitution rates?  Yes
  W                    Use weights for positions?  No
  M                   Analyze multiple data sets?  No
  I                  Input sequences interleaved?  Yes
  0                 Terminal type (IBM PC, ANSI)?  ANSI
  1            Print out the data at start of run  No
  2          Print indications of progress of run  Yes

=cut
