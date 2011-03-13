# Design Notes #

## Goal ##

The goal is to provide a language agnostic way of extracting code
documentation and providing a variety of output formats (HTML, PDF,
man pages etc...)

Markdown syntax is used because of it being simple and human-readable
yet easy to write. One does not have to remember many syntax elements

Also this way allows each project team to set own documentation
conventions.

Together with i.e CSS style sheets the output can be formatted to ones
liking.

## Ideas ##

The idea is to use markdown syntax in the source code and then translate
that into other formats with utilities like markdown parser and
[pandoc](http://johnmacfarlane.net/pandoc/ "Pandoc")

Since most, if not all programing languages provide _comment blocks_
(Perl being the big exception here),
the following has been devised:

* an "open comment block" symbol on a line by itself starts a _documentation block_
* a "close comment block" symbol on a line by itself ends a _documentation block_
* anything in between is written in markdown syntax and will be parsed

This way, one can still have code documentation inside the source code
that will not be parsed. It doesn't restrict the developer or inhibit
him from writing comments to help understand his code. At the same time,
this ensure the usage documentation as well as examples and discussion
about limitations etc... stay inside the source code in a human-readable
way. Thus the documentation cannot be lost or separated from the source
code.

## Problems ##

Problems arise with programming languages that do not have multiline
comments. Examples are Perl and bash. 

* For Perl the workaround is to use POD syntax. So we define the
 following as a block of documentation:
    =pod
        our documentation goes here
    =pod
    =cut 

The `=cut` is needed to tell the Perl parser that we are done with
POD and to continue parsing the code. This means code between `=pod`
and `=cut` is ignored by the parser.

Note that this is probably not valid POD syntax and will raise errors
when parsed with perlpod.

Since there are several, mainly scripting languages that do not have multiline comments we devise the following
* declare open and closing block as i.e. #BEGIN_DOC if "#" is the comment symbol
then strip the comment symbol from the beginning of every line
## Project ##

This project will provide a parser for this kind of documentation and
give a few use-cases
TODO
====

* better argument parsing (getopt??)
