# $Id: FindNearby.pm 208 2009-10-24 20:36:42Z jabra $
package Fierce::Parser::Domain::FindNearby;
{
    our $VERSION = '0.01';
    $VERSION = eval $VERSION;

    use Object::InsideOut;

    my @ptrs : Field : Arg(ptrs) : Get(ptrs) : Type(List(Fierce::Parser::PTR));

    my @starttime : Field : Arg(starttime) : Get(starttime);
    my @endtime : Field : Arg(endtime) : Get(endtime);
    my @starttimestr : Field : Arg(starttimestr) : Get(starttimestr);
    my @endtimestr : Field : Arg(endtimestr) : Get(endtimestr);
    my @elasptime : Field : Arg(elasptime) : Get(elasptime);
}
1;
