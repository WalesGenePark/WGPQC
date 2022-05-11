#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 10/03/2009 10:51:35
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
package Kea::IO::ASN1::SubmitBlock::_ToHandlerReader;
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

	my $self 		= shift;
	my $FILEHANDLE 	= $self->check(shift);
	my $handler		= $self->check(shift, "Kea::IO::ASN1::SubmitBlock::IReaderHandler");
	
	while (<$FILEHANDLE>) {
		
		if (/^Submit-block ::= {/) {
			$handler->_submitBlockStart();
			}
	
		elsif (/^\s*{\s*$/) {
			$handler->_nextStart();
			}
	
		elsif (/^\s*(\S+)\s+{/) {
			$handler->_nextStartWithText($1);
			}
		
		elsif (/^\s*(\S+)\s+"(.+)"\s*}/) {
			$handler->_nextItemPlusText($1, $2);
			while (/}/g) {
				$handler->_nextEnd();
				}
			}
		
		elsif (/^\s*(\S+)\s*$/) {
			$handler->_nextItem($1);
			}
		
		elsif (/\s*(\S+)\s+"(.+)"\s*,\s*$/) {
			$handler->_nextItemPlusText($1, $2);
			}
		
	
		}
	
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;
=pod
Submit-block ::= {
  contact {
    contact {
      name
        name {
          last "Ashelford" ,
          first "Kevin" ,
          initials "K.E." } ,
      affil
        std {
          affil "The University of Liverpool" ,
          div "School of Biosciences" ,
          city "Liverpool" ,
          country "UK" ,
          street "Biosciences Building, Crown Street" ,
          email "k.ashelford@liverpool.ac.uk" ,
          fax "+44 (0)151 795 4551" ,
          phone "+44 (0)151 795 4551" ,
          postal-code "L69 7ZB" } } } ,
  cit {
    authors {
      names
        std {
          {
            name
              name {
                last "Hepworth" ,
                first "Philip" ,
                initials "P.J." } } ,
          {
            name
              name {
                last "Ashelford" ,
                first "Kevin" ,
                initials "K.E." } } ,
          {
            name
              name {
                last "Hinds" ,
                first "Jason" ,
                initials "J." } } } ,
      affil
        std {
          affil "The University of Liverpool" ,
          div "School of Biosciences" ,
          city "Liverpool" ,
          country "UK" ,
          street "Biosciences Building, Crown Street" ,
          postal-code "L69 7ZB" } } ,
    date
      std {
        year 2009 ,
        month 3 ,
        day 9 } } ,
  subtype new }




Seqdesc ::= pub {
  pub {
    gen {
      cit "unpublished" ,
      authors {
        names
          std {
            {
              name
                name {
                  last "Hepworth" ,
                  first "Philip" ,
                  initials "P.J." } } ,
            {
              name
                name {
                  last "Ashelford" ,
                  first "Kevin" ,
                  initials "K.E." } } ,
            {
              name
                name {
                  last "Hinds" ,
                  first "Jason" ,
                  initials "J." } } } ,
        affil
          std {
            affil "The University of Liverpool" ,
            div "School of Biosciences" ,
            city "Liverpool" ,
            country "UK" ,
            street "Biosciences Building, Crown Street" ,
            postal-code "L69 7ZB" } } ,
      title "Divergence of water and wildlife-associated Campylobacter jejuni
 niche specialists from food-chain-associated clonal complexes" } } }
=cut