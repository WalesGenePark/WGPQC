#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 21/04/2008 14:27:10
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
package Kea::IO::Gff::IReaderHandler;

use strict;
use warnings;
use Kea::Object;

our $_message = "Undefined method.";

################################################################################

# METADATA
sub _version			{Kea::Object->throw($_message);}

sub _featureOntology	{Kea::Object->throw($_message);}

sub _attributeOntology	{Kea::Object->throw($_message);}

sub _nextSequenceRegion	{Kea::Object->throw($_message);}


# FEATURE DATA
sub _nextLine			{Kea::Object->throw($_message);}


# FASTA
sub _nextHeader			{Kea::Object->throw($_message);}

sub _nextSequence		{Kea::Object->throw($_message);}

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

=pod
DESCRIPTION OF THE FORMAT

The format consists of 9 columns, separated by tabs (NOT spaces).  The
following characters must be escaped using URL escaping conventions
(%XX hex codes):

    tab
    newline
    carriage return
    control characters

The following characters have reserved meanings and must be escaped
when used in other contexts:
    
    ;  (semicolon)
    =  (equals)
    %  (percent)
    &  (ampersand)
    ,  (comma)

Unescaped quotation marks, backslashes and other ad-hoc escaping
conventions that have been added to the GFF format are explicitly
forbidden
    
Note that unescaped spaces are allowed within fields, meaning that
parsers must split on tabs, not spaces.

Undefined fields are replaced with the "." character, as described in
the original GFF spec.

Column 1: "seqid"

The ID of the landmark used to establish the coordinate system for the
current feature. IDs may contain any characters, but must escape any
characters not in the set [a-zA-Z0-9.:^*$@!+_?-|].  In particular, IDs
may not contain unescaped whitespace and must not begin with an
unescaped ">".

Column 2: "source"

The source is a free text qualifier intended to describe the algorithm
or operating procedure that generated this feature.  Typically this is
the name of a piece of software, such as "Genescan" or a database
name, such as "Genbank."  In effect, the source is used to extend the
feature ontology by adding a qualifier to the type creating a new
composite type that is a subclass of the type in the type column.

Column 3: "type"

The type of the feature (previously called the "method").  This is
constrained to be either: (a) a term from the "lite" sequence
ontology, SOFA; or (b) a SOFA accession number.  The latter
alternative is distinguished using the syntax SO:000000.

Columns 4 & 5: "start" and "end"

The start and end of the feature, in 1-based integer coordinates,
relative to the landmark given in column 1.  Start is always less than
or equal to end.

For zero-length features, such as insertion sites, start equals end
and the implied site is to the right of the indicated base in the
direction of the landmark.

Column 6: "score"

The score of the feature, a floating point number.  As in earlier
versions of the format, the semantics of the score are ill-defined.
It is strongly recommended that E-values be used for sequence
similarity features, and that P-values be used for ab initio gene
prediction features.

Column 7: "strand"

The strand of the feature.  + for positive strand (relative to the
landmark), - for minus strand, and . for features that are not
stranded.  In addition, ? can be used for features whose strandedness
is relevant, but unknown.

Column 8: "phase"

For features of type "CDS", the phase indicates where the feature
begins with reference to the reading frame.  The phase is one of the
integers 0, 1, or 2, indicating the number of bases that should be
removed from the beginning of this feature to reach the first base of
the next codon. In other words, a phase of "0" indicates that the next
codon begins at the first base of the region described by the current
line, a phase of "1" indicates that the next codon begins at the
second base of this region, and a phase of "2" indicates that the
codon begins at the third base of this region. This is NOT to be
confused with the frame, which is simply start modulo 3.

For forward strand features, phase is counted from the start
field. For reverse strand features, phase is counted from the end
field.

The phase is REQUIRED for all CDS features.

Column 9: "attributes"

A list of feature attributes in the format tag=value.  Multiple
tag=value pairs are separated by semicolons.  URL escaping rules are
used for tags or values containing the following characters: ",=;".
Spaces are allowed in this field, but tabs must be replaced with the
%09 URL escape.

