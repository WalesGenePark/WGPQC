#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 11/02/2008 15:36:34 
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
package Kea::Properties;
use Kea::Object;
our @ISA = qw(Kea::Object);

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;
	
# Home directory of user. 
use constant HOME_DIRECTORY => $ENV{HOME};
	
# Name of properties file.
use constant PROPERTIES_FILENAME => ".my_perl";
	
# Full path for file.	
my $PROPERTIES_FILE = HOME_DIRECTORY . "/" . PROPERTIES_FILENAME;
	
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
	
	# Create empty properties file if doesn't yet exist.
	if (!-e $PROPERTIES_FILE) {
		open (IN, ">$PROPERTIES_FILE") or
			Kea::Object->throw("Could not create $PROPERTIES_FILE.");
		print IN "# Properties file for Kea perl scripts.\n";
		print IN "#\n";
		close(IN) or
			Kea::Object->throw("Could not close $PROPERTIES_FILE.");
		} 
		
	return $self;
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $privateMethod = sub {
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub getProperty {
	
	my $self = shift;
	my $propertyKey = $self->check(shift);
	
	#if ($propertyKey !~ /^\w+\.\w+$/) {
	#	$self->throw("$propertyKey is not a valid property key.");
	#	}
	
	my $value = undef;
	open (IN, $PROPERTIES_FILE) or $self->throw("Could not open $PROPERTIES_FILE.");
	while (<IN>) {
		if (/^$propertyKey=(.+)$/) {
			$value = $1;
			}
		}
	close (IN) or $self->throw("Could not close $PROPERTIES_FILE.");
	
	if (defined $value) {
		return $value;
		}
	else {
		$self->throw("Could not retrieve value for key '$propertyKey'");	
		}
	
	} # End of method. 

#///////////////////////////////////////////////////////////////////////////////

sub setProperty {
	
	my $self = shift;
	my $key = $self->check(shift);
	my $value = $self->check(shift);
	
	#if ($key !~ /^\w+\.\w+$/) {
	#	$self->throw("$key is not a valid property key.");
	#	}
	
	
	my @old; # Old property list.
	my @new; # New property list.
	
	open (IN, $PROPERTIES_FILE) or $self->throw("Could not open $PROPERTIES_FILE.");
	@old = <IN>;
	close(IN);
	
	# Delete any previous instance of property.
	foreach (@old) {
		if ($_ !~ /^$key/) {
			push(@new, $_);	
			}
		}
	
	# Now add property.
	push(@new, "$key=$value\n");
	
	
	open (OUT, ">$PROPERTIES_FILE") or $self->throw("Could not open $PROPERTIES_FILE.");
	print OUT @new;
	close (OUT) or $self->throw("Could not close $PROPERTIES_FILE.");
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub containsProperty {
	
	my $self = shift;
	my $key = $self->check(shift);
	
	my $exists = FALSE;
	open (IN, $PROPERTIES_FILE) or $self->throw("Could not open $PROPERTIES_FILE.");
	while(<IN>) {
		if (/^$key=.+$/) {$exists = TRUE;}
		}
	close (IN) or $self->throw("Could not close $PROPERTIES_FILE.");
	
	return $exists;
	
	} # End of method. 

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

