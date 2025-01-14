# Use nqp ops as if we are in the core
use nqp;

my constant &new   = Map.^lookup('new');
my constant &STORE = Map.^lookup('STORE');
my constant &raku  = Map.^lookup('raku');

my class ValueMap is Map {
    has ValueObjAt $!WHICH;

    method new(|c) {
        my $valuemap = new(self, |c)  # need containerization for QuantHashes
    }

    method STORE(+@values, :INITIALIZE($)!) {
        STORE
          self,
          @values == 1
            && nqp::iscont(my $first := @values.head)
            && nqp::istype($first,ValueMap)
            ?? nqp::decont($first).iterator
            !! @values,
          :INITIALIZE, :DECONT
    }

    multi method WHICH(ValueMap:D:) {
        nqp::isconcrete($!WHICH)
          ?? $!WHICH
          !! ($!WHICH := nqp::box_s(
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
        ))
    }

    multi method raku(ValueMap:D:) { raku(self) }
    multi method Str(ValueMap:D:)  { raku(self) }
    multi method gist(ValueMap:D:) { raku(self) }
}

my sub EXPORT() {
    CORE::.EXISTS-KEY('ValueMap')
      ?? Map.new
      !! Map.new("ValueMap" => ValueMap)
}

# vim: expandtab shiftwidth=4