These tags have predefined meanings:

    ID	   Indicates the name of the feature.  IDs must be unique
	   within the scope of the GFF file.

    Name   Display name for the feature.  This is the name to be
           displayed to the user.  Unlike IDs, there is no requirement
	   that the Name be unique within the file.

    Alias  A secondary name for the feature.  It is suggested that
	   this tag be used whenever a secondary identifier for the
	   feature is needed, such as locus names and
	   accession numbers.  Unlike ID, there is no requirement
	   that Alias be unique within the file.

    Parent Indicates the parent of the feature.  A parent ID can be
	   used to group exons into transcripts, transcripts into
	   genes, an so forth.  A feature may have multiple parents.
	   Parent can *only* be used to indicate a partof 
	   relationship.

    Target Indicates the target of a nucleotide-to-nucleotide or
	   protein-to-nucleotide alignment.  The format of the
	   value is "target_id start end [strand]", where strand
	   is optional and may be "+" or "-".  If the target_id 
	   contains spaces, they must be escaped as hex escape %20.

    Gap   The alignment of the feature to the target if the two are
          not collinear (e.g. contain gaps).  The alignment format is
	  taken from the CIGAR format described in the 
	  Exonerate documentation.
	  (http://cvsweb.sanger.ac.uk/cgi-bin/cvsweb.cgi/exonerate
          ?cvsroot=Ensembl).  See "THE GAP ATTRIBUTE" for a description
	  of this format.

    Derives_from  
          Used to disambiguate the relationship between one
          feature and another when the relationship is a temporal
          one rather than a purely structural "part of" one.  This
          is needed for polycistronic genes.  See "PATHOLOGICAL CASES"
	  for further discussion.

    Note   A free text note.

    Dbxref A database cross reference.  See the section
	   "Ontology Associations and Db Cross References" for
	   details on the format.

    Ontology_term  A cross reference to an ontology term.  See
           the section "Ontology Associations and Db Cross References"
	   for details.

Multiple attributes of the same type are indicated by separating the
values with the comma "," character, as in:

       Parent=AF2312,AB2812,abc-3

Note that attribute names are case sensitive.  "Parent" is not the
same as "parent".

All attributes that begin with an uppercase letter are reserved for
later use.  Attributes that begin with a lowercase letter can be used
freely by applications.



OTHER SYNTAX

