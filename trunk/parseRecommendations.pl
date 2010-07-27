#!/usr/bin/perl -w

use strict;
use LWP::Simple;

my $symbol = "ERICB.ST";
# Get the recommendation
my $foutname = "tmp.html";
my $content = get("http://www.reuters.com/finance/stocks/analyst?symbol=$symbol");
open my $fh, ">$foutname" or die "Couldn't open file $foutname: $!\n";
print $fh $content;
close $fh;

# Format the content as text
require HTML::TreeBuilder;
my $tree = HTML::TreeBuilder->new->parse_file("$foutname");
require HTML::FormatText;
my $formatter = HTML::FormatText->new(leftmargin => 0, rightmargin => 50);
$content = $formatter->format($tree);

# Cut away unnecessary text
$content =~ s/^.+Analyst\sRecommendations\sand\sRevisions(.+)Consensus\sEstimates\sAnalysis.+/$1/s;
$content =~ s/^.+(\(1\)\sBUY)/$1/s;
$content =~ s/^.$//s;
chomp($content);
print $content;


