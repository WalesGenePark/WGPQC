#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Std;
use File::Basename;

my %options;
getopts("b:r:c:s:e:m:", \%options);
my $bamPath 	= $options{b} or &usage;
my $chr		= $options{c} || "null";
my $startPos	= $options{s} || "null";
my $endPos	= $options{e} || "null";
my $ref		= $options{r} || "hg19";
my $mem		= $options{m} || "1000m";
sub usage {die "UASGE: " . basename($0) . 
	" [-b url path to bam file] " . 
	"[-r reference (hg18, hg19; default hg19)] " . 
	"[-c chr (optional)] " . 
	"[-s start position (optional)] " . 
	"[-e end position (optional)] " . 	
	"[-m max memory, default 1000m].\n"
	}  	

# chr9:135,764,735-135,822,020

#==============================================================================
my $TEMPLATE = <<"TEMPLATE";
<?xml version="1.0" encoding="utf-8"?>

<jnlp
  spec="6.0+"
  codebase="http://www.broadinstitute.org/igv/projects/current">
  <information>
    <title>IGV 2.0</title>
    <vendor>The Broad Institute</vendor>
    <homepage href="http://www.broadinstitute.org/igv"/>
    <description>IGV Software</description>
    <description kind="short">IGV</description>
    <icon href="IGV_64.png"/>
    <icon kind="splash" href="IGV_64.png"/>
    <offline-allowed/>
        <shortcut/>
  </information>
  <security>
      <all-permissions/>
  </security>
  <update check="always" policy="always"/>
  <resources>
<java version="1.6+" initial-heap-size="256m" max-heap-size="__MEM__"/>    <jar href="igv.jar" download="eager" main="true"/>
    <jar href="batik-codec.jar" download="eager"/>
    <property name="apple.laf.useScreenMenuBar" value="true"/>
    <property name="com.apple.mrj.application.growbox.intrudes" value="false"/>
    <property name="com.apple.mrj.application.live-resize" value="true"/>
    <property name="com.apple.macos.smallTabs" value="true"/>
  </resources>
  <application-desc main-class="org.broad.igv.ui.Main">
     <argument>__BAM_PATH__</argument>
     __LOCATION__
    <argument>-g</argument>
    <argument>__REF__</argument>
  </application-desc>
</jnlp>
TEMPLATE
#==============================================================================

$TEMPLATE =~ s/__BAM_PATH__/$bamPath/;
$TEMPLATE =~ s/__REF__/$ref/;
$TEMPLATE =~ s/__MEM__/$mem/;

if ($chr ne "null") { 
	$TEMPLATE =~ s/__LOCATION__/"<argument>"$chr:$startPos-$endPos"<\/argument>"/;
	}	


print $TEMPLATE , "\n";

