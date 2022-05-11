#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 22/10/2008 15:47:19
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
package Kea::IO::SOLiD::Snps::DefaultReaderHandler;
use Kea::IO::SOLiD::Snps::IReaderHandler;
use Kea::Object;
our @ISA = qw(Kea::Object Kea::IO::SOLiD::Snps::IReaderHandler);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::IO::SOLiD::Snps::SnpCollection;
use Kea::IO::SOLiD::Snps::_Snp;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	
	my $className = shift;
	
	my $snpCollection = Kea::IO::SOLiD::Snps::SnpCollection->new("");
	
	my $self = {
		_snpCollection => $snpCollection
		};
	
	bless(
		$self,
		$className
		);
	
	return $self;
	
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $privateMethod = sub {
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub _nextLine {
	
	my $self = shift;
	
	# cov   ref     consen  score   confi   F3      R3      score   conf    F3      R3      coord
	
	my (
	$cov,				# coverage
	$ref,				# ref allele
	$consen,			# consensus allele
	$refScore,			# ref allele score
	$refConfi,			# ref allele confidence value.
	$refF3Total,		# F3 total number of reads with ref allele 
	$refF3Unique,		# F3 number of unique reads with ref allele
	$refR3Total,		# R3 total number of reads with ref allele.
	$refR3Unique,		# R3 number of unique reads with ref allele.
	$consenScore,		# consensus allele score
	$consenConfi,		# consensus allele confidence value.
	$consenF3Total,		# F3 total number of reads with consensus allele.
	$consenF3Unique,	# F3 number of unique reads with consensus allele.
	$consenR3Total,		# R3 total number of reads with consensus allele.
	$consenR3Unique,	# R3 number of unique reads with consensus allele.
	$coord				# snp coordinate within reference.
	) = @_;
	
	
	#print $cov . "\n";		
	#print $ref . "\n";		
	#print $consen . "\n";		
	#print $refScore . "\n";		
	#print $refConfi . "\n";		
	#print $refF3Total . "\n";		
	#print $refF3Unique . "\n";		
	#print $refR3Total . "\n";		
	#print $refR3Unique . "\n";		
	#print $consenScore . "\n";		
	#print $consenConfi . "\n";		
	#print $consenF3Total . "\n";		
	#print $consenF3Unique . "\n";		
	#print $consenR3Total . "\n";		
	#print $consenR3Unique . "\n";		
	#print $coord . "\n";		
	#
	#<STDIN>;
	
	$self->{_snpCollection}->add(
		Kea::IO::SOLiD::Snps::_Snp->new(
			-cov			=> $cov,				# coverage
			-ref			=> $ref,				# ref allele
			-consen			=> $consen,				# consensus allele
			-refScore		=> $refScore,			# ref allele score
			-refConfi		=> $refConfi,			# ref allele confidence value.
			-refF3Total		=> $refF3Total,			# F3 total number of reads with ref allele 
			-refF3Unique	=> $refF3Unique,		# F3 number of unique reads with ref allele
			-refR3Total		=> $refR3Total,			# R3 total number of reads with ref allele.
			-refR3Unique	=> $refR3Unique,		# R3 number of unique reads with ref allele.
			-consenScore	=> $consenScore,		# consensus allele score
			-consenConfi	=> $consenConfi,		# consensus allele confidence value.
			-consenF3Total	=> $consenF3Total,		# F3 total number of reads with consensus allele.
			-consenF3Unique	=> $consenF3Unique,		# F3 number of unique reads with consensus allele.
			-consenR3Total	=> $consenR3Total,		# R3 total number of reads with consensus allele.
			-consenR3Unique	=> $consenR3Unique,		# R3 number of unique reads with consensus allele.
			-coord			=> $coord				# snp coordinate within reference.	
			)
		);
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSnpCollection {
	return shift->{_snpCollection};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

