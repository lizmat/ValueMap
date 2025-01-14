[![Actions Status](https://github.com/lizmat/ValueMap/actions/workflows/linux.yml/badge.svg)](https://github.com/lizmat/ValueMap/actions) [![Actions Status](https://github.com/lizmat/ValueMap/actions/workflows/macos.yml/badge.svg)](https://github.com/lizmat/ValueMap/actions) [![Actions Status](https://github.com/lizmat/ValueMap/actions/workflows/windows.yml/badge.svg)](https://github.com/lizmat/ValueMap/actions)

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

Raku provides a semi-immutable `Associative` datatype: `Map`. A `Map` can not have any elements added or removed from it. However, since a `Map` **can** contain containers of which the value can be changed, it is **not** a value type. So you cannot use `Map`s in data structures such as `Set`s, because each `Map` is considered to be different from any other `Map`, because they are not value types.

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/ValueMap . Comments and Pull Requests are welcome.

If you like this module, or what I’m doing more generally, committing to a [small sponsorship](https://github.com/sponsors/lizmat/) would mean a great deal to me!

COPYRIGHT AND LICENSE
=====================

Copyright 2022, 2024, 2025 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

