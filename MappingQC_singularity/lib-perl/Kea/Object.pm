#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 09/02/2008 18:29:40 
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
package Kea::Object;

use strict;
use warnings;
use Term::ANSIColor;

our $DNA = "dna";

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;

use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant UNKNOWN	=> "unknown";
use constant NA			=> "not applicable";


################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR




################################################################################

# PRIVATE METHODS

my $privateMethod = sub {
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub check {

	my $self 		= shift;
	my $argument 	= shift;
	my $type 		= shift;
	
	if (!defined $argument && defined $type) {
		$self->throw(
			"Missing argument - expecting object with type '$type'."
			);
		}
	
	if (!defined $argument ) {
		$self->throw("Missing argument.");
		}
	
	if (defined $type) {
	
		if (!ref($argument)) {
			$self->throw("Not a reference: $argument.");
			} 
		
		if (!$argument->isa($type)) {
			$self->throw(
				"Wrong type.  Expecting: $type, found: " . ref($argument)
				);
			}		
		}
	
	return $argument;
	
	}

#///////////////////////////////////////////////////////////////////////////////

sub convertToBoolean {
	
	my $self 		= shift;
	my $argument 	= shift;
	
	if ($argument =~ /^t(rue){0,1}$/i) {
		return TRUE;
		}
	elsif ($argument =~ /^f(alse){0,1}$/i) {
		return FALSE;
		}
	else {
		$self->throw("Not a recognised boolean value: " . $argument . ".");
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub alternativeIfUndefined {
	
	my $self 		= shift;
	my $argument 	= shift;
	my $alternative	= shift;
	
	if (defined $argument) {
		return $argument;
		}
	
	else {return $alternative;}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub checkIsInt {
	
	my $self 	= shift;
	my $arg		= shift;
	
	#return $arg if $arg == int($arg);
	return $arg if $arg =~ /^-{0,1}\d+$/;
	
	$self->throw("No argument passed to method.") if !defined $arg;
	
	$self->throw("Provided with '$arg' but was expecting an integer.");
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub checkIsNonNegativeInt {
	
	my $self = shift;
	my $arg = $self->checkIsInt(shift);
	
	return $arg if $arg >= 0;
	
	$self->throw("Provided with '$arg' but was expecting a non-negative integer.");
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub checkIsPositiveInt {
	
	my $self = shift;
	my $arg = $self->checkIsInt(shift);
	
	return $arg if $arg > 0;
	
	$self->throw("Provided with '$arg' but was expecting a positive integer.");
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub checkIsChar {
	
	my $self 	= shift;
	my $arg		= shift;
	
	if (length($arg) == 1) {return $arg;}
	
	$self->throw("Provided with '$arg' but was expecting a character.");
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub checkIsBoolean {
	
	my $self 	= shift;
	my $arg 	= shift;
	
	$self->throw("Undefined argument") if !defined $arg;
	
	return $arg if $arg =~ /[01]/;
	
	$self->throw("Provided with'$arg' but was expecting boolean 1 or 0.");
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub checkIsOrientation {
	
	my $self = shift;
	my $arg = shift;
	
	$self->throw("Undefined argument") if !defined $arg;
	
	return $arg if $arg eq SENSE;
	return $arg if $arg eq ANTISENSE;
	return $arg if $arg eq UNKNOWN;
	return $arg if $arg eq NA;
	
	$self->throw(
		"Provided with'$arg' but was expecting " .
		"orientation 'sense', 'antisense', 'unknown' or 'not applicable'."
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub checkIsNumber {
	
	my $self 	= shift;
	my $arg 	= shift;
	
	return $arg if $arg =~ /^-*\d*\.*\d+$/;
	return $arg if $arg =~ /^-*\d+e\-\d+$/i;
	
	# 4.97480644131745e-17
	return $arg if $arg =~ /^-*\d+\.\d+e-\d+$/i;
	
	$self->throw("Provided with '$arg' but was expecting a number.");
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub checkIsNumberInRange {
	
	my $self	= shift;
	my $arg 	= $self->checkIsNumber(shift);
	my $lower	= $self->checkIsNumber(shift);
	my $upper	= $self->checkIsNumber(shift);
	
	if ($arg >= $lower && $arg <= $upper) {
		return $arg;
		}
	
	$self->throw("'$arg' not within range $lower to $upper.");
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub checkIsDir {
	
	my $self 		= shift;
	my $argument 	= shift;
	
	if (-d $argument && -e $argument) {
		return $argument;
		}
	
	else {
		$self->throw("'$argument' is not a directory.");
		}
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub checkIsFile {
	
	my $self 		= shift;
	my $argument 	= shift;
	my $format		= shift;
	
	if (!-f $argument) {
		$self->throw("'$argument' is not a file.");
		}
	
	elsif (!-e $argument) {
		$self->throw("'$argument' does not exist.");	
		}
	
	elsif (defined $format && $argument !~ /^.+\.$format$/i) {
		$self->throw("'$argument' is not in $format format.");
		}
	
	else {
		return $argument;
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub checkIsArrayRef {
	
	my $self 		= shift;
	my $argument 	= shift;
	
	if (ref $argument eq "ARRAY") {
		return $argument;
		}
	else {
		$self->throw("'$argument' is not an array ref.");
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub checkIsHashRef {
	
	my $self 		= shift;
	my $argument 	= shift;
	
	if (ref $argument eq "HASH") {
		return $argument;
		}
	else {
		$self->throw("'$argument' is not a hash ref.");
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub throw{
	
	my $self 	= shift;
	my $message = shift || "Exception thrown";
	
	my @stackItems = $self->stack_trace_dump();
	
	my $out =
		"\n\n" .
		"\t================================= EXCEPTION ===================================\n".
		"\n\tMESSAGE:\n\t$message\n\n" .
		"\t===============================================================================\n\n";
		
	for (my $i = 0; $i < @stackItems; $i++) {
		$out .= "\t$stackItems[$i]";
		$out .= "\t-------------------------------------------------------------------------------\n"
			if $i != (@stackItems-1);
		}
		
	$out .=	"\t===============================================================================\n\n";
	
	die $out;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub stack_trace_dump{

	my $self = shift;
	
	my @stack = $self->stack_trace();
	
	shift @stack;
	shift @stack;
	shift @stack;
	
	my @stackItems;
	my ($module,$function,$file,$position);
	
	
	foreach my $stack ( @stack) {
		($module,$file,$position,$function) = @{$stack};
		
		push(
			@stackItems,
			"STACK:\n\t$function \n\t$file \n\tline $position\n"
			);
				
		}
	
	return @stackItems;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub stack_trace{

	my $self = shift;
	
	my $i = 0;
	my @out = ();
	my $prev = [];
	
	while( my @call = caller($i++)) {
		# major annoyance that caller puts caller context as
		# function name. Hence some monkeying around...
		$prev->[3] = $call[3];
		push(@out,$prev);
		$prev = \@call;
		}
	
	$prev->[3] = 'toplevel';
	push(@out,$prev);
	return @out;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub print {
	
	my $self = shift;
	
	print color "cyan";
	print $self->toString . "\n";
	print color "reset";
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub warn {
	
	my $self 	= shift;
	my $message = "WARNING: " . shift;
	my $colour 	= "red";
	my $char 	= "#"; 
	 
	
	my $boxWidth = length($message) + 2;
	
	my $border = $char;
	my $edge = "$char";
	
	for (1..$boxWidth) {$border .= $char; $edge .= " ";}
	$edge .= $char;
	$border .= $char;
	
	print STDERR color $colour;
	print STDERR "\n\t$border\n\t$edge\n\t$char $message $char\n\t$edge\n\t$border\n";
	print STDERR color "reset";

	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub message {
	
	my $self = shift;
	my $message = "INFO: " . shift;
	my $colour = shift || "blue";
	my $char = shift || "-"; 
	
	my $boxWidth = length($message) + 2;
	
	my $border = $char;
	my $edge = "$char";
	
	for (1..$boxWidth) {$border .= $char; $edge .= " ";}
	$edge .= $char;
	$border .= $char;
	
	print color $colour;
	print "\n\t$border\n\t$edge\n\t$char $message $char\n\t$edge\n\t$border\n";
	print color "reset";

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub dateStamp {
	
	my $self = shift;
	
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);
	my $text =
		sprintf (
			"%02d\/%02d\/%4d %02d:%02d:%02d",
			$mon+1,
			$mday,
			$year+1900,
			
			$hour,
			$min,
			$sec
			);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

