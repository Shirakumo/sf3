# About SF3
SF3 is a Simple File Format Family. Please see the [specification homepage](https://shirakumo.github.io/sf3).

## Files in this repository
- `LICENSE`  
  The license of the specification and related files (zlib)
- `specification.mess`  
  Original source text for the specification in [Markless](https://shirakumo.org/docs/markless) format.
- `samples/`  
  Sample files to test SF3 implementations against.
- `magic`  
  libmagic/UNIX-file magic parser for SF3 files.
- `card.png`, `index.html`, `template.ctml`, `style.css`, `style.lass`, `style.tex`  
  Used for generating website and the HTML and PDF versions of the specification.

## Related projects
- [sf3.ksy](https://shirakumo.org/projects/sf3.ksy)  
  Implementation of the SF3 file formats in Kaitai struct, from which libraries in many languages can also be generated.
- [libsf3](https://shirakumo.org/docs/libsf3)  
  Implementation of the SF3 file formats in C99 as a header-only library.
- [cl-sf3](https;//shirakumo.org/docs/cl-sf3)  
  Implementation of the SF3 file formats in Common Lisp.