Comments are preceded by the # symbol.  Meta-data and directives are
preceded by ##.  The following directives are recognized:

  ##gff-version 3
	The GFF version, always 3 in this spec.  This directive must
 	be present, and must be the topmost line of the file.

  ##sequence-region seqid start end
        The sequence segment referred to by this file, in the format
        "seqid start end".  This element is optional, but strongly
        encouraged because it allows parsers to perform bounds
        checking on features. There may be multiple ##sequence-region
        directives, each corresponding to one of the reference
        sequences referred to in the body of the file.

  ##feature-ontology URI
        This directive indicates that the GFF3 file uses the ontology 
        of feature types located at the indicated URI or URL.
        Multiple URIs may be added, in which case they are
        merged (or raise an exception if they cannot be merged).  The
        URIs for the released sequence ontologies are:

        Release 1: 5/12/2004
        http://song.cvs.sourceforge.net/*checkout*/song/ontology/sofa.obo?revision=1.6

        Release 2: 5/16/2005
        http://song.cvs.sourceforge.net/*checkout*/song/ontology/sofa.obo?revision=1.12

        This directive may occur several times per file.  If no
        feature ontology is specified, then the most recent release of the
        Sequence Ontology is assumed.
				
        If multiple directives are given and a feature type is matched
        by multiple ontologies, the matching ontology included by the
        directive highest in the file wins the reference.  The Sequence
        Ontology itself is always referenced last.

        The content referenced by URI must be in OBO or DAG-Edit
        format.


  ##attribute-ontology URI
        This directive indicates that the GFF3 uses the ontology of
        attribute names located at the indicated URI or URL.  This
        directive may appear multiple times to load multiple URIs, in
        which case they are merged (or raise an exception if merging
        is not possible).  Currently no formal attribute ontologies
        exist, so this attribute is for future extension.

  ##source-ontology URI
        This directive indicates that the GFF3 uses the ontology of
        source names located at the indicated URI or URL.  This
        directive may appear multiple times to load multiple URIs, in
        which case they are merged (or raise an exception if merging
        is not possible).  Currently no formal source ontologies
        exist, so this attribute is for future extension.

  ###
        This directive (three # signs in a row) indicates that all
        forward references to feature IDs that have been seen to this
        point have been resolved.  After seeing this directive, a
        program that is processing the file serially can close off any
        open objects that it has created and return them, thereby
        allowing iterative access to the file.  Otherwise, software
        cannot know that a feature has been fully populated by its
        subfeatures until the end of the file has been reached.  It
        is recommended that complex features, such as the canonical
        gene, be terminated with the ### notation.

   ##FASTA
        This notation indicates that the annotation portion of the
        file is at an end and that the remainder of the file
        contains one or more sequences (nucleotide or protein)
        in FASTA format.  This allows features and sequences to
        be bundled together.  Example:

   ##gff-version   3
   ##sequence-region   ctg123 1 1497228
   ctg123 . gene            1000  9000  .  +  .  ID=gene00001;Name=EDEN
   ctg123 . TF_binding_site 1000  1012  .  +  .  ID=tfbs00001;Parent=gene00001
   ctg123 . mRNA            1050  9000  .  +  .  ID=mRNA00001;Parent=gene00001;Name=EDEN.1
   ctg123 . 5'-UTR          1050  1200  .  +  .  Parent=mRNA00001
   ctg123 . CDS             1201  1500  .  +  0  Parent=mRNA00001
   ctg123 . CDS             3000  3902  .  +  0  Parent=mRNA00001
   ctg123 . CDS             5000  5500  .  +  0  Parent=mRNA00001
   ctg123 . CDS             7000  7600  .  +  0  Parent=mRNA00001
   ctg123 . 3'-UTR          7601  9000  .  +  .  Parent=mRNA00001
   ctg123 . cDNA_match 1050  1500  5.8e-42  +  . ID=match00001;Target=cdna0123+12+462
   ctg123 . cDNA_match 5000  5500  8.1e-43  +  . ID=match00001;Target=cdna0123+463+963
   ctg123 . cDNA_match 7000  9000  1.4e-40  +  . ID=match00001;Target=cdna0123+964+2964
   ##FASTA
   >ctg123
   cttctgggcgtacccgattctcggagaacttgccgcaccattccgccttg
   tgttcattgctgcctgcatgttcattgtctacctcggctacgtgtggcta
   tctttcctcggtgccctcgtgcacggagtcgagaaaccaaagaacaaaaa
   aagaaattaaaatatttattttgctgtggtttttgatgtgtgttttttat
   aatgatttttgatgtgaccaattgtacttttcctttaaatgaaatgtaat
   cttaaatgtatttccgacgaattcgaggcctgaaaagtgtgacgccattc
   gtatttgatttgggtttactatcgaataatgagaattttcaggcttaggc
   ttaggcttaggcttaggcttaggcttaggcttaggcttaggcttaggctt
   aggcttaggcttaggcttaggcttaggcttaggcttaggcttaggcttag
   aatctagctagctatccgaaattcgaggcctgaaaagtgtgacgccattc
   ...
   >cnda0123
   ttcaagtgctcagtcaatgtgattcacagtatgtcaccaaatattttggc
   agctttctcaagggatcaaaattatggatcattatggaatacctcggtgg
   aggctcagcgctcgatttaactaaaagtggaaagctggacgaaagtcata
   tcgctgtgattcttcgcgaaattttgaaaggtctcgagtatctgcatagt
   gaaagaaaaatccacagagatattaaaggagccaacgttttgttggaccg
   tcaaacagcggctgtaaaaatttgtgattatggttaaagg

       For backward-compatibility with the GFF version output by the
      Artemis tool, a GFF line that begins with the character >
       creates an implied ##FASTA directive.
=cut
