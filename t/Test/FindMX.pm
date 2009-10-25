#!/usr/bin/perl
# $Id: FindMX.pm 14 2009-03-02 01:04:45Z jabra $
package t::Test::FindMX;

use base 't::Test';
use Test::More;
use Data::Dumper;
sub fields : Tests {
    my ($self) = @_;
  
    my $session1 = $self->{parser1}->get_session();

    my $domainscandetails = $session1->domainscandetails;
    my @domains = @{ $domainscandetails->domains } ;
    my $domain_obj = $domains[0];

    my $findmx = $domain_obj->findmx;

    is ( $findmx->starttime, '1220494203', 'startscan');
    is ( $findmx->starttimestr, 'Wed Sep  3 22:10:03 2008', 'startscanstr');
    is ( $findmx->endtime, '1220494203', 'endscan');
    is ( $findmx->endtimestr, 'Wed Sep  3 22:10:03 2008', 'endscanstr');
    is ( $findmx->elasptime, '0', 'elasp');
}
1;
