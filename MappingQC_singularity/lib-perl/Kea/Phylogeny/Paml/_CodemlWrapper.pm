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

# CLASS NAME
package Kea::Phylogeny::Paml::_CodemlWrapper;
use Kea::Object;
our @ISA = qw(Kea::Object);

use strict;
use warnings;
use Kea::Arg;

use constant TRUE => 1;
use constant FALSE => 0;

use constant SENSE => "sense";
use constant ANTISENSE => "antisense";

use constant FASTA => "fasta";
use constant EMBL => "embl";
use constant UNKNOWN => "unknown";

our $CODEML_CTL_FILE = "codeml.ctl";
our $_template;

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

sub createControlFile {
	
	my ($self, %args) = @_;
	
	my $filename		= $args{-filename} 		|| 	$CODEML_CTL_FILE;
	my $seqfile 		= $args{-seqfile} 		or 	$self->throw("No aligned sequence file provided.  Use -seqfile flag."); #  sequence data file name
	my $treefile 		= $args{-treefile} 		or 	$self->throw("No treefile provided.");
	my $outfile 		= $args{-outfile} 		or 	$self->throw("No outfile provided."); #|| "mlc";
	my $noisy 			= $args{-noisy} 		;#or 	confess "\nERROR: -noisy not set.\n\n"; # || 3;
	my $verbose 		= $args{-verbose} 		;#or 	confess "\nERROR: -verbose not set.\n\n"; #|| 0;
	my $runmode 		= $args{-runmode} 		;#or 	confess "\nERROR: -runmode not set.\n\n"; # || -2;
	my $seqtype 		= $args{-seqtype} 		;#or 	confess "\nERROR: -seqtype not set.\n\n"; # || 1;
	my $CodonFreq 		= $args{-CodonFreq} 	;#or 	confess "\nERROR: -CodonFreq not set.\n\n"; # || 2;								
	my $aaDist 			= $args{-aaDist} 		;#or 	confess "\nERROR: -aaDist not set.\n\n"; # || 0;										
	my $model 			= $args{-model} 		;#or 	confess "\nERROR: -model not set.\n\n"; # || 0;
	my $NSsites 		= $args{-NSsites} 		;#or 	confess "\nERROR: -NSsites not set.\n\n"; # || 0;
	my $icode 			= $args{-icode} 		;#or 	confess "\nERROR: -icode not set.\n\n"; # || 0;
	my $Mgene 			= $args{-Mgene} 		;#or 	confess "\nERROR: -Mgene not set.\n\n"; # || 0;
	my $fix_kappa 		= $args{-fix_kappa} 	;#or 	confess "\nERROR: -fox_kappa not set.\n\n"; # || 0;
	my $kappa 			= $args{-kappa} 		;#or 	confess "\nERROR: -kappa not set.\n\n"; # || 0.3;
	my $fix_omega 		= $args{-fix_omega} 	;#or 	confess "\nERROR: -fix_omega not set.\n\n"; # || 0;
	my $omega 			= $args{-omega} 		;#or 	confess "\nERROR: -omega not set.\n\n"; # || 1.3;
	my $ncatG 			= $args{-ncatG} 		;#or 	confess "\nERROR: -ncatG not set.\n\n"; # || 10;
	my $clock 			= $args{-clock} 		;#or 	confess "\nERROR: -clock not set.\n\n"; # || 0;
	my $getSE 			= $args{-getSE} 		;#or 	confess "\nERROR: -getSE not set.\n\n"; # || 0;
	my $RateAncestor 	= $args{-RateAncestor} 	;#or 	confess "\nERROR: -RateAncestor not set. \n\n"; # || 0;
	my $Small_Diff 		= $args{-Small_Diff} 	;#or 	confess "\nERROR: -SmallDiff not set. \n\n"; # || .45e-6;
	my $cleandata 		= $args{-cleandata} 	;#or 	confess "\nERROR: -cleandata not set.\n\n"; # || 1;
	my $fix_blength 	= $args{-fix_blength} 	;#or 	confess "\nERROR: -fix_blength not set.\n\n"; # || 0;
	
	my $template = $_template;
	
	
	# Create template.
	$template 	=~ 	s/__SEQFILE__/$seqfile/;
	$template 	=~ 	s/__TREEFILE__/$treefile/;
	$template 	=~ 	s/__OUTFILE__/$outfile/;
	$template 	=~ 	s/__NOISY__/$noisy/;
	$template 	=~ 	s/__VERBOSE__/$verbose/;
	$template 	=~ 	s/__RUNMODE__/$runmode/;
	$template 	=~ 	s/__SEQTYPE__/$seqtype/;
	$template 	=~ 	s/__CODONFREQ__/$CodonFreq/;
	$template 	=~ 	s/__AADIST__/$aaDist/;
	$template 	=~ 	s/__MODEL__/$model/;
	$template 	=~ 	s/__NSSITES__/$NSsites/;
	$template 	=~ 	s/__ICODE__/$icode/;
	$template 	=~ 	s/__MGENE__/$Mgene/;
	$template 	=~ 	s/__FIX_KAPPA__/$fix_kappa/;
	$template 	=~ 	s/__KAPPA__/$kappa/;
	$template 	=~ 	s/__FIX_OMEGA__/$fix_omega/;
	$template 	=~ 	s/__OMEGA__/$omega/;
	$template 	=~ 	s/__NCATG__/$ncatG/;
	$template 	=~ 	s/__CLOCK__/$clock/;
	$template 	=~ 	s/__GETSE__/$getSE/;
	$template 	=~ 	s/__RATEANCESTOR__/$RateAncestor/;
	$template 	=~ 	s/__SMALL_DIFF__/$Small_Diff/;
	$template 	=~ 	s/__CLEANDATA__/$cleandata/;
	$template 	=~ 	s/__FIX_BLENGTH__/$fix_blength/;
	
	open (CTL, ">$filename") or $self->throw("Could not generate codeml.ctl file '$filename'.");
	print CTL $template;
	close (CTL) or $self->throw("Could not close $filename.");
	
	
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub run {
	my ($self, %args) = @_;
	
	$self->createControlFile(%args);
	
	# Run codeml.
	my $command = "codeml";
	
	print
		"\n".
		"\t-------------------\n".
		"\t Running codeml...\n".
		"\t-------------------\n".
		"\n";
	system($command);
	print
		"\n".
		"\t---------------------\n".
		"\t ...codeml finished \n".
		"\t---------------------\n".
		"\n";
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////

$_template = <<'TEMPLATE';
      seqfile = __SEQFILE__			* sequence data file name
     treefile = __TREEFILE__		* tree structure file name
      outfile = __OUTFILE__			* main result file name
        noisy = __NOISY__      		* 0,1,2,3,9: how much rubbish on the screen
      verbose = __VERBOSE__    		* 1: detailed output, 0: concise output
      runmode = __RUNMODE__    		* 0: user tree;  1: semi-automatic;  2: automatic
									* 3: StepwiseAddition; (4,5):PerturbationNNI; -2: pairwise

      seqtype = __SEQTYPE__    		* 1:codons; 2:AAs; 3:codons-->AAs
    CodonFreq = __CODONFREQ__  		* 0:1/61 each, 1:F1X4, 2:F3X4, 3:codon table
       aaDist = __AADIST__     		* 0:equal, +:geometric; -:linear, {1-5:G1974,Miyata,c,p,v}
        model = __MODEL__
									* models for codons:
									* 0:one, 1:b, 2:2 or more dN/dS ratios for branches
									* models for AAs or codon-translated AAs:
									* 0:poisson, 1:proportional, 2:Empirical, 3:Empirical+F
									* 6:FromCodon, 7:AAClasses, 8:REVaa_0, 9:REVaa(nr=189)

      NSsites = __NSSITES__
									* 0:one w; 1:NearlyNeutral; 2:PositiveSelection; 3:discrete;
									* 4:freqs; 5:gamma;6:2gamma;7:beta;8:beta&w;9:beta&gamma;10:3normal
        icode = __ICODE__			* 0:standard genetic code; 1:mammalian mt; 2-10:see below
        Mgene = __MGENE__			* 0:rates, 1:separate; 2:pi, 3:kappa, 4:all

    fix_kappa = __FIX_KAPPA__	   	* 1: kappa fixed, 0: kappa to be estimated
        kappa = __KAPPA__		   	* initial or fixed kappa
    fix_omega = __FIX_OMEGA__		* 1: omega or omega_1 fixed, 0: estimate 
        omega = __OMEGA__			* initial or fixed omega, for codons or codon-based AAs
        ncatG = __NCATG__			* # of categories in the dG or AdG models of rates

        clock = __CLOCK__				* 0: no clock, unrooted tree, 1: clock, rooted tree
        getSE = __GETSE__				* 0: don't want them, 1: want S.E.s of estimates
 RateAncestor = __RATEANCESTOR__		* (0,1,2): rates (alpha>0) or ancestral states (1 or 2)

   Small_Diff = __SMALL_DIFF__
    cleandata = __CLEANDATA__			* remove sites with ambiguity data (1:yes, 0:no)?
  fix_blength = __FIX_BLENGTH__			* 0: ignore, -1: random, 1: initial, 2: fixed
TEMPLATE


1;

