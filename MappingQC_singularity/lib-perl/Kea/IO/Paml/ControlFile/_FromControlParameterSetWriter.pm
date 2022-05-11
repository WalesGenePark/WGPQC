#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 23/07/2008 13:39:06
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
package Kea::IO::Paml::ControlFile::_FromControlParameterSetWriter;
use Kea::Object;
use Kea::IO::IWriter;
our @ISA = qw(Kea::Object Kea::IO::IWriter);
 
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
	
	my $controlParameterSet =
		Kea::Object->check(
			shift,
			"Kea::IO::Paml::ControlFile::IControlParameterSet"
			);	
	
	my $self = {
		_controlParameterSet => $controlParameterSet
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

sub write {

	my $self = shift;
	my $FILEHANDLE = $self->check(shift);
	my $controlParameterSet = $self->{_controlParameterSet};
	
	my $text = "";
	
	$text .=
		sprintf(
			"%13s = %-15s * sequence data filename\n",
			"seqfile",
			$controlParameterSet->getSeqfile
			);
	
	if (defined $controlParameterSet->getTreefile) {
		$text .=
			sprintf(
				"%13s = %-15s * tree structure file name\n",
				"treefile",
				$controlParameterSet->getTreefile
				);
		}
	
	$text .=
		sprintf(
			"%13s = %-15s * main result file name\n",
			"outfile",
			$controlParameterSet->getOutfile
			);
	$text .= "\n";	
	
	if (defined $controlParameterSet->getNoisy) {
		$text .=
			sprintf(
				"%13s = %-15s * 0,1,2,3,9: how much rubbish on the screen\n",
				"noisy",
				$controlParameterSet->getNoisy
				);
		}	
	
	
	if (defined $controlParameterSet->getVerbose) {
		$text .=
			sprintf(
				"%13s = %-15s * 0: concise; 1: detailed, 2: too much\n",
				"verbose",
				$controlParameterSet->getVerbose
				);
		}
	
	
	if (defined $controlParameterSet->getRunmode) {
		$text .=
			sprintf(
				"%13s = %-15s * 0: user tree;  1: semi-automatic;  2: automatic\n" .
				"%31s * 3: StepwiseAddition; (4,5):PerturbationNNI; -2: pairwise\n",
				"runmode",
				$controlParameterSet->getRunmode,
				""
				);
		$text .= "\n";
		}
	
	if (defined $controlParameterSet->getSeqtype) {
		$text .=
			sprintf(
				"%13s = %-15s * 1:codons; 2:AAs; 3:codons-->AAs\n",
				"seqtype",
				$controlParameterSet->getSeqtype
				);
		$text .= "\n";
		}
	
	if (defined $controlParameterSet->getCodonFreq) {
		$text .=
			sprintf(
				"%13s = %-15s * 0:1/61 each, 1:F1X4, 2:F3X4, 3:codon table\n",
				"CodonFreq",
				$controlParameterSet->getCodonFreq
				);
		$text .= "\n";
		}
	
	
	
	if (defined $controlParameterSet->getClock) {
		$text .=
			sprintf(
				"%13s = %-15s * 0:no clock, 1:clock; 2:local clock; 3:CombinedAnalysis\n",
				"clock",
				$controlParameterSet->getClock
				);
		}
	
	if (defined $controlParameterSet->getAminoAcidDistance) {
		$text .=
			sprintf(
				"%13s = %-15s * 0:equal, +:geometric; -:linear, 1-6:G1974,Miyata,c,p,v,a\n",
				"aaDist",
				$controlParameterSet->getAminoAcidDistance
				);
		$text .= "\n";
		}
	
	
	
	if (defined $controlParameterSet->getModel) {
		$text .=
			sprintf(
				"%13s = %-15s * models for codons:\n" .
				"%31s * \t0:one, 1:b, 2:2 or more dN/dS ratios for branches\n" .
				"%31s * models for AAs or codon-translated AAs:\n" .
				"%31s * \t0:poisson, 1:proportional, 2:Empirical, 3:Empirical+F\n" .
				"%31s * \t6:FromCodon, 7:AAClasses, 8:REVaa_0, 9:REVaa(nr=189)\n",
				"model",
				$controlParameterSet->getModel,
				"", "", "", ""
				);
		$text .= "\n";	
		}
		
	
	if (defined $controlParameterSet->getNSsites) {
		$text .=
			sprintf(
				"%13s = %-15s * 0:one w;1:neutral;2:selection; 3:discrete;4:freqs;\n" .
				"%31s * 5:gamma;6:2gamma;7:beta;8:beta&w;9:beta&gamma;\n" . 
				"%31s * 10:beta&gamma+1; 11:beta&normal>1; 12:0&2normal>1;\n" . 
				"%31s * 13:3normal>0\n",
				"NSsites",
				$controlParameterSet->getNSsites,
				"", "", ""
				);
		$text .= "\n";
		}
	
	
	if (defined $controlParameterSet->getIcode) {
		$text .=
			sprintf(
				"%13s = %-15s * 0:universal code; 1:mammalian mt; 2-10:see below\n",
				"icode",
				$controlParameterSet->getIcode
				);
		}
		
	if (defined $controlParameterSet->getMGene) {
		$text .=
			sprintf(
				"%13s = %-15s * 0:rates, 1:separate\n",
				"Mgene",
				$controlParameterSet->getMGene
				);
		$text .= "\n";
		}
	
	if (defined $controlParameterSet->getFixKappa) {
		$text .=
			sprintf(
				"%13s = %-15s * 1: kappa fixed, 0: kappa to be estimated\n",
				"fix_kappa",
				$controlParameterSet->getFixKappa
				);
		}
	
	if (defined $controlParameterSet->getKappa) {
		$text .=
			sprintf(
				"%13s = %-15s * initial or fixed kappa\n",
				"kappa",
				$controlParameterSet->getKappa
				);
		}
	
	if (defined $controlParameterSet->getFixOmega) {
		$text .=
			sprintf(
				"%13s = %-15s * 1: omega or omega_1 fixed, 0: estimate\n",
				"fix_omega",
				$controlParameterSet->getFixOmega
				);
		}
	
	if (defined $controlParameterSet->getOmega) {
		$text .=
			sprintf(
				"%13s = %-15s * initial or fixed omega, for codons or codon-based AAs\n",
				"omega",
				$controlParameterSet->getOmega
				);	
		$text .= "\n";
		}
	
	if (defined $controlParameterSet->getncatG) {
		$text .=
			sprintf(
				"%13s = %-15s * # of categories in dG of NSsites models\n",
				"ncatG",
				$controlParameterSet->getncatG
				);
		$text .= "\n";
		}
	
	if (defined $controlParameterSet->getGetSE) {
		$text .=
			sprintf(
				"%13s = %-15s * 0: don't want them, 1: want S.E.s of estimates\n",
				"getSE",
				$controlParameterSet->getGetSE
				);
		}
		
	if (defined $controlParameterSet->getRateAncestor) {
		$text .=
			sprintf(
				"%13s = %-15s * (0,1,2): rates (alpha>0) or ancestral states (1 or 2)\n",
				"RateAncestor",
				$controlParameterSet->getRateAncestor
				);	
		$text .= "\n";
		}
	
	if (defined $controlParameterSet->getSmallDiff) {
		$text .=
			sprintf(
				"%13s = %-15s\n",
				"Small_Diff",
				$controlParameterSet->getSmallDiff
				);
		}
		
	if (defined $controlParameterSet->getCleandata) {
		$text .=
			sprintf(
				"%13s = %-15s * remove sites with ambiguity data (1:yes, 0:no)?\n",
				"cleandata",
				$controlParameterSet->getCleandata
				);
		}
	
	if (defined $controlParameterSet->getFix_blength) {
		$text .=
			sprintf(
				"%13s = %-15s * 0: ignore, -1: random, 1: initial, 2: fixed\n",
				"fix_blength",
				$controlParameterSet->getFix_blength
				);
		}
		
		
	
	
	if (defined $controlParameterSet->getWeighting) {
		$text .=
			sprintf(
				"%13s = %-15s * 0: weighting pathways between codons (0/1)?\n",
				"weighting",
				$controlParameterSet->getWeighting
				);
		}
	
	if (defined $controlParameterSet->getCommonf3x4) {
		$text .=
			sprintf(
				"%13s = %-15s * use one set of codon freqs for all pairs (0/1)?\n",
				"commonf3x4",
				$controlParameterSet->getCommonf3x4
				);
		}
	
	
		
	
	if (defined $controlParameterSet->getIcode) {
		$text .=
			"\n" . 
			"* Genetic codes: 0:universal, 1:mammalian mt., 2:yeast mt., 3:mold mt.,\n" .
			"* 4: invertebrate mt., 5: ciliate nuclear, 6: echinoderm mt.,\n" .
			"* 7: euplotid mt., 8: alternative yeast nu. 9: ascidian mt.,\n" .
			"* 10: blepharisma nu.\n" .
			"* These codes correspond to transl_table 1 to 11 of GENEBANK.\n";
		}

	
	
	
	
	
	print $FILEHANDLE $text or $self->throw("Could not write to outfile.");
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

