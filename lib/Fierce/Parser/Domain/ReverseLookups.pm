# $Id: ReverseLookups.pm 207 2009-10-24 20:33:30Z jabra $
package Fierce::Parser::Domain::ReverseLookups;
{
    our $VERSION = '0.01';
    $VERSION = eval $VERSION;

    use Object::InsideOut;

    my @nodes : Field : Arg(nodes) : Get(nodes) : Type(List(Fierce::Parser::Node));

    my @starttime : Field : Arg(starttime) : Get(starttime);
    my @endtime : Field : Arg(endtime) : Get(endtime);
    my @starttimestr : Field : Arg(starttimestr) : Get(starttimestr);
    my @endtimestr : Field : Arg(endtimestr) : Get(endtimestr);
    my @elasptime : Field : Arg(elasptime) : Get(elasptime);
}
1;
