#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 29/02/2008 10:52:07 
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
package Kea::Phylogeny::_Node;
use Kea::Object;
use Kea::Phylogeny::INode;
our @ISA = qw(Kea::Object Kea::Phylogeny::INode);

## Purpose		: 

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className	= shift;
	my $id 			= Kea::Object->check(shift);
	
	my $self = {
		_id => $id,
		_branches => []
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

sub getId {
	return shift->{_id};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getBranches {
	return shift->{_branches};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub addBranch {
	
	my $self = shift;
	my $branch = $self->check(shift, "Kea::Phylogeny::IBranch");
	
	my $branches = $self->getBranches;
	
	push(@$branches, $branch);
	
	if (@$branches > 3) {
		$self->throw("Node " . $self->getId . " has " . @$branches . " branches!");
		}
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub isLeaf {
	
	my $self = shift;
	my $branches = $self->{_branches};
	
	if (@$branches == 1) {
		return TRUE;
		}
	else {
		return FALSE;
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getChildren {
	
	my $self = shift;
	my $branches = $self->getBranches;
	
	my @children;
	# Work through each branch associated with node (one or three).
	foreach my $branch (@$branches) {
		# Get other node associated with each branch.
		my $nodes = $branch->getNodes;
		if ($self->equals($nodes->[0])) {
			push(@children, $nodes->[1]);
			}
		else {
			push(@children, $nodes->[0]);
			}
		}
	
	return \@children;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub equals {
	
	my $self = shift;
	my $node = $self->check(shift, "Kea::Phylogeny::INode");
	
	if ($self->getId eq $node->getId) {
		return TRUE;
		}
	else {
		return FALSE;
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self = shift;
	
	my $id = $self->getId;
	
	return $id;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

