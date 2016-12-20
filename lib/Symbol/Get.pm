package Symbol::Get;

use strict;
use warnings;

#use Call::Context;

our $VERSION = 0.01;

=encoding utf-8

=head1 NAME

Symbol::Get - Read Perl’s symbol table programmatically

=head1 SYNOPSIS

    package Foo;

    our $name = 'haha';
    our @list = ( 1, 2, 3 );
    our %hash = ( foo => 1, bar => 2 );

    sub doit { ... }

    my $name_sr = Symbol::Get::get('$Foo::name');    # \$name
    my $list_ar = Symbol::Get::get('$Foo::list');    # \@list
    my $hash_hr = Symbol::Get::get('$Foo::hash');    $ \%hash

    #Defaults to __PACKAGE__ if none is given:
    my $doit_cr = Symbol::Get::get('&doit');

=head1 DESCRIPTION

Occasionally I have need to reference a variable programmatically.
This module facilitates that by providing an easy, read-only access to the
symbol table.

The above should pretty well cover usage.

=head1 SEE ALSO

=over 4

=item * L<Symbol::Values>

=back

=head1 LICENSE

This module is licensed under the same license as Perl.

=cut

my %_sigil_to_type = qw(
    $   SCALAR
    @   ARRAY
    %   HASH
    &   CODE
);

my $sigils_re_txt = join('|', keys %_sigil_to_type);

sub get {
    my ($var) = @_;

    die 'Need a variable name!' if !length $var;

    my $sigil = substr($var, 0, 1);

    my $type = $_sigil_to_type{$sigil} or die "Unrecognized sigil: “$sigil”";

    my $table_hr = _get_table_hr( substr($var, 1) );
    return *{$table_hr}{$type};
}

#----------------------------------------------------------------------
# To be completed if needed:
#
#    #The below return the same results.
#    my @names = Symbol::Get::list('Foo');
#    my @names = Symbol::Get::list();
#sub list_sigils {
#    my ($full_name) = @_;
#
#    Call::Context::must_be_list();
#
#    my ($module, $name) = ($full_name =~ m<(?:(.+)::)?(.+)>);
#
#    my $table_hr = _get_table_for_module_name($module);
#    my $glob = *{$table_hr};
#
#    return
#}
#
#sub list_names {
#    my ($module) = @_;
#
#    Call::Context::must_be_list();
#
#    return
#}

#----------------------------------------------------------------------

sub _get_table_hr {
    my ($name) = @_;

    if (index($name, '::') == -1) {
        substr($name, 0, 0) = (caller 1)[0] . '::';
    }

    my $table_hr = \%main::;

    my @nodes = split m<::(?=.)>, $name;
    my $last = pop @nodes;

    my $pkg = q<>;

    for my $n (@nodes) {
        $table_hr = $table_hr->{"$n\::"} || die "Unknown package: $pkg\::$n";
        $pkg .= "$n\::";
    }

    return $table_hr->{$last} || die "Unknown symbol: $pkg\::$name";
}

1;
