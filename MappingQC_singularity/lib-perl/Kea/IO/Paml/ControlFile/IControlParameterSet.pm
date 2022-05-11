#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 23/07/2008 13:37:31
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

# INTERFACE NAME
package Kea::IO::Paml::ControlFile::IControlParameterSet;

use strict;
use warnings;
use Kea::Object;

our $_message = "Undefined method.";

################################################################################	

#############################################
## NOTES TAKEN FROM PAML MANUAL VERSION 4. ##
#############################################

# "seqfile, outfile, and treefile specifies the names of the sequence data file,
# main result file, and the tree structure file, respectively.   You should not
# have spaces inside a file name.  In general try to avoid special characters in
# a file name as they might have special meanings under the OS." 

sub getSeqfile	{Kea::Object->throw($_message);}

sub getTreefile	{Kea::Object->throw($_message);}

sub getOutfile	{Kea::Object->throw($_message);}

# "noisy controls how much output you want on the screen.  If the model being
# fitted involves much computation, you can choose a large number for noisy to
# avoid loneliness. verbose controls how much output in the result file."  

sub getNoisy	{Kea::Object->throw($_message);}

sub getVerbose	{Kea::Object->throw($_message);}

# "runmode = -2 performs ML estimation of dS and dN in pairwise comparisons of
# protein-coding sequences (seqtype = 1).  The program will collect estimates of
# dS and dN into the files 2ML.dS and 2ML.dN.  Since many users seem interested
# in looking at dN/dS ratios among lineages, examination of the tree shapes
# indicated by branch lengths calculated from the two rates may be interesting
# although the analysis is ad hoc.  If your species names have no more than 10
# characters, you can use the output distance matrices as input to Phylip
# programs such as neighbor without any change.  Otherwise you need to edit the
# files to cut the names short.  For amino acid sequences (seqtype = 2), option 
# runmode = -2 lets the program calculate ML distances under the substitution
# model by numerical iteration, either under the model of one rate for all sites
# (alpha = 0) or under the gamma model of rates for sites (alpha != 0).  In the
# latter case, the continuous gamma is used and the variable ncatG is ignored.
# (With runmode = 0, the discrete gamma is used.)" 

sub getRunmode {Kea::Object->throw($_message);}

# 1:codons; 2:AAs; 3:codons-->AAs

sub getSeqtype {Kea::Object->throw($_message);}

# "CodonFreq specifies the equilibrium codon frequencies in codon substitution
# model. These frequencies can be assumed to be equal (1/61 each for the standard
# genetic code, CodonFreq = 0), calculated from the average nucleotide frequencies
# (CodonFreq = 1), from the average nucleotide frequencies at the three codon
# positions (CodonFreq = 2), or used as free parameters (CodonFreq = 3).  The
# number of parameters involved in those models of codon frequencies is 0, 3, 9,
# and 60 (for the universal code), for CodonFreq = 0, 1, 2, and 3 respectively." 

sub getCodonFreq {Kea::Object->throw($_message);}

# "aaDist specifies whether equal amino acid distances are assumed (= 0) or
# Grantham's matrix is used (= 1) (Yang et al. 1998).   The example mitochondrial
# data set analyzed in that paper is included in the example/mtdna folder in the
# package.  aaDist = 7 (AAClasses), which is implemented for both codon and amino
# acid sequences, allow you to have several types of amino acid substitutions and
# let the program estimate their different rates.  The model was implemented in
# Yang et al. (1998).  The number of substitution types and which pair of amino
# acid changes belong which type is specified in a file called OmegaAA.dat.
# You can use the model to fit different omega ratios for ÒconservedÓ and
# ÒchargedÓ amino acid substitutions.  The folder examples/mtCDNA contain
# example files for this model; check the readme file in that folder."

sub getAminoAcidDistance {Kea::Object->throw($_message);}

# Among branches model.

# "model concerns assumptions about the omega ratios among branches (Yang 1998;
# Yang and Nielsen 1998).  model = 0 means one omega ratio for all lineages
# (branches), 1 means one ratio for each branch (the free-ratio model), and 2
# means an arbitrary number of ratios (such as the 2-ratios or 3-ratios models).
# When model = 2, you have to group branches on the tree into branch groups
# using the symbols # or $ in the tree.  See the section above about specifying
# branch/node labels. With model = 2, the variable fix_omega fixes the last
#Êratio (omega k - 1 if you have k ratios in total) at the value of omega
# specified in the file. This option can be used to test, for example, whether
# the ratio for a specific lineage is significantly different from one. See the
#Êreadme file in the examples/lysozyme/ folder and try to duplicate the results
# of Yang (1998)."

