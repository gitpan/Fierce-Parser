# $Id: DomainScanDetails.pm 207 2009-10-24 20:33:30Z jabra $
package Fierce::Parser::DomainScanDetails;
{
    our $VERSION = '0.01';
    $VERSION = eval $VERSION;

    use Object::InsideOut;
    use XML::LibXML;
    use Fierce::Parser::Domain;
    use Fierce::Parser::Node;
    use Fierce::Parser::PTR;
    use Fierce::Parser::ZoneTransferResult;
    use Fierce::Parser::FindMXResult;
    use Fierce::Parser::RangeResult;

    my @domains : Field : Arg(domains) : Get(domains) : Type(List(Fierce::Parser::Domain));

    sub parse {
        my ( $self, $parser, $doc ) = @_;

        #return Nikto::Parser::ScanDetails->new( hosts => \@hosts );
        my $xpc = XML::LibXML::XPathContext->new($doc);
        my @domains;

        foreach my $h ( $xpc->findnodes('//fiercescan/domainscan') ) {

            my $domain          = $h->getAttribute('domain');
            my $startscan       = $h->getAttribute('startscan');
            my $startscanstr    = $h->getAttribute('startscanstr');
            my ($bruteforce, $zone_transfers, $nameservers, $findmx, $reverselookups);
            my ($extbruteforce, $whois_lookup, $wildcard, $vhost, $find_nearby,$arin_lookup);
            foreach my $ds (
                $xpc->findnodes(
                    '//fiercescan/domainscan[@domain="' . $domain . '"]'
                )
                )
            {
                # {{{ ns
                foreach my $e ( $ds->getElementsByTagName('nameservers') ) {
                    my $starttime       = $e->getAttribute('starttime');
                    my $starttimestr    = $e->getAttribute('starttimestr');
                    my $endtime         = $e->getAttribute('endtime');
                    my $endtimestr      = $e->getAttribute('endtimestr');
                    my $elasptime       = $e->getAttribute('elasptime');
                    my @nodes;
                    foreach my $n ( $e->getElementsByTagName('node') ) {
                        my $node = Fierce::Parser::Node->new(   ip => $n->getAttribute('ip'),
                                                                hostname => $n->getAttribute('hostname'),
                                                                from => $n->getAttribute('from'));
                                                                
                        push(@nodes,$node);
                    }   

                    $nameservers = Fierce::Parser::Domain::NameServers->new(    nodes => \@nodes,
                                                                                starttime => $starttime,
                                                                                starttimestr => $starttimestr,
                                                                                endtime => $endtime, 
                                                                                endtimestr => $endtimestr,
                                                                                elasptime => $elasptime,);
                } # }}}
 
                # {{{ arin
                foreach my $e ( $ds->getElementsByTagName('arin') ) {
                    my $query           = $e->getAttribute('query');
                    my $starttime       = $e->getAttribute('starttime');
                    my $starttimestr    = $e->getAttribute('starttimestr');
                    my $endtime         = $e->getAttribute('endtime');
                    my $endtimestr      = $e->getAttribute('endtimestr');
                    my $elasptime       = $e->getAttribute('elasptime');
                    my @ranges;
                    foreach my $r ( $e->getElementsByTagName('range') ) {
                        my $range = Fierce::Parser::RangeResult->new(       net_handle => $r->getAttribute('nethandle'),
                                                                            net_range => $r->getAttribute('iprange'),
                                                                );

                        push(@ranges,$range);
                    }

                    $arin_lookup = Fierce::Parser::Domain::ARIN->new(           query => $query,
                                                                                result => \@ranges,
                                                                                starttime => $starttime,
                                                                                starttimestr => $starttimestr,
                                                                                endtime => $endtime,
                                                                                endtimestr => $endtimestr,
                                                                                elasptime => $elasptime,);

                } 
                # }}}
                
                # {{{ zt
                foreach my $e ( $ds->getElementsByTagName('zonetransfers') ) {
                    my $starttime       = $e->getAttribute('starttime');
                    my $starttimestr    = $e->getAttribute('starttimestr');
                    my $endtime         = $e->getAttribute('endtime');
                    my $endtimestr      = $e->getAttribute('endtimestr');
                    my $elasptime       = $e->getAttribute('elasptime');
                    
                    my @result;
                    foreach my $z ( $e->getElementsByTagName('zonetransfer') ) { 
                        my $zt_result = Fierce::Parser::ZoneTransferResult->new(    output => $z->textContent,
                                                                                    name_server => $z->getAttribute('nameserver'),
                                                                                    bool => $z->getAttribute('bool'),
                                                                                    domain => $domain,
                                                                                );
                        push(@result,$zt_result);
                    }
                    $zone_transfers = Fierce::Parser::Domain::ZoneTransfers->new(       result => \@result,
                                                                                        starttime => $starttime,
                                                                                        starttimestr => $starttimestr,
                                                                                        endtime => $endtime,
                                                                                        endtimestr => $endtimestr,
                                                                                        elasptime => $elasptime,);

                } # }}}
                
                # {{{ bf
                foreach my $e ( $ds->getElementsByTagName('bruteforce') ) {
                    my $starttime       = $e->getAttribute('starttime');
                    my $starttimestr    = $e->getAttribute('starttimestr');
                    my $endtime         = $e->getAttribute('endtime');
                    my $endtimestr      = $e->getAttribute('endtimestr');
                    my $elasptime       = $e->getAttribute('elasptime');
                    my @nodes;

                    foreach my $n ( $e->getElementsByTagName('node') ) { 
                        my $node = Fierce::Parser::Node->new(   ip => $n->getAttribute('ip'), 
                                                                hostname => $n->getAttribute('hostname'),
                                                                from => $n->getAttribute('from'));

                        push(@nodes,$node);
                    }


                    $bruteforce = Fierce::Parser::Domain::BruteForce->new(      nodes => \@nodes,
                                                                                starttime => $starttime,
                                                                                starttimestr => $starttimestr,
                                                                                endtime => $endtime,
                                                                                endtimestr => $endtimestr,
                                                                                elasptime => $elasptime,);

                } # }}}

                # {{{ subdomain bf
                foreach my $e ( $ds->getElementsByTagName('subdomainbruteforce') ) {
                    my $starttime       = $e->getAttribute('starttime');
                    my $starttimestr    = $e->getAttribute('starttimestr');
                    my $endtime         = $e->getAttribute('endtime');
                    my $endtimestr      = $e->getAttribute('endtimestr');
                    my $elasptime       = $e->getAttribute('elasptime');
                    my @nodes;
                    foreach my $n ( $e->getElementsByTagName('node') ) { 
                        my $node = Fierce::Parser::Node->new(   ip => $n->getAttribute('ip'), 
                                                                hostname => $n->getAttribute('hostname'),
				                                				from => $n->getAttribute('from'));

                        push(@nodes,$node);
                    }

                    $subdomainbruteforce = Fierce::Parser::Domain::SubdomainBruteForce->new(    
                                                                                nodes => \@nodes,										
                                                                                starttime => $starttime,
                                                                                starttimestr => $starttimestr,
                                                                                endtime => $endtime,
                                                                                endtimestr => $endtimestr,
                                                                                elasptime => $elasptime,

                                                                            );

                } # }}}

                # {{{ ext bf
                foreach my $e ( $ds->getElementsByTagName('extbruteforce') ) {
                    my $starttime       = $e->getAttribute('starttime');
                    my $starttimestr    = $e->getAttribute('starttimestr');
                    my $endtime         = $e->getAttribute('endtime');
                    my $endtimestr      = $e->getAttribute('endtimestr');
                    my $elasptime       = $e->getAttribute('elasptime');
                    my @nodes;
                    foreach my $n ( $e->getElementsByTagName('node') ) { 
                        my $node = Fierce::Parser::Node->new(  ip => $n->getAttribute('ip'),hostname => $n->getAttribute('hostname'),from => $n->getAttribute('from'));
                        push(@nodes,$node);
                    }


                    $extbruteforce = Fierce::Parser::Domain::ExtBruteForce->new(nodes => \@nodes,
                                                                                starttime => $starttime,
                                                                                starttimestr => $starttimestr,
                                                                                endtime => $endtime,
                                                                                endtimestr => $endtimestr,
                                                                                elasptime => $elasptime,);

                } # }}}
               
                # {{{ find mx
                foreach my $e ( $ds->getElementsByTagName('findmx') ) {
                    my $starttime       = $e->getAttribute('starttime');
                    my $starttimestr    = $e->getAttribute('starttimestr');
                    my $endtime         = $e->getAttribute('endtime');
                    my $endtimestr      = $e->getAttribute('endtimestr');
                    my $elasptime       = $e->getAttribute('elasptime');
                    my @result;
                    foreach my $n ( $e->getElementsByTagName('mx') ) { 
                        my $mx = Fierce::Parser::FindMXResult->new(   preference => $n->getAttribute('preference'), 
                                                                exchange => $n->getAttribute('exchange'));

                        push(@result,$mx);
                    }
                    $findmx = Fierce::Parser::Domain::FindMX->new(              result => \@result,
                                                                                starttime => $starttime,
                                                                                starttimestr => $starttimestr,
                                                                                endtime => $endtime,
                                                                                endtimestr => $endtimestr,
                                                                                elasptime => $elasptime,);

                } # }}}

                # {{{ vhost
                foreach my $e ( $ds->getElementsByTagName('vhost') ) {
                    my $starttime       = $e->getAttribute('starttime');
                    my $starttimestr    = $e->getAttribute('starttimestr');
                    my $endtime         = $e->getAttribute('endtime');
                    my $endtimestr      = $e->getAttribute('endtimestr');
                    my $elasptime       = $e->getAttribute('elasptime');
                    my @nodes;                    
                    foreach my $n ( $e->getElementsByTagName('node') ) { 
                        my $node = Fierce::Parser::Node->new(   ip => $n->getAttribute('ip'), 
                                                                hostname => $n->getAttribute('hostname'),
                                                                from => $n->getAttribute('from'));

                        push(@nodes,$node);
                    }
                    $vhost = Fierce::Parser::Domain::Vhost->new(                nodes => \@nodes,
                                                                                starttime => $starttime,
                                                                                starttimestr => $starttimestr,
                                                                                endtime => $endtime,
                                                                                endtimestr => $endtimestr,
                                                                                elasptime => $elasptime,);

                } # }}}

                # {{{ wildcard
                foreach my $e ( $ds->getElementsByTagName('wildcard') ) {
                    my $starttime       = $e->getAttribute('starttime');
                    my $starttimestr    = $e->getAttribute('starttimestr');
                    my $endtime         = $e->getAttribute('endtime');
                    my $endtimestr      = $e->getAttribute('endtimestr');
                    my $elasptime       = $e->getAttribute('elasptime');
                    my $bool = (scalar(@{$e->getElementsByTagName('node')}) > 0) ? 1 : 0;
                    $wildcard = Fierce::Parser::Domain::WildCard->new(          bool => $bool,
                                                                                starttime => $starttime,
                                                                                starttimestr => $starttimestr,
                                                                                endtime => $endtime,
                                                                                endtimestr => $endtimestr,
                                                                                elasptime => $elasptime,);

                } 
                # }}}

                # {{{ whois
                foreach my $e ( $ds->getElementsByTagName('whois') ) {
                    my $starttime       = $e->getAttribute('starttime');
                    my $starttimestr    = $e->getAttribute('starttimestr');
                    my $endtime         = $e->getAttribute('endtime');
                    my $endtimestr      = $e->getAttribute('endtimestr');
                    my $elasptime       = $e->getAttribute('elasptime');
                    my @ranges;
                    foreach my $r ( $e->getElementsByTagName('range') ) {
                        my $range = Fierce::Parser::RangeResult->new(  net_handle => $r->getAttribute('nethandle'),
                                                                net_range => $r->getAttribute('iprange'),
                                                                );

                        push(@ranges,$range);
                    }


                    $whois_lookup = Fierce::Parser::Domain::WhoisLookup->new(   result => \@ranges,
                                                                                starttime => $starttime,
                                                                                starttimestr => $starttimestr,
                                                                                endtime => $endtime,
                                                                                endtimestr => $endtimestr,
                                                                                elasptime => $elasptime,);

                } 
                # }}}
                
                # {{{ rev lookup         
                foreach my $e ( $ds->getElementsByTagName('reverselookup') ) {
                    my $starttime       = $e->getAttribute('starttime');
                    my $starttimestr    = $e->getAttribute('starttimestr');
                    my $endtime         = $e->getAttribute('endtime');
                    my $endtimestr      = $e->getAttribute('endtimestr');
                    my $elasptime       = $e->getAttribute('elasptime');
                    
                    my @nodes;

                    foreach my $n ( $e->getElementsByTagName('node') ) { 
                        my $node = Fierce::Parser::Node->new(   ip => $n->getAttribute('ip'), 
                                                                hostname => $n->getAttribute('hostname'),
                                                                from => $n->getAttribute('from'));

                        push(@nodes,$node);
                    }


                    $reverselookups = Fierce::Parser::Domain::ReverseLookups->new(    
                                                                                nodes => \@nodes,
                                                                                starttime => $starttime,
                                                                                starttimestr => $starttimestr,
                                                                                endtime => $endtime,
                                                                                endtimestr => $endtimestr,
                                                                                elasptime => $elasptime,);

                } 
                # }}}
                # {{{ find nearby      
                foreach my $e ( $ds->getElementsByTagName('findnearby') ) {
                    my $starttime       = $e->getAttribute('starttime');
                    my $starttimestr    = $e->getAttribute('starttimestr');
                    my $endtime         = $e->getAttribute('endtime');
                    my $endtimestr      = $e->getAttribute('endtimestr');
                    my $elasptime       = $e->getAttribute('elasptime');
                    
                    my @ptrs;

                    foreach my $n ( $e->getElementsByTagName('ptr') ) { 
                        my $ptr = Fierce::Parser::PTR->new(   ip => $n->getAttribute('ip'), 
                                                                hostname => $n->getAttribute('hostname'),
                                                                ptrdname => $n->getAttribute('ptrdname'),
                                                                from => $n->getAttribute('from'));

                        push(@ptrs,$ptr);
                    }


                    $find_nearby = Fierce::Parser::Domain::FindNearby->new(    
                                                                                ptrs => \@ptrs,
                                                                                starttime => $starttime,
                                                                                starttimestr => $starttimestr,
                                                                                endtime => $endtime,
                                                                                endtimestr => $endtimestr,
                                                                                elasptime => $elasptime,);

                } 
                # }}}



            }
            my $domain_obj = Fierce::Parser::Domain->new(   domain => $domain,
                                                        startscan => $startscan,
                                                        startscanstr => $startscanstr,
                                                        ext_bruteforce => $extbruteforce,
                                                        bruteforce => $bruteforce, 
                                                        subdomain_bruteforce => $subdomainbruteforce,
                                                        zone_transfers => $zone_transfers, 
                                                        name_servers => $nameservers, 
                                                        findmx => $findmx, 
                                                        vhost => $vhost, 
                                                        reverse_lookups => $reverselookups,
                                                        wildcard => $wildcard,
                                                        arin_lookup => $arin_lookup,
                                                        whois_lookup => $whois_lookup,
                                                        find_nearby => $find_nearby,
                                                    );
            push(@domains, $domain_obj);
                
        }
        
        return Fierce::Parser::DomainScanDetails->new( domains => \@domains );
    }

    sub get_host_ip {
        my ( $self, $ip ) = @_;
        #return $hosts[0];
        return;
    }

    sub get_host_hostname {
        my ( $self, $hostname ) = @_;
        my @hosts = grep( $_->domain eq $hostname, @{ $self->domains } );
        return $hosts[0];
    }

    sub all_hosts {
        my ($self) = @_;
        return @{ $self->domains };
    }

    sub print_hosts {
        my ($self) = @_;
        #   foreach my $host ( @{ $self->hosts } ) {
        #    print "IP: " . $host->ip . "\n";
        #    print "Hostname: " . $host->hostname . "\n";
        #}
        return;
    }

}
1;
