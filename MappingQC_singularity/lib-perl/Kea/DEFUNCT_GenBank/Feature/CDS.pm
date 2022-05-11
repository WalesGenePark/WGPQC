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
package Kea::GenBank::Feature::CDS;

## Purpose		: Encapsulates all entries within CDS feature of GenBank file.

use strict;
use warnings;

use constant TRUE => 1;
use constant FALSE => 0;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

## Purpose		: Constructor.
## Returns		: n/a.
## Parameter	: n/a.
## Throws		: n/a.
sub new {
	my $className = shift;
	my $self = {
		};
	bless(
		$self,
		$className
		);
	return $self;
	} # End of constructor.

################################################################################

# METHODS

## Purpose		: ?????????????.
## Returns		: n/a.
## Parameter	: n/a.
## Throws		: n/a.
sub process {
	my $self = shift;
	my @rawData = @_;
	
	my $readingTranslation = FALSE;
	my $translation;
	
	foreach (@rawData) {
		
		if (/^\s+CDS\s+(.+)/) {
			$self->{_cdsPosition} = $1;
			}
		elsif (m/\/gene="(.+)"/) {
			$self->{_geneName} = $1;
			}
		elsif (m/\/locus_tag="(.+)"/) {
			$self->{_locusTag} = $1;
			}
		elsif (m/\/product="(.+)"/) {
			$self->{_productDescription} = $1;
			}
		# Get protein id (= accession) without version number (e.g. .1).
		elsif (m/\/protein_id="(\w+\d+)\.*\d*"/) {
			$self->{_proteinId} = $1;
			}
		elsif (m/\/db_xref="GI:(\d+)"/) {
			$self->{_proteinGI} = $1;
			}
		# Translation occupies a single line.
        elsif (/^\s+\/translation="(\w+)"/) {
            $self->{_translation} = $1;
            }
        
        # Translation occupies multiple lines.
        elsif (/^\s+\/translation="(\w+)\s*/) {
            $readingTranslation = TRUE;
            $translation = $1;
            }
        
        elsif ($readingTranslation) {
            $translation = $translation . $_;
            if ($translation =~ m/"\s*$/) {
                $readingTranslation = FALSE;
                $translation =~ s/\s//g;
                $translation =~ s/"//;
                $self->{_translation} = $translation;
                }
            }
		} 
	
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getCDSPosition {
	return shift->{_cdsPosition};
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub getProductDescription {
	return shift->{_productDescription};
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub getProteinId {
	return shift->{_proteinId};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getProteinGI {
	return shift->{_proteinGI};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getGeneName {
	return shift->{_geneName};
	#my $self = shift;
	#if (exists $self->{_geneName}) {return $self->{_geneName};} 
	#else {return "unknown";}
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLocusTag {
	return shift->{_locusTag};
	#my $self = shift;
	#if (exists $self->{_locusTag}) {return $self->{_locusTag};} 
	#else {return "unknown";}
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getTranslation {
	return shift->{_translation};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

=pod
     CDS             complement(1766330..1767406)
                     /gene="leuB"
                     /locus_tag="CJE1888"
                     /EC_number="1.1.1.85"
                     /note="identified by similarity to SP:P30125; match to
                     protein family HMM PF00180; match to protein family HMM
                     TIGR00169"
                     /codon_start=1
                     /transl_table=11
                     /product="3-isopropylmalate dehydrogenase"
                     /protein_id="AAW34488.1"
                     /db_xref="GI:57165709"
                     /translation="MKAYKVAVLAGDGIGPLVMKEALKILTFISQKYNFSFEFNEAKI
                     GGASIDAYGVALSDETLKLCEQSDAILFGSVGGPKWDNLPIDQRPERASLLPLRKHFN
                     LFANLRPCKIYESLTHASPLKNEIIQKGVDILCVRELTGGIYFGKQDLGKESAYDTEI
                     YTKKEIERIAHIAFESARIRKKKVHLIDKANVLASSILWREVVANVVKDYQDINLEYM
                     YVDNAAMQIVKNPSIFDVMLCSNLFGDILSDELAAINGSLGLLSSASLNDKGFGLYEP
                     AGGSAPDIAHLNIANPIAQILSAALMLKYSFKEEQAAQDIENAISLALAQGKMTKDLN
                     AKSYLNTDEMGDCILEILKENNNG"

=cut
