#!/usr/bin/perl -w

use strict;
use LWP::Simple;

# Error checking
die "Usage: parseRecommendations.pl ERICB.ST\n" if(scalar @ARGV < 1);
my $symbol = shift @ARGV;

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

# Clean up
unlink($foutname);

# Error checking for symbol not found
die "Error: Unknown symbol '$symbol', please provide a valid one.\n" if($content =~ /Your search for "$symbol" did not match/);

# Cut away unnecessary text
$content =~ s/^.+Analyst\sRecommendations\sand\sRevisions(.+)Consensus\sEstimates\sAnalysis.+/$1/s;
$content =~ s/^.+(\(1\)\sBUY)/$1/s;
$content =~ s/\n+/\n/g;

# Convert text to tokens
my @tokens = split("\n", $content);

# Convert recommendations to csv format
while(scalar @tokens > 0)
{
	print shift @tokens;
	for(my $i=0; $i<4; ++$i){
		print ";", shift @tokens;
	}
	print "\n";
}

