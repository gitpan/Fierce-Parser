# $Id: Node.pm 207 2009-10-24 20:33:30Z jabra $
package Fierce::Parser::Node;
{
    our $VERSION = '0.01';
    $VERSION = eval $VERSION;

    use Object::InsideOut;
    my @ip : Field : Arg(ip) : Get(ip) ;
    my @hostname : Field : Arg(hostname) : Get(hostname);
    my @from : Field : Arg(from) : Get(from);
}
1;
