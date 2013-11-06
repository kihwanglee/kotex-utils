kotex-utils
===========

Introduction
------------

kotex-utils contains useful scripts and support files for Hangul
syllable and jamo character conversion and index generation
aiding typesetting Korean documents. kotex-utils belongs to ko.TeX, 
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

### Xindy modules

    utf8-lang.xdy -> xindy/modules/lang/korean
    utf8.xdy -> xindy/modules/lang/korean

### Documents

    README (this file) -> doc/latex/kotex-utils/

Usage
-----

### jamo-normalize.pl

`jamo-normalize.pl` is used for normalizing Hangul text.
It translates Hangul Jamo sequence to precomposed Hangul Syllables. 
It has a simple usage as follows:

    $ perl jamo-normalize.pl [option] < infile > outfile

Options are:

* `-b`: insert Zero Width Space between Hangul syllable blocks. 
This option is just for a proof of concept. Do not use in practice.
* `-c`: convert conjoining Jamo to compatibility Jamo if reasonable.
* `-d`: only decompose Hangul syllables and no further recomposition. Not
recommended for a practical use.
* `-i`: convert CJK Compatibility Ideographs to normal CJK Ideographs
* `-o`: decompose PUA Old Hangul syllables to Hangul Jamo sequence
* `-p`: translate Jamo sequence to PUA Old Hangul syllables. Not recommended for
a practical use.
* `-r`: reorder Hangul Tone Marks to the first position of syllable block. This
option is just for a proof of concept. Do not use in practice.
* `-t`: convert U+00B7 (·) or U+003A (:) to Hangul Tone Marks

### komkindex.pl

`komkindex.pl` is a wrapper of standard makeindex utility generating indices for 
Korean documents. You can use komkindex.pl with an index style file `kotex.ist`
as follows:

    $ perl komkindex.pl -s kotex foo

It generates `foo.ind` from `foo.idx` and sorts the index entries according to
the Korean alphabet order.

### xindy modules

kotex-utils also provides modules for powerful Unicode index
generator `xindy`. If you are using xetexko or luatexko for typesetting 
Korean, it is recommended to use these modules for sorting Hangul
index entries. It only supports UTF-8 encoding.
If these modules are placed in a propor directory as suggest above,
you can use them as follows:


    $ texindy -L korean -I omega foo.idx

or

    $ xindy -M texindy -L korean -C utf8 foo.idx

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
