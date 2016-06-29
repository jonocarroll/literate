# literate

## Motivation:

This came as a flurry of inspiration while watching Donald Knuth's presentation on literate programming at useR 2016. He mentioned that while R has nice ways of incorporating comments within code for a separate document (e.g. knitr), it didn't quite follow his paradigm of creating "simple modules linked in simple ways". We also have roxygen for generating documentation, but this still occurs outside of the function in the function header.

## Proof of concept:

This proof-of-concept takes things one step further; generate the documentation *inside* the code itself, and produce some (hopefully) fully self-documented functions that can be walked through via hyperlinks. This requires minimal additional markup within the function body, for now denoted by `#%` blocks. These can span multiple lines, but must follow this structure:

```
#%{tagname}{tagbody}{nexttag}
```

where:
 + `tagname` denotes the tag/heading for this block (this will appear as a link and a heading).
 + `tagbody` describes the part of the code that follows. Not what, but why. This can include links to other tagged sections using `%%othertag ` (must be followed by a space, not the end of the delimited block).
 + `nexttag` denotes the next piece of code in sequence (this will appear as a link to that block).

## Installation:

For now, this is not quite a package, but it's coming along. Purely proof of concept on the one file for now.

## Usage

After evaluating the [`process_literate()`](https://github.com/jonocarroll/literate/blob/master/literate.R) function, and a literate-programmed function (e.g. taking Donald Knuth's example, [`literate.ks.test()`](https://github.com/jonocarroll/literate/blob/master/literate.ks.test.R)), the literate view can be generated with

```
process_literate("literate.ks.test")
```

where the only argument is the quoted name of the literate function to be processed. `process_literate` will extract the literate-specific blocks, generate links, save as a temporary .html file (via `tempfile`) and load the processed HTML into a browser via `browseURL`.

[The results for this example are shown here](http://jonocarroll.github.io/literate/).
