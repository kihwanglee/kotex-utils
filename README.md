kotex-utils
===========

Introduction
------------

kotex-utils contains useful scripts and support files for index generation
aiding typesetting Korean documents. kotex-utils kotex-utf belongs to ko.TeX, 
a comprehensive Korean typesetting system together with packages kotex-utf,
kotex-oblivoir, kotex-plain, cjk-ko, xetexko, and luatexko.

Files
-----

### TeXinputs

	hangulhook.sty -> tex/xelatex/kotex-utils/
	hanjahook.sty -> tex/xelatex/kotex-utils/

### Scripts

	jamo-normalize.pl -> scripts/kotex-utils/
	komkindex.pl -> scripts/kotex-utils/
	kotexindy.pl -> scripts/kotex-utils/
	ttf2kotexfont.py -> scripts/kotex-utils/

### Makeindex styles

	kotex.ist -> makeindex/kotex-utils/
	memucs-manual.ist -> makeindex/kotex-utils/

### Xindy styles

	utf8-lang.xdy -> xindy/modules/lang/korean
	utf8.xdy -> xindy/modules/lang/korean

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

### komkindex.pl and kotexindy.pl

`komkindex.pl` is a wrapper of standard makeindex utility generating indices for 
Korean documents. You can use komkindex.pl with an index style file `kotex.ist`
as follows:

    $ komkindex.pl -s kotex foo

It generates `foo.ind` from `foo.idx` and sorts the index entries according to
the Korean alphabet order.

kotex-utils also provides `kotexindy.pl`, a wrapper for powerful Unicode index 
generator `xindy`. If you are using xetex-ko or luatex-ko for typesetting Korean,
it is recommended to use `kotexindy.pl`.
For more information, please refer to the kotex-utf package documentation.

### ttf2kotexfont.pl

`ttf2kotexfont.pl` is a utility for generating tfm files for truetype fonts
to be used in legacy TeX engines. Please refer to the kotex-utf package 
documentation for more information.

### hangulhook.sty

`hangulhook.sty` provides a user-definable Hangul syllable hook facility.
For example, you can do something like the following:

    \documentclass{article}
    \usepackage{kotex}
    \setmainhangulfont{HCR Batang LVT}
    \usepackage{color}
    \usepackage{hangulhook}
    \renewcommand\hangulhook[1]{\textcolor{blue}{#1}}
    \begin{document}
    \usehangulhook{a가b나c다d라1가2나3다4라}
    \begin{usehangulhook}
    abcd

    가나다라

    1234
    \end{usehangulhook}
    \end{document}

Compiling the above code with `xelatex` will produce PDF file in which
every Hangul syllables get colored in blue as instructed by the user 
redefined `\hangulhook` command.  Keep in mind that this function is 
only available when the XeLaTeX engine is used.

### hanjahook.sty

`hanjahook.sty` offers a hooking facility for hanja characters.
It is desinged for manipulate hanja characters in a document-wide fashion,
For example, to adjust baselines for every hanja characters in a document, you need to
define `\hanjahook` as follows:

    \def\hanjahook#1{\lower1ex\hbox{#1}}

License
-------

kotex-utils is licensed under the LaTeX Project Public
License (LPPL).

Contacts
--------

Please report any errors or suggestions to the package maintainer,
Kihwang Lee <leekh@ktug.org>.
