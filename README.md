[![Actions Status](https://github.com/lizmat/ValueMap/workflows/test/badge.svg)](https://github.com/lizmat/ValueMap/actions)

NAME
====

ValueMap - Provide an immutable Map value type

SYNOPSIS
========

```raku
use ValueMap;

my %vm is ValueMap = foo => 42, bar => 666, baz => 137;

my $vm := ValueMap.new( (foo => 42, bar => 666, baz => 137) );

my %s is Set = $vm, %vm;
say %s.elems;  # 1
```

DESCRIPTION
===========

The functionality provided by this module, will be provided in language level 6.e and higher. If an implementation of ValueMap is already available, loading this module becomes a no-op.

Raku provides a semi-immutable Associative datatype: Map. A Map can not have any elements added or removed from it. However, since a Map can contain containers of which the value can be changed, it is **not** a value type. So you cannot use Maps in data structures such as Sets, because each Map is considered to be different from any other List, because they are not value types.

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

COPYRIGHT AND LICENSE
=====================

Copyright 2022 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

