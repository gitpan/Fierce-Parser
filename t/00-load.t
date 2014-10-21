#!perl -T

use Test::More tests => 19;


BEGIN {
    use_ok( 'Fierce::Parser' );
    use_ok( 'Fierce::Parser::Session') ;
    use_ok( 'Fierce::Parser::Node');
    use_ok( 'Fierce::Parser::DomainScanDetails');
    use_ok( 'Fierce::Parser::Arin');
    use_ok( 'Fierce::Parser::PTR');
    use_ok( 'Fierce::Parser::FindMXResult');
    use_ok( 'Fierce::Parser::WhoisLookupResult');
    use_ok( 'Fierce::Parser::ZoneTransferResult');
    use_ok( 'Fierce::Parser::Domain::ZoneTransfers');
    use_ok( 'Fierce::Parser::Domain::BruteForce');
    use_ok( 'Fierce::Parser::Domain::ExtBruteForce');
    use_ok( 'Fierce::Parser::Domain::FindMX');
    use_ok( 'Fierce::Parser::Domain::Vhost');
    use_ok( 'Fierce::Parser::Domain::WhoisLookup');
    use_ok( 'Fierce::Parser::Domain::WildCard');
    use_ok( 'Fierce::Parser::Domain::NameServers');
    use_ok( 'Fierce::Parser::Domain::ReverseLookups');
    use_ok( 'Fierce::Parser::Domain::FindNearby');

}

diag( "Testing Test::Class::Load $Test::Class::Load::VERSION, Perl $], $^X" );
