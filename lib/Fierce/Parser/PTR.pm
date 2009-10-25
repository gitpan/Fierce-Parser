# $Id: PTR.pm 208 2009-10-24 20:36:42Z jabra $
package Fierce::Parser::PTR;
{
    our $VERSION = '0.01';
    $VERSION = eval $VERSION;

    use Object::InsideOut;
    my @ip : Field : Arg(ip) : Get(ip) ;
    my @hostname : Field : Arg(hostname) : Get(hostname);
    my @ptrdname : Field : Arg(ptrdname) : Get(ptrdname);
    my @from : Field : Arg(from) : Get(from);
}
1;
