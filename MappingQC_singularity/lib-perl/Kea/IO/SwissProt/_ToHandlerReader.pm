#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 14/05/2008 16:50:31
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
package Kea::IO::SwissProt::_ToHandlerReader;
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

my $getSequence = sub {
	
	my $self = shift;
	my $FILEHANDLE = shift;
	
	my @buffer;
	while (<$FILEHANDLE>) {
	
		if (/^\/\/$/) {
			my $sequence = uc(join("", @buffer));
			$sequence =~ s/\s//g;
			return $sequence;
			
			}
		
		else {
			push(@buffer, $_);
			}
		
		}

	# Error if reach this point since should have matched //.
	$self->throw("End of file reached without termintor sequence detected.");
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub read {

	my $self = shift;
	my $FILEHANDLE = $self->check(shift);
	my $handler = $self->check(shift, "Kea::IO::SwissProt::IReaderHandler");
	
	while (<$FILEHANDLE>) {
		
		# ID   ENTRY_NAME   DATA_CLASS; MOLECULE_TYPE; SEQUENCE_LENGTH.
		# ID   CRAM_CRAAB     STANDARD;      PRT;    46 AA.
		if (/^ID\s{3}(\S+)\s+(\S+);\s+(\S+);\s+(\d+)\s+AA\.$/) {
			$handler->_nextIDLine(
				$1, # Entry name.
				$2,	# Data class
				$3,	# molecule type
				$4	# Sequence length
				);
			}
		
		# ID   12AH_CLOS4              Reviewed;          29 AA.
		if (/^ID\s{3}(\S+)\s+(\S+);\s+(\d+)\s+AA\.$/) {
			$handler->_nextIDLine(
				$1, # Entry name.
				$2,	# Data class
				undef,	# molecule type
				$3	# Sequence length
				);
			}
		
		# AC   AC_number_1;[ AC_number_2;]...[ AC_number_N;]
		# AC   P21215;
		elsif (/^AC\s{3}(.+)$/) {
			
			my @accessions = split(/;\s*/, $1);
			$handler->_nextAccessionLine(
				\@accessions
				);
			
			}
		
		# PREVIOUS VERSION
		# DE   14 kDa antigen (16 kDa antigen) (HSP 16.3).
		# DE   14 kDa peptide of ubiquinol-cytochrome c2 oxidoreductase complex.
		
		# DE   1-aminocyclopropane-1-carboxylate deaminase (EC 3.5.99.7) (ACC
		# DE   deaminase) (ACCD).
		#elsif (/^DE   (.+)$/) {
		#	$handler->_nextDescriptionLine($1);
		#	}
		
		# Now:
		# DE   RecName: Full=Transcription elongation factor greA;
		elsif (/^DE\s+RecName:\s+Full=(.+);$/) {
			$handler->_nextDescriptionLine($1);
			}
		elsif (/^DE\s+RecName:\s+Full=(.+)$/) {
			$self->throw("Multiline description!");
			}
		
		#SQ   SEQUENCE   46 AA;  4736 MW;  919E68AF159EF722 CRC64;
		#	TTCCPSIVAR SNFNVCRLPG TPEALCATYT GCIIIPGATC PGDYAN
		#//
		
		#SQ   SEQUENCE   24 AA;  2766 MW;  0D19F1F488DB3201 CRC64;
		#	 MFHVLTLTYL CPLDVVXQTR PAHV
		#//
		
	#	SQ   SEQUENCE   611 AA;  65927 MW;  625F1B284107B1FC CRC64;
	#		MAENNNLKLA STMEGRVEQL AEQRQVIEAG GGERRVEKQH SQGKQTARER LNNLLDPHSF
	#		DEVGAFRKHR TTLFGMDKAV VPADGVVTGR GTILGRPVHA ASQDFTVMGG SAGETQSTKV
	#		VETMEQALLT GTPFLFFYDS GGARIQEGID SLSGYGKMFF ANVKLSGVVP QIAIIAGPCA
	#		GGASYSPALT DFIIMTKKAH MFITGPQVIK SVTGEDVTAD ELGGAEAHMA ISGNIHFVAE
	#		DDDAAELIAK KLLSFLPQNN TEEASFVNPN NDVSPNTELR DIVPIDGKKG YDVRDVIAKI
	#		VDWGDYLEVK AGYATNLVTA FARVNGRSVG IVANQPSVMS GCLDINASDK AAEFVNFCDS
	#		FNIPLVQLVD VPGFLPGVQQ EYGGIIRHGA KMLYAYSEAT VPKITVVLRK AYGGSYLAMC
	#		NRDLGADAVY AWPSAEIAVM GAEGAANVIF RKEIKAADDP DAMRAEKIEE YQNAFNTPYV
	#		AAARGQVDDV IDPADTRRKI ASALEMYATK RQTRPAKKPW KLPLLSEEEI MADEEEKDLM
	#		IATLNKRVAS LESELGSLQS DTQGVTEDVL TAISAVAAYL GNDGSAEVVH FAPSPNWVRE
	#		GRRALQNHSI R
	#   //
		elsif (/^SQ\s{3}SEQUENCE\s+(\d+)\sAA;\s+(\d+)\sMW;\s+(\S+)\s+CRC64;$/) {
			my $seqLength = $1;
			my $molecularWeight = $2;
			my $seq64bitCRC = $3;
			my $sequence = $self->$getSequence($FILEHANDLE);
			$handler->_nextSequenceLine(
				$seqLength,
				$molecularWeight,
				$seq64bitCRC,
				$sequence
				);
			}
		
		
		} #ÊEnd of while - end of file.
	
	
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

