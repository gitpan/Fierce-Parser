#!/usr/bin/perl
# $Id$
package t::Test;
use Fierce::Parser;
use Fierce::Parser::Session;
use Fierce::Parser::Node;
use Fierce::Parser::DomainScanDetails;

use base 'Test::Class';
use Test::More;

sub setup : Test(setup => no_plan) {
    my ($self) = @_;

    if ( -r 'examples/test1.xml') {
        $self->{parser1} = Fierce::Parser->parse_file('examples/test1.xml');
    }
    else {
        $self->{parser1} = Fierce::Parser->parse_file('test1.xml');
    }
    if ( -r 'examples/test2.xml'){
        $self->{parser2} = Fierce::Parser->parse_file('examples/test2.xml');
    }
    else {
        $self->{parser2} = Fierce::Parser->parse_file('test2.xml');
    }
}
1;
