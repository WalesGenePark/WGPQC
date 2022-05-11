#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 25/02/2008 11:18:30 
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
package Kea::ThirdParty::Phylip::_PromlWrapper;
use Kea::Object;
use Kea::ThirdParty::IWrapper;
our @ISA = qw(Kea::Object Kea::ThirdParty::IWrapper);

use strict;
use warnings;
use Expect;
use File::Copy;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant JTT 		=> "JTT"; 			# 0)	Jones-Taylor-Thornton matrix
use constant PMB 		=> "PMB";			# 1) 	Henikoff/Tillier PMB matrix
use constant PAM 		=> "PAM";			# 2) 	Dayhoff PAM matrix

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
	my $outtree = $args{-outtree}	or $self->throw("No outtree file provided.");
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
	$expect->spawn("proml") or $self->throw("Could not spawn 'proml'.");
	
	# Sends the given strings to the spawned command.
	$expect->print(@$args);
	
	# Timeout after 2 minutes.
	$expect->expect(120);
	
#	$expect->debug(2);
	
	# When no longer needed, do a soft-close to nicely shut down command or
	# dies after 15 seconds. Not needed as using expect().
#	$expect->soft_close();
			
	#===========================================================================		
		
		
		
	# Rename outfiles to that specified.	
	#===========================================================================
	
	# Outfile:
	if (-e "outfile") {
		print ">>> \"outfile\" renamed as \"$outfile\"\n";	
		move("outfile", $outfile);		
		}
	else {
		$self->throw(
			"'outfile' could not be found, " .
			"suggesting proml failed to complete."
			);	
		}
	
	# Outtree:
	if (-e "outtree") {
		print ">>> \"outtree\" renamed as \"$outtree\"\n";	
		move("outtree", $outtree);		
		}
	else {
		$self->throw(
			"'outtree' could not be found, " .
			"suggesting proml failed to complete."
			);	
		}
	
	#===========================================================================
		
	
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

