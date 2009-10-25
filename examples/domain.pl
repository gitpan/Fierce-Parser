#!/usr/bin/perl -w
use strict;
use Fierce::Parser;
use Data::Dumper;
my $fp = new Fierce::Parser;
my $parser = $fp->parse_file('test1.xml');
my $node    = $parser->get_node('thisisjustfortestingfierce.com');

print $node->domain . "\n";
