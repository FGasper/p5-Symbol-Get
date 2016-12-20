package t::usage;

use strict;
use warnings;

use Test::More;
plan tests => 9;

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
    Symbol::Get::get('%t::Foo::Bar::'),
    \%t::Foo::Bar::,
    'symbol table hash',
);

is(
    Symbol::Get::get('&t::Foo::Bar::code'),
    \&t::Foo::Bar::code,
    'code',
);

#----------------------------------------------------------------------

package t::Foo::Bar;

use Test::More;

our $thing = 'thing';

our @list = qw( a b c );

our %hash = ( a => 1, b => 2 );

sub code { }

is(
    Symbol::Get::get('$thing'),
    \$t::Foo::Bar::thing,
    'scalar, no package',
);

is(
    Symbol::Get::get('@list'),
    \@t::Foo::Bar::list,
    'list, no package',
);

is(
    Symbol::Get::get('%hash'),
    \%t::Foo::Bar::hash,
    'hash, no package',
);

is(
    Symbol::Get::get('&code'),
    \&t::Foo::Bar::code,
    'code, no package',
);

1;
