# LISPish
Samples in LISP-ish languages

# Music Books

These scripts were first passes at making PNG illustrations for
beginners' music books. I discarded them in favor of writing SVG files
in a different language because dozens of full-page images blew up the
book size whereas SVG sketches were comparatively tiny. They worked in
The GIMP 1.6 or so but don't work properly in 2.10.

- piano-keys.scm
- scales01.scm

scales01 generated a sketch of a piano keyboard and showed finger
positions to play multi-octave scales.

piano-keys generated a treble or bass staff and put a note on it, for
use as a flash card.


# Image Manipulators

These scripts manipulated photographs used in a martial arts book,
using GIMP 1.6. Each handled bulk processing of a sheaf of files, work
which I could have done through GIMP menu selections but would just as
soon not.

- rotatepics.scm
- scalemookjongpic.scm


# Text File Processing

Tweak an HTML file for upload to a few free story sites. Each has
quirks about the HTML elements and character entities it will accept,
so I write my stories in a baseline style and then tweak as needed by
each site. This runs on EMACS and ELISP, going back to versions at
least ten years old through current.

- prep-upload.el
