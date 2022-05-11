#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 22/10/2008 16:09:04
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
package Kea::IO::SOLiD::Snps::_Snp;
use Kea::Object;
use Kea::IO::SOLiD::Snps::ISnp;
our @ISA = qw(Kea::Object Kea::IO::SOLiD::Snps::ISnp);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::Number;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my %args = @_;
	
	my $self = {
		_cov			=> $args{-cov},					# coverage
		_ref			=> $args{-ref},					# ref allele
		_consen			=> $args{-consen},				# consensus allele
		_refScore		=> $args{-refScore},			# ref allele score
		_refConfi		=> $args{-refConfi},			# ref allele confidence value.
		_refF3Total		=> $args{-refF3Total},			# F3 total number of reads with ref allele 
		_refF3Unique	=> $args{-refF3Unique},			# F3 number of unique reads with ref allele
		_refR3Total		=> $args{-refR3Total},			# R3 total number of reads with ref allele.
		_refR3Unique	=> $args{-refR3Unique},			# R3 number of unique reads with ref allele.
		_consenScore	=> $args{-consenScore},			# consensus allele score
		_consenConfi	=> $args{-consenConfi},			# consensus allele confidence value.
		_consenF3Total	=> $args{-consenF3Total},		# F3 total number of reads with consensus allele.
		_consenF3Unique	=> $args{-consenF3Unique},		# F3 number of unique reads with consensus allele.
		_consenR3Total	=> $args{-consenR3Total},		# R3 total number of reads with consensus allele.
		_consenR3Unique	=> $args{-consenR3Unique},		# R3 number of unique reads with consensus allele.
		_coord			=> $args{-coord}				# snp coordinate within reference.	
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

sub publicMethod {
	my $self = shift;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getCoverage 			{return shift->{_cov};}

sub getReferenceAllele 		{return shift->{_ref};}

sub getConsensusAllele		{return shift->{_consen};}


sub getReferenceScore		{return shift->{_refScore};}

sub getReferenceConfidence	{return shift->{_refConfi};}

sub getReferenceF3Total		{return shift->{_refF3Total};}

sub getReferenceF3Unique	{return shift->{_refF3Unique};}

sub getReferenceR3Total		{return shift->{_refR3Total};}

sub getReferenceR3Unique	{return shift->{_refR3Unique};}


sub getConsensusScore		{return shift->{_consenScore};}

sub getConsensusConfidence	{return shift->{_consenConfi};}

sub getConsensusF3Total		{return shift->{_consenF3Total};}

sub getConsensusF3Unique	{return shift->{_consenF3Unique};}

sub getConsensusR3Total		{return shift->{_consenR3Total};}

sub getConsensusR3Unique	{return shift->{_consenR3Unique};}

sub getCoordinate			{return shift->{_coord};}


sub toString {
	
	my $self =shift;
	
	# # cov   ref     consen  score   confi   F3      R3      score   conf    F3      R3      coord
		# 221     A       G       0.0000  0.0000  0/0     -/-     0.9877  0.8810  218/67  -/-     4211786
	
	my $text = sprintf(
		"%d\t%s\t%s\t%s\t%s\t%s/%s\t%s/%s\t%s\t%s\t%s/%s\t%s/%s\t%d",
		$self->getCoverage,
		$self->getReferenceAllele,
		$self->getConsensusAllele,
		Kea::Number->roundup($self->getReferenceScore, 4),
		Kea::Number->roundup($self->getReferenceConfidence, 4),
		$self->getReferenceF3Total,
		$self->getReferenceF3Unique,
		$self->getReferenceR3Total,
		$self->getReferenceR3Unique,
		Kea::Number->roundup($self->getConsensusScore, 4),
		Kea::Number->roundup($self->getConsensusConfidence, 4),
		$self->getConsensusF3Total,
		$self->getConsensusF3Unique,
		$self->getConsensusR3Total,
		$self->getConsensusR3Unique,
		$self->getCoordinate
		);
	
	return $text;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

