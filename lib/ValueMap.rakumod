# Use nqp ops as if we are in the core
use nqp;

my constant &new   = Map.^lookup('new');
my constant &STORE = Map.^lookup('STORE');

my class ValueMap:ver<0.0.1>:auth<zef:lizmat> is Map {
    method new(|c) {
        my $valuemap = new(self, |c)  # need containerization for QuantHashes
    }
    method STORE(|c) { STORE(self, |c, :DECONT) }

    multi method WHICH(ValueMap:D:) {
        nqp::box_s(
          nqp::concat(
            nqp::if(
              nqp::eqaddr(self.WHAT,ValueMap),
              'ValueMap|',
              nqp::concat(self.^name,'|')
            ),
            nqp::sha1(
              nqp::join(
                '|',
                nqp::stmts(  # cannot use native str arrays early in setting
                  (my $keys    := nqp::list_s),
                  (my $storage := nqp::getattr(self,Map,'$!storage')),
                  (my $iter    := nqp::iterator($storage)),
                  nqp::while(
                    $iter,
                    nqp::push_s($keys,nqp::iterkey_s(nqp::shift($iter))),
                  ),
                  (my $sorted := Rakudo::Sorting.MERGESORT-str($keys)),
                  (my $strings := nqp::list_s),
                  nqp::while(
                    nqp::elems($sorted),
                    nqp::push_s(
                      $strings,
                      nqp::atkey(
                        $storage,
                        nqp::push_s($strings,nqp::shift_s($sorted))
                      ).Str
                    )
                  ),
                  $strings
                )
              )
            )
          ),
          ValueObjAt
        )
    }
}

sub EXPORT() {
    CORE::.EXISTS-KEY('ValueMap')
      ?? Map.new
      !! Map.new( (ValueMap => ValueMap) )
}

=begin pod

=head1 NAME

ValueMap - Provide an immutable Map value type

=head1 SYNOPSIS

=begin code :lang<raku>

use ValueMap;

=end code

=head1 DESCRIPTION

The functionality provided by this module, will be provided in language
level 6.e and higher. If an implementation of ValueMap is already available,
loading this module becomes a no-op.

Raku provides a semi-immutable Associative datatype: Map. A Map can not have
any elements added or removed from it.  However, since a Map can contain
containers of which the value can be changed, it is B<not> a value type. So
you cannot use Maps in data structures such as Sets, because each Map is considered to be different from any other List, because they are not value types.

=head1 AUTHOR

Elizabeth Mattijsen <liz@raku.rocks>

=head1 COPYRIGHT AND LICENSE

Copyright 2022 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod