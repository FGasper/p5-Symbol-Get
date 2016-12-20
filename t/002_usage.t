package t::usage;

use strict;
use warnings;

use Test::More;
plan tests => 4;

use Symbol::Get ();

is(
    Symbol::Get::get('$t::Foo::Bar::thing'),
    \$t::Foo::Bar::thing,
    'scalar',
);

is(
    Symbol::Get::get('@t::Foo::Bar::list'),
    \@t::Foo::Bar::list,
    'list',
);

is(
    Symbol::Get::get('%t::Foo::Bar::hash'),
    \%t::Foo::Bar::hash,
    'hash',
);

is(
    Symbol::Get::get('&t::Foo::Bar::code'),
    \&t::Foo::Bar::code,
    'code',
);

#----------------------------------------------------------------------

package t::Foo::Bar;

our $thing = 'thing';

our @list = qw( a b c );

our %hash = ( a => 1, b => 2 );

sub code { }

1;