sub getModel {Kea::Object->throw($_message);}

# Among sites model.

# "NSsites specifies models that allow the dN/dS ratio (omega) to vary among
# sites (Nielsen and Yang 1998; Yang et al. 2000b).  NSsites = m corresponds to
# model Mm in Yang et al. (2000b).  The variable ncatG is used to specify the
#Ênumber of categories in the omega distribution under some models.  The values
# of ncatG used to perform analyses in that paper are 3 for M3 (discrete), 5
# for M4 (freq), 10 for the continuous distributions (M5: gamma, M6: 2gamma,
# M7: beta, M8:beta&w, M9:beta&gamma, M10: beta&gamma+1, M11:beta&normal>1, and
# M12:0&2normal>1, M13:3normal>0). This means M8 will have 11 site classes (10
# from the beta distribution plus 1 additional class).  The posterior
#Êprobabilities for site classes as well as the expected omega values for sites
# are listed in the file rst, which may be useful to pinpoint sites under
# positive selection, if they exist.   

sub getNSsites {Kea::Object->throw($_message);}

# "icode specifies the genetic code.  Eleven genetic code tables are implemented
# using icode = 0 to 10 corresponding to transl_table 1 to 11 in GenBank.  These
# are 0 for the universal code; 1 for the mammalian mitochondrial code; 3 for
# mold mt., 4 for invertebrate mt.; 5 for ciliate nuclear code; 6 for echinoderm
# mt.; 7 for euplotid mt.; 8 for alternative yeast nuclear; 9 for ascidian mt.;
# and 10 for blepharisma nuclear.  There is also an additional code, called
# YangÕs regularized code, specified by icode = 11.  In this code, there are 16
# amino acids, all differences at the first and second codon positions are 
# nonsynonymous and all differences at the third codon positions are synonymous;
# that is, all codons are 4-fold degenerate.  There is yet no report of any
# organisms using this code." 

# Equivalent to genbank transl_table code + 1.
sub getIcode {Kea::Object->throw($_message);}		

# "Mgene is used in combination with option G in the sequence data file, for
# combined analysis of data from multiple genes or multiple site partitions
# (such as the three codon positions). More details are given later in the Models
# and Methods section.  Choose 0 if option G is not used in the data file."  

sub getMGene {Kea::Object->throw($_message);}

# "fix_kappa specifies whether kappa in K80, F84, or HKY85 is given at a fixed value
# or is to be estimated by iteration from the data. If fix_kappa = 1, the value
# of another variable, kappa, is the given value, and otherwise the value of
# kappa is used as the initial estimate for iteration. The variables fix_kappa
# and kappa have no effect with JC69 or F81 which does not involve such a
# parameter, or with TN93 and REV which have two and five rate parameters
# respectively, when all of them are estimated from the data."

sub getFixKappa	{Kea::Object->throw($_message);}

sub getKappa	{Kea::Object->throw($_message);}

sub getFixOmega {Kea::Object->throw($_message);}

sub getOmega	{Kea::Object->throw($_message);}

#sub getFixAlpha	{Kea::Object->throw($_message);}

#sub getAlpha	{Kea::Object->throw($_message);}

#sub getMalpha	{Kea::Object->throw($_message);}

sub getncatG	{Kea::Object->throw($_message);}

