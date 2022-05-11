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

# INTERFACE NAME
package Kea::Phylogeny::Paml::IBranchResult;
use Kea::Phylogeny::Paml::IResult;
our @ISA = qw(Kea::Phylogeny::Paml::IResult);

use strict;
use warnings;
use Kea::Object;

our $_message = "Undefined method";

################################################################################

sub getBranchString		{Kea::Object->throw($_message);}

sub getSxdS 			{Kea::Object->throw($_message);}

sub getNxdN 			{Kea::Object->throw($_message);}

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

=pod
 branch           t        S        N    dN/dS       dN       dS   S*dS   N*dN

   8..9       0.068    107.8    282.2   0.8066   0.0213   0.0263    2.8    6.0
   9..1       0.026    107.8    282.2   0.8066   0.0080   0.0099    1.1    2.3
   9..2       0.039    107.8    282.2   0.8066   0.0122   0.0151    1.6    3.4
   8..10      0.043    107.8    282.2   0.8066   0.0136   0.0168    1.8    3.8
  10..11      0.076    107.8    282.2   0.8066   0.0239   0.0296    3.2    6.7
  11..3       0.044    107.8    282.2   0.8066   0.0137   0.0170    1.8    3.9
  11..4       0.053    107.8    282.2   0.8066   0.0164   0.0204    2.2    4.6
  10..5       0.022    107.8    282.2   0.8066   0.0068   0.0084    0.9    1.9
   8..12      0.123    107.8    282.2   0.8066   0.0383   0.0475    5.1   10.8
  12..6       0.041    107.8    282.2   0.8066   0.0128   0.0158    1.7    3.6
  12..7       0.024    107.8    282.2   0.8066   0.0075   0.0093    1.0    2.1
=cut