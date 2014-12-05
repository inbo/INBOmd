The standard Latex classes (article, report etc) support ten, eleven and
twelve point text. These are the commonest sizes used in publishing.
However, for certain applications there may be a need for other sizes.
The extsizes classes (extarticle, extreport, extbook, extletter, and
extproc) provide support for sizes eight, nine, ten, eleven, twelve,
fourteen, seventeen and twenty points.

The extsizes classes and class options were first written by Wolfgang
May, by adapting the standard Latex classes. James Kilfiger
made some modifications and rewrote the size options. 

Should you be using extsizes?
Don't use extsizes just because you think its cool, or because you think
the font looks too small on the screen.  You should have a clear reason
why 10,11 or 12pt text is not suitable for you.  Also the extsizes
package is not suitable for creating oversize pages for scaling by a
printer or photocopier, this can be done with the the geometry package
and the mag option (another of my hacks I'm afraid).  Good reasons for
using the extsizes package might include conforming to requirements set
by an examining institution, or making a large print copy for use by the
partially sighted.

How to install extsizes.
You should place all the files in `a place where Tex can find them'.
Examples of where Tex looks for files include the .../texmf/tex/latex
directory tree, a local texmf tree, anywhere specified in a TEXINPUTS
environment variable or the same directory as your Latex documents.  
You should then refresh the file name database. This is done with a
command `texhash' on tetex distributions and from the start menu with
miktex.   For other distributions of tex read the manual to see if this
step is required.

How to use extsizes.
Your documentclass command should look like:
	\documentclass[14pt]{extreport}
or 
	\documentclass[9pt]{extarticle}
The sizes available are 8pt, 9pt, 10pt, 11pt, 12pt, 14pt, 17pt, and 20pt.
There should be no need to change any other part of your document.

There is also a package, extsizes.sty, which can be used with
nonstandard document classes.  But it cannot be guaranteed to work with
any give class.  Don't use it at the same time as one of the extsizes
classes. It takes as package options 8pt--20pt.  This comes from an idea
of Hans Steffani.

Compatibility mode broken.
You cannot use these classes in `compatibility mode', nor can they be
used with latex 2.09.  Therefore \documentstyle[20pt]{extarticle} won't
work.  Compatibility mode should not be used for new documents.

Bad line breaking.
If you are using 20pt text Tex will probably have difficulty finding
good line breaks, so you will get warnings about overfull hboxes.  
If this is distracting you may put \sloppy in the preamble of your
document, but it is better to try to help Tex to find good line breaks
by inserting \- or rewriting short sections.

Warnings about Font substitutions.
The large class options use some very large fonts. Up to about 50pt for
the 20pt class options.  You may find this causes problems with with
if these fonts are not declared to be available by a \DeclareFontShape
command.  You should either use fonts like Times which are usually
available in all sizes, or redeclare the fonts.  There is an example of
this in the extsizes classes for cmr.  You should also read fntguide.

	James
		mapdn@csv.warwick.ac.uk
        Wolfgang 
                may@informatik.uni-goettingen.de 
  (in case the addresses become invalid in the future, 
   look us up in the Web)