# "clock specifies models concerning rate constancy or variation among lineages.
# clock = 0 means no clock and rates are entirely free to vary from branch to
#Êbranch.  An unrooted tree should be used under this model.  For clock = 1, 2,
# or 3, a rooted tree should be used.  clock = 1 means the global clock, with
# all branches having the same rate.  If fossil calibration information is
# specified in the tree file using the symbol @, the absolute rate will be
# calculated.  Multiple calibration points can be specified this way. If
# sequences have dates, this option will fit Andrew RambautÕs TipDate model.
# clock = 2 implements local clock models of Yoder and Yang (2000) and Yang and
#ÊYoder (2003), which assume that branches on the tree can be partitioned into
# several rate groups.  The default is group 0, while all other groups have to
# be labeled using branch/node labels (symbols # and $) in the tree.  The
# program will then estimate those rates for branch groups.  clock = 3 is for
#Êcombined analysis of multiple-gene or multiple-partition data, allowing the
#Êbranch rates to vary in different ways among the data partitions (Yang and
#ÊYoder 2003).  To account for differences in the evolutionary process among
#Êdata partitions, you have to use the option G in the sequence file as well as
# the control variable Mgene in the control file (baseml.ctl or codeml.ctl).
#ÊRead the section above on ÒTree file formatÓ about how to specify fossil
#Êcalibration information in the tree, how to label branch groups.  Read
# Yang and Yoder (2003) and the readme file in the examples/MouseLemurs/
#Êfolder to duplicate the analysis of that paper.  Also the variable (= 5 or
# 6) is used to implement the ad hoc rate smoothing procedure of Yang (2004).
# See the file readme2.txt for instructions and the paper for details of the
#Êmodel." 

sub getClock {Kea::Object->throw($_message);}

# "getSE tells whether we want estimates of the standard errors of estimated
# parameters. These are crude estimates, calculated by the curvature method,
# i.e., by inverting the matrix of second derivatives of the log-likelihood with
# respect to parameters. The second derivatives are calculated by the difference
# method, and are not always reliable. Even if this approximation is reliable,
# tests relying on the SE's should be taken with caution, as such tests rely on
# the normal approximation to the maximum likelihood estimates. The likelihood
# ratio test should always be preferred. The option is not available and choose 
# getSE = 0 when tree-search is performed."  

sub getGetSE {Kea::Object->throw($_message);}

# "RateAncestor:  Choose 1 if you want to reconstruct ancestral sequences and 0
# to avoid the calculation.  The output under codon-based models usually shows
# the encoded amino acid for each codon. The output under "Prob of best character
#Êat each node, listed by site" has two posterior probabilities for each node at
# each codon (amino acid) site. The first is for the best codon. The second, in
# parentheses, is for the most likely amino acid under the codon substitution
# model. This is a sum of posterior probabilities across synonymous codons.  In
# theory it is possible although rare for the most likely amino acid not to
# match the most likely codon. Under gamma models of rates for sites, choosing
# 1 for this variable will also force the program to estimate the substitution
#rate at each site."  

sub getRateAncestor {Kea::Object->throw($_message);}

# "Small_Diff is a small value used in the difference approximation of
# derivatives." 

sub getSmallDiff {Kea::Object->throw($_message);}

# "cleandata  = 1 means sites involving ambiguity characters (undetermined
# nucleotides such as N, ?, W, R, Y, etc. anything other than the four
# nucleotides) or alignment gaps are removed from all sequences.  This leads to
#Êfaster calculation.  cleaddata = 0 (default) uses those sites." 

sub getCleandata {Kea::Object->throw($_message);}

# "fix_blength:  This tells the program what to do if the tree has branch
# lengths.  Use 0 if you want to ignore the branch lengths. Use Ð1 if you want
# the program to start from random starting points.  This might be useful if
# there are multiple local optima.  Use 1 if you want to use the branch lengths
# as initial values for the ML iteration.  Try to avoid using the Òbranch
# lengthsÓ from a parsimony analysis from PAUP, as those are numbers of changes
# for the entire sequence (rather than per site) and are very poor initial
# values. Use 2 if you want the branch lengths to be fixed at those given in the
# tree file (rather than estimating them by ML).  In this case, you should make
# sure that the branch lengths are sensible; for example, if two sequences in
# the data file are different, but the branch lengths connecting the two
# sequences in the tree are all zero, the data and tree will be in conflict and
# the program will crash. 

sub getFix_blength 	{Kea::Object->throw($_message);}

# "The variable weighting decides whether equal weighting or unequal weighting
# will be used when counting differences between codons. The two approaches will
# be different for divergent sequences, and unequal weighting is much slower
# computationally."

sub getWeighting 	{Kea::Object->throw($_message);}

# "commonf3x4 specifies whether codon frequencies (based on the F3x4 model of 
# codonml) should be estimated for each pair or for all sequences in the data."

sub getCommonf3x4	{Kea::Object->throw($_message);}


################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

