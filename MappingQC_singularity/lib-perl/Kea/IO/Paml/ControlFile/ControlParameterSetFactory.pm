#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 23/07/2008 13:47:58
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
package Kea::IO::Paml::ControlFile::ControlParameterSetFactory;
use Kea::Object;
our @ISA = qw(Kea::Object);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::IO::Paml::ControlFile::_ControlParameterSet;

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

sub createYn00ControlParameterSet {
	
	my $self = shift;
	my %args = @_;
	
	return
		Kea::IO::Paml::ControlFile::_ControlParameterSet->new(
			
			-seqfile			=> $self->check($args{-seqfile}),
			-outfile			=> $self->alternativeIfUndefined(	$args{-outfile},		"yn"	),
			-verbose			=> $self->alternativeIfUndefined(	$args{-verbose},		0		),
			-noisy				=> $self->alternativeIfUndefined(	$args{-noisy},			3		),
			-icode				=> $self->alternativeIfUndefined(	$args{-icode}, 			0		),
			-weighting			=> $self->alternativeIfUndefined(	$args{-weighting},		0		),
			-commonf3x4			=> $self->alternativeIfUndefined(	$args{-commonf3x4},		0		)
			);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createCodemlControlParameterSet {
	
	my $self = shift;
	my %args = @_;
	
	return
		Kea::IO::Paml::ControlFile::_ControlParameterSet->new(
			
			-seqfile			=> $self->check($args{-seqfile}), 
			-treefile			=> $args{-treefile},
			
			# Defaults according to manual, p.23-24
			-outfile			=> $self->alternativeIfUndefined(	$args{-outfile},		"mlc"	),
			-noisy				=> $self->alternativeIfUndefined(	$args{-noisy}, 			9		), 
			-verbose			=> $self->alternativeIfUndefined(	$args{-verbose},		0		),
			-runmode			=> $self->alternativeIfUndefined(	$args{-runmode},		0		),
			-seqtype			=> $self->alternativeIfUndefined(	$args{-seqtype},		2		),
			-CodonFreq			=> $self->alternativeIfUndefined(	$args{-CodonFreq}, 		2		),
			-aaDist				=> $self->alternativeIfUndefined(	$args{-aaDist}, 		0		),			
			-model				=> $self->alternativeIfUndefined(	$args{-model}, 			2		),		
			-NSsites			=> $self->alternativeIfUndefined(	$args{-NSsites},		0		),			
			-icode				=> $self->alternativeIfUndefined(	$args{-icode}, 			0		),
			-Mgene				=> $self->alternativeIfUndefined(	$args{-Mgene}, 			0		),  
			-fix_kappa			=> $self->alternativeIfUndefined(	$args{-fix_kappa}, 		0		), 
			-kappa				=> $self->alternativeIfUndefined(	$args{-kappa}, 			2		),
			-fix_omega			=> $self->alternativeIfUndefined(	$args{-fix_omega}, 		0		),
			-omega				=> $self->alternativeIfUndefined(	$args{-omega}, 			".4"	), 
			-ncatG				=> $self->alternativeIfUndefined(	$args{-ncatG}, 			3		), 
			-clock				=> $self->alternativeIfUndefined(	$args{-clock}, 			0		), 
			-getSE				=> $self->alternativeIfUndefined(	$args{-getSE}, 			0		),
			-RateAncestor		=> $self->alternativeIfUndefined(	$args{-RateAncestor},	0		),
			-Small_Diff			=> $self->alternativeIfUndefined(	$args{-Small_Diff},		".5e-6"	),
			-cleandata			=> $self->alternativeIfUndefined(	$args{-cleandata}, 		0		),
			-fix_blength		=> $self->alternativeIfUndefined(	$args{-fix_blength}, 	0		)
			);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;
	