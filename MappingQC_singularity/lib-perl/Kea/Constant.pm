#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 10/02/2008 09:23:26 
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
package Kea::Constant;

# Boolean
use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use constant GAP 	=> "-";

# Sequence types.
use constant DNA 		=> "dna";
use constant RNA 		=> "rna";
use constant PROTEIN 	=> "protein";

# Sequence orientation
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";

# File types
use constant FASTA 		=> "fasta";
use constant EMBL 		=> "embl";

use constant UNKNOWN 	=> "unknown";

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

