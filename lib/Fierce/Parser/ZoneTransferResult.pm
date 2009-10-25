# $Id: ZoneTransferResult.pm 207 2009-10-24 20:33:30Z jabra $
package Fierce::Parser::ZoneTransferResult;
{
    our $VERSION = '0.01';
    $VERSION = eval $VERSION;

    use Object::InsideOut;
    my @name_server : Field : Arg(name_server) : Get(name_server) ;
    my @domain : Field : Arg(domain) : Get(domain) ;
    my @bool : Field : Arg(bool) : Get(bool);
    my @output : Field : Arg(output) : Get(output);
}
1;
