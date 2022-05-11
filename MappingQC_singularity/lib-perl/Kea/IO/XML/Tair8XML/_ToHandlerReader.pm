#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 19/12/2008 16:45:25
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
package Kea::IO::XML::Tair8XML::_ToHandlerReader;
use Kea::Object;
use Kea::IO::IReader;
our @ISA = qw(Kea::Object Kea::IO::IReader);

use XML::SAX::ParserFactory;
 
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

# Why not object-specific variables????? Idiot!
my $_FILEHANDLE = undef;
my $_handler 	= undef;

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

my $processCdsCoordset = sub {
	
	my $self = shift;
		
	while (<$_FILEHANDLE>) {
		
		return if (/<\/COORDSET>/);
		
		if (/<END5>(\d+)<\/END5>/) {
			$_handler->_nextCdsEnd5($1);
			}
		
		elsif (/<END3>(\d+)<\/END3>/) {
			$_handler->_nextCdsEnd3($1);
			
			}
		else {
			die "\nERROR: Unexpected item in COORDSET: $_ - $!";
			}
		
		}
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $processUtrsCoordset = sub {
	
	my $self = shift;
	
	while (<$_FILEHANDLE>) {
		
		return if (/<\/COORDSET>/);
		
		if (/<END5>(\d+)<\/END5>/) {
			$_handler->_nextUtrsEnd5($1);
			}
		
		elsif (/<END3>(\d+)<\/END3>/) {
			$_handler->_nextUtrsEnd3($1);
			
			}
		else {
			die "\nERROR: Unexpected item in COORDSET: $_ - $!";
			}
		
		}
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $processExonCoordset = sub {
	
	my $self = shift;
	
	while (<$_FILEHANDLE>) {
		
		return if (/<\/COORDSET>/);
		
		if (/<END5>(\d+)<\/END5>/) {
			$_handler->_nextExonEnd5($1);
			}
		
		elsif (/<END3>(\d+)<\/END3>/) {
			$_handler->_nextExonEnd3($1);
			
			}
		else {
			die "\nERROR: Unexpected item in COORDSET: $_ - $!";
			}
		
		}
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $processTuCoordset = sub {
	
	my $self = shift;
	
	while (<$_FILEHANDLE>) {
		
		return if (/<\/COORDSET>/);
		
		if (/<END5>(\d+)<\/END5>/) {
			$_handler->_nextTuEnd5($1);
			}
		
		elsif (/<END3>(\d+)<\/END3>/) {
			$_handler->_nextTuEnd3($1);
			
			}
		else {
			die "\nERROR: Unexpected item in COORDSET: $_ - $!";
			}
		
		}
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $processCds = sub {
	
	my $self = shift;
		
	while (<$_FILEHANDLE>) {
		
		return if (/<\/CDS>/);
		
		if (/<FEAT_NAME>(\S+)<\/FEAT_NAME>/) {
			$_handler->_nextCdsFeatureName($1);
			}
		
		elsif (/<COORDSET>/) {
			$_handler->_cdsCoordsetStart();
			$self->$processCdsCoordset();
			$_handler->_cdsCoordsetEnd();
			}
		
		}
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $processUtrs = sub {
	
	my $self = shift;
	
	while (<$_FILEHANDLE>) {
	
		return if (/<\/UTRS>/);
	
		if (/<COORDSET>/) {
			$_handler->_utrsCoordsetStart();
			$self->$processUtrsCoordset();
			$_handler->_utrsCoordsetEnd();
			}	
	
		}
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $processEXON = sub {
	
	my $self = shift;
	
	while (<$_FILEHANDLE>) {
		
		return if (/<\/EXON>/);
		
		if (/<CDS>/) {
			$_handler->_cdsStart();
			$self->$processCds();
			$_handler->_cdsEnd();
			}
		
		elsif (/<UTRS>/) {
			$_handler->_utrsStart();
			$self->$processUtrs();
			$_handler->_utrsEnd();
			}
		
		elsif (/<FEAT_NAME>(\S+)<\/FEAT_NAME>/) {
			$_handler->_nextExonFeatureName($1);
			}
		
		
		elsif (/<COORDSET>/) {
			$_handler->_exonCoordsetStart();
			$self->$processExonCoordset();
			$_handler->_exonCoordsetEnd();
			}	
		
		}
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $processMODEL = sub {
	
	my $self = shift;
	
	while (<$_FILEHANDLE>) {
		
		return if (/<\/MODEL>/);
	
		if (/<EXON>/) {
			$_handler->_exonStart();
			$self->$processEXON();
			$_handler->_exonEnd();
			}
		
	
		elsif (/<FEAT_NAME>(\S+)<\/FEAT_NAME>/) {
			$_handler->_nextModelFeatureName($1);
			}
		
		elsif (/<PUB_LOCUS>(\S+)<\/PUB_LOCUS>/) {
			$_handler->_nextModelPubLocus($1);
			}
		
		elsif (/<CDS_SEQUENCE>(\w+)<\/CDS_SEQUENCE>/) {
			$_handler->_nextCdsSequence($1);
			}
		
		elsif (/<PROTEIN_SEQUENCE>(\w+)\*<\/PROTEIN_SEQUENCE>/) {
			$_handler->_nextProteinSequence($1);
			}
		
		}
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $processTU = sub {
	
	my $self = shift;
	
	while (<$_FILEHANDLE>) {
		
		return if (/<\/TU>/);
		
		if (/^\s*<MODEL/) {
			$_handler->_modelStart();
			$self->$processMODEL();
			$_handler->_modelEnd();
			}
			
		
		elsif (/<COORDSET>/) {
			$_handler->_tuCoordsetStart();
			$self->$processTuCoordset();
			$_handler->_tuCoordsetEnd();
			}
			
		elsif (/<FEAT_NAME>(\S+)<\/FEAT_NAME>/) {
			$_handler->_nextTuFeatureName($1);
			}
		
		elsif (/<PUB_LOCUS>(\S+)<\/PUB_LOCUS>/) {
			$_handler->_nextTuPubLocus($1);
			}
			
		elsif (/<IS_PSEUDOGENE>(\d)<\/IS_PSEUDOGENE>/) {
			$_handler->_nextTuIsPseudogene($1);
			}	
			
		}

	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $processPSEUDOCHROMOSOME = sub {
	
	my $self = shift;
	
	while (<$_FILEHANDLE>) {
		
		return if (/<\/PSEUDOCHROMOSOME>/);
		
		if (/<TU>/) {
			$_handler->_tuStart();
			$self->$processTU();
			$_handler->_tuEnd();
			}
		
		}
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub read {
	
	my $self = shift;
	
	$_FILEHANDLE 	= Kea::Object->check(shift);
	$_handler		= Kea::Object->check(shift, "Kea::IO::XML::Tair8XML::IReaderHandler");
	
	# NOTE: fragile code - assumes line end characters which are not part of
	# xml format.  Longer term, consider rewriting with suitable xml parser (i.e.
	# SAX) 
	
	while (<$_FILEHANDLE>) {
		
		if (/<PSEUDOCHROMOSOME>/) {
			$_handler->_pseudochromosomeStart();
			$self->$processPSEUDOCHROMOSOME();
			$_handler->_pseudochromosomeEnd();
			}
		
		}
	
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

