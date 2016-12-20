package t::usage;

use strict;
use warnings;

use Test::More;
use Test::Deep;
use Test::Exception;

plan tests => 13;

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

is(
    Symbol::Get::get('&t::Foo::Bar::i_am_not_there'),
    undef,
    'get() returns undef on an unknown variable name',
);

#----------------------------------------------------------------------

cmp_deeply(
    [ Symbol::Get::get_names('t::Foo::Bar') ],
    superbagof( qw( thing list hash code ) ),
    'get_names()',
) or diag explain [ Symbol::Get::get_names('t::Foo::Bar') ];

throws_ok(
    sub { () = Symbol::Get::get_names('t::Foo::Bar::NOT_THERE') },
    qr<t::Foo::Bar::NOT_THERE>,
    'get_names() throws on an unknown package name',
);

#----------------------------------------------------------------------

package t::Foo::Bar;

use Test::More;
use Test::Deep;

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

cmp_deeply(
    [ Symbol::Get::get_names() ],
    superbagof( qw( thing list hash code ) ),
    'get_names(), no package',
) or diag explain [ Symbol::Get::get_names('t::Foo::Bar') ];

1;
