kotex-utils
===========

Introduction
------------

kotex-utils contains useful scripts and support files for Hangul
syllable and jamo character conversion and index generation
aiding typesetting Korean documents. kotex-utils kotex-utf belongs to ko.TeX, 
a comprehensive Korean typesetting system together with packages kotex-utf,
kotex-oblivoir, kotex-plain, cjk-ko, xetexko, and luatexko.

Dependency
----------

kotex-utils cannot be used without kotex-utf package.

Files
-----

### Scripts

	jamo-normalize.pl -> scripts/kotex-utils/
	komkindex.pl -> scripts/kotex-utils/
	ttf2kotexfont.py -> scripts/kotex-utils/

### Makeindex styles

	kotex.ist -> makeindex/kotex-utils/
	memucs-manual.ist -> makeindex/kotex-utils/

### Documents

	README (this file) -> doc/latex/kotex-utils/

Usage
-----

### jamo-normalize.pl

`jamo-normalize.pl` is used for converting Unicode Hangul jamos to Unicode 
syllables and vice versa. It has a simple usage as follows:

    $ jamo-normalize.pl [option] < infile > outfile

Major options are:

* `-d`: convert Unicode syllables to jamos
* `-h`: show help message
* `-i`: convert CJK compatibility ideographs (Chinese characters) to CJK unified ideographs
* `-o`: convert Hanyang PUA syllables to Unicode jamos
* `-p`: convert Unicode jamos to Hanyang PUA syllables.
* `-t`: convert [U+00B7] and [U+003A] to proper tone markers.

### komkindex.pl

`komkindex.pl` is a wrapper of standard makeindex utility generating indices for 
Korean documents. You can use komkindex.pl with an index style file `kotex.ist`
as follows:

    $ komkindex.pl -s kotex foo

It generates `foo.ind` from `foo.idx` and sorts the index entries according to
the Korean alphabet order.

### ttf2kotexfont.pl

`ttf2kotexfont.pl` is a utility for generating tfm files for truetype fonts
to be used in legacy TeX engines. Please refer to the kotex-utf package 
documentation for more information.

License
-------

kotex-utils is licensed under the LaTeX Project Public
License (LPPL).

Contacts
--------

Please report any errors or suggestions to the package maintainer,
Kihwang Lee <leekh@ktug.org>.
