# $Id: FindMX.pm 297 2009-11-16 04:37:07Z jabra $
package Fierce::Parser::Domain::FindMX;
{
    our $VERSION = '0.01';
    $VERSION = eval $VERSION;

    use Object::InsideOut;

    my @result : Field : Arg(result) : Get(result) :
        Type(List(Fierce::Parser::FindMXResult));

    my @starttime : Field : Arg(starttime) : Get(starttime);
    my @endtime : Field : Arg(endtime) : Get(endtime);
    my @starttimestr : Field : Arg(starttimestr) : Get(starttimestr);
    my @endtimestr : Field : Arg(endtimestr) : Get(endtimestr);
    my @elapsedtime : Field : Arg(elapsedtime) : Get(elapsedtime);
}
1;
