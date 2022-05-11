#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 12/02/2009 11:20:24
#    Copyright (C) 2009, University of Liverpool.
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
package Kea::IO::NCBI::SequinFeatureTable::_ToHandlerReader;
use Kea::Object;
use Kea::IO::IReader;
our @ISA = qw(Kea::Object Kea::IO::IReader);
 
use strict;
use warnings;

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

my $privateMethod = sub {
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub read {

	my $self = shift;
	my $FILEHANDLE = $self->check(shift);
	my $handler = $self->check(shift, "Kea::IO::NCBI::SequinFeatureTable::IReaderHandler");
	
	while (<$FILEHANDLE>) {
		
		chomp;
		
		#ÊIgnore comments
		next if (/^#/);
		
		# >Feature Sc_16
		# >Feature SeqId table_name
		if (/^>Feature\s+(\S+)\s*(\S*)\s*$/) {
			$handler->_nextHeader($1, $2);
			}
		
		# 1	7000	REFERENCE
		# <1	1050	gene
		#Ê<1	1009	CDS
		# <1	1050	mRNA
		# 2626	2590	tRNA
		elsif (/^([<>]*)(\d+)\s+(\d+)\s+(\S+)$/) {
			$handler->_nextFeature($1, $2, $3, $4);
			}
		
		
		#2570	2535
		elsif (/^(\d+)\s+(\d+)\s*$/) {
			$handler->_nextLocation($1, $2);
			}
		
		#	PubMed		8849441
		#	gene		ATH1
		#	locus_tag	YPR026W
		#	product		acid trehalase
		#	product		Ath1p
		#	codon_start	2
		#	protein_id	gnl|SGD|S0006230
		elsif (/^\s+(\S+)\s+(.+)$/) {
			$handler->_nextQualifier($1, $2);
			}
		
		# [offset=2000]
		elsif (/\[offset=(\d+)\]/) {
			$handler->_nextOffset($1);
			}
		
		}
	
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

=pod
>Feature Sc_16
1	7000	REFERENCE
			PubMed		8849441
<1	1050	gene
			gene		ATH1
			locus_tag	YPR026W
<1	1009	CDS
			product		acid trehalase
			product		Ath1p
			codon_start	2
			protein_id	gnl|SGD|S0006230
<1	1050	mRNA
			product		acid trehalase
[offset=2000]
1253	420	gene
			locus_tag	YPR027C
1253	420	CDS
			product		Ypr027cp
			note		hypothetical protein
			protein_id	gnl|SGD|S0006231
1253	420	mRNA
			product		Ypr027cp
2626	2535	gene
			gene	trnF
			locus_tag	YPR027T
2626	2590	tRNA
2570	2535
			product		tRNA-Phe
2626	2590	exon
			number 1
2570	2535	exon
			number 2
3450	4536	gene
			gene		YIP2
			locus_tag	YPR028W
3522	3572	CDS
3706	4197
			product		Yip2p
                        prot_desc       similar to human polyposis locus protein 1 (YPD)
			protein_id	gnl|SGD|S0006232
3450	3572	mRNA
3706	4536
			product		Yip2p
=cut