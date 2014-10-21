# $Id: SubdomainBruteForce.pm 208 2009-10-24 20:36:42Z jabra $
package Fierce::Parser::Domain::SubdomainBruteForce;
{
    our $VERSION = '0.01';
    $VERSION = eval $VERSION;

    use Object::InsideOut;
    use Fierce::Parser::Node;

    my @nodes : Field : Arg(nodes) : Get(nodes) : Type(List(Fierce::Parser::Node));

    my @starttime : Field : Arg(starttime) : Get(starttime);
    my @endtime : Field : Arg(endtime) : Get(endtime);
    my @starttimestr : Field : Arg(starttimestr) : Get(starttimestr);
    my @endtimestr : Field : Arg(endtimestr) : Get(endtimestr);
    my @elasptime : Field : Arg(elasptime) : Get(elasptime);
}
1;
