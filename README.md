# Pandoc Latex Environment Filter

Filter for swapping `div`s with Latex environments. This filter only works for Latex output.

The mapping of `div` class to Latex environment is configured in the document meta data.

This is a Lua implementation of a [similar filter implemented in Python](https://github.com/chdemko/pandoc-latex-environment).

## Script

```
pandoc -s -f markdown -t latex --lua-filter pandoc-latex-environment-filter.lua demo.md -o demo.tex
pandoc -s -f markdown -t pdf --lua-filter pandoc-latex-environment-filter.lua demo.md -o demo.pdf
```
