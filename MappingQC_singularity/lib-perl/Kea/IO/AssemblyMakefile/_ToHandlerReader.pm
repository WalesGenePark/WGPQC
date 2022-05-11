#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 05/06/2008 10:09:51
#    Copyright (C) 2008, University of Liverpool.
#    Author: Kevin Ashelford.
#
#    Contact details:
#    Email:   k.ashelford@liv.ac.uk
#    Address: School of Biological Sciences, University of Liverpool, 
#             Biosciences Building, Crown Street, Liverpool, UK. L69 7ZB
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
package Kea::IO::AssemblyMakefile::_ToHandlerReader;
use Kea::Object;
use Kea::IO::IReader;
our @ISA = qw(Kea::Object Kea::IO::IReader);
 
use strict;
use warnings;
#use XML::SAX::ParserFactory;
use XML::Simple;
use Data::Dumper;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

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

################################################################################

# PUBLIC METHODS

sub read {

	my $self = shift;
	my $FILEHANDLE = $self->check(shift);
	my $handler = $self->check(shift, "Kea::IO::AssemblyMakefile::IReaderHandler"); 
	
	my @lines = <$FILEHANDLE>;
	my $string = join("", @lines);
	
	#print "$string\n";
	
	my $xml = XML::Simple->new();
	
	# read XML file
	my $data = $xml->XMLin($string, keyattr => []);
	
	$handler->_primaryAccession($data->{primary_accession}->{id});
	$handler->_contigSeparator($data->{contig_separator}->{sequence});
	$handler->_referenceDirectory($data->{reference_directory}->{uri});
	$handler->_sourceContigFile($data->{source_contig_file}->{uri});
	$handler->_outfileName($data->{outfile}->{uri});
	$handler->_bestReference($data->{best_reference}->{uri});
	
	my $positions = $data->{positions}->{position};
	
	foreach my $position (@$positions) {
		$handler->_nextPosition(
			$position->{id},
			$position->{orientation},
			$position->{join_to_next}
			);
		}
	
	my $contigs = $data->{data}->{contig};
	
	foreach my $contig (@$contigs) {
	
		my $seq = $contig->{sequence};
		$seq =~ s/\s//g;
	
		$handler->_nextContig(
			$contig->{id},
			$contig->{note},
			$seq
			);
		}
	
	my $scripts = $data->{scripts}->{script};
	
	#print Dumper($scripts);
	
	if (ref($scripts) eq "ARRAY") {
		foreach my $script (@$scripts) {
			
			if (exists $script->{name}) {
			
				$handler->_nextScript(
					$script->{name},
					$script->{description}
					);
			
				}
		
			
			}
		}
	
	else {
		$handler->_nextScript(
			$scripts->{name},
			$scripts->{description}
			);
		}
	
	
	#my $saxHandler = MyHandler->new($handler);
	#my $parser = XML::SAX::ParserFactory->parser(Handler => $saxHandler);
	#$parser->parse_string($string);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
=pod
BEGIN {

package MyHandler;
	
use base qw(XML::SAX::Base);
use Data::Dumper;

sub new {
	
	my $classname = shift;
	my $handler = shift;
	
	my $self = {_handler => $handler};
	
	bless($self, $classname);
	return $self;		
	}


sub start_element {
	
	my $self = shift;
	my $data = shift;
	
	print Dumper($data);
	
	if ($data->{LocalName} eq "primary_accession") {
		my $attributes = $data->{Attributes};
		my $id = $attributes->{"{}id"};
		$self->{_handler}->_primaryAccession($id->{Value});
		}
	
	elsif ($data->{LocalName} eq "contig_separator") {
		my $attributes = $data->{Attributes};
		my $seq= $attributes->{"{}sequence"};
		$self->{_handler}->_contigSeparator($seq->{Value});
		}
	
	elsif ($data->{LocalName} eq "reference_directory") {
		my $attributes = $data->{Attributes};
		my $uri = $attributes->{"{}uri"};
		$self->{_handler}->_referenceDirectory($uri->{Value});
		}
	
	elsif ($data->{LocalName} eq "source_contig_file") {
		my $attributes = $data->{Attributes};
		my $uri = $attributes->{"{}uri"};
		$self->{_handler}->_sourceContigFile($uri->{Value});
		}
	
	elsif ($data->{LocalName} eq "position") {
		my $attributes = $data->{Attributes};
		my $id = $attributes->{"{}id"};
		my $orientation = $attributes->{"{}orientation"};
		$self->{_handler}->_nextPosition(
			$id->{Value},
			$orientation->{Value}
			);	
		}
	
	#print $data->{LocalName} . "\n";
	#
	#if ($data->{LocalName} eq "primary_accession") {
	#
	#	print $data->{LocalName} . "\n";
	#	my $attributes = $data->{Attributes};
	#	print $attributes->{Value} . "\n";
	#	
	#	print $data->{Data} . "\n";
	#	
	##	foreach (keys %$attributes) {
	##		print "$_ ==> $attributes->{$_}\n";
	##		}
	#	}
	
	<STDIN>;
	
	}
	
};
=cut
1;

