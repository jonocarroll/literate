# literate

## Motivation:

This came as a flurry of inspiration while watching Donald Knuth's presentation on literate programming at useR 2016. He mentioned that while R has nice ways of incorporating comments within code (and vice versa) for a separate document (e.g. knitr), it didn't quite follow his paradigm of creating "simple modules linked in simple ways" for self-sufficient, self-documented, self-contained code. We also have roxygen for generating documentation, but this still occurs outside of the function in the function header.

The idea struck me: why can't we have documentation *right inside the code* and be able to browse/wander/follow through that with hyperlinks?

## Proof of concept:

This proof-of-concept takes things one step further; generate some deeper documentation *inside* the code itself, and produce some (hopefully) fully self-documented functions that can be walked through via hyperlinks. This is of interest to someone who wants to know **how/why the code works**, not just **how to use it**. Achieving this requires minimal additional markup within the function body, for now denoted by `#%` blocks. These can span multiple lines, but must follow this structure:

```
#%{tagname}{tagbody}{nexttag}
```

where:
 + `tagname` denotes the tag/heading for this block (this will appear as a link and a heading).
 + `tagbody` describes the part of the code that follows. Not what, but why. This can include links to other tagged sections using `%%othertag ` (must be followed by a space, not the end of the delimited block).
 + `nexttag` denotes the next piece of code in sequence (this will appear as a link to that block).

None of these may contain either `{` or `}` as this breaks the above structure (can't deal with escaping yet). Additionally though, `%%othertag` can appear anywhere in the code comments (e.g. also in inline comments) to refer to a literate code block. This could be very helpful for explaining reasoning behind a coding choice. For example

```
y <- 2 * x # this choice motivated by %%scale
```

These `%%othertag`s will be converted to links in the processed output, resulting in

```
y <- 2 * x # this choice motivated by <a href="#scale">scale</a>
```

## Example:

The [`literate.ks.test()`](https://github.com/jonocarroll/literate/blob/master/literate.ks.test.R) function uses a few trivial blocks to show what I mean. In reality, these would contain the 'why' of the block of code, linking to related parts of the code. There probably shouldn't be too many of these blocks in your function; if there are, maybe it's too complex and could be broken down into several smaller functions?

```
  #%{checking}{perform input checking. 
  #% This comment is very long
  #% and spans multiple lines. Processing needs 
  #% to be able to handle this.}{basecase}
  alternative <- match.arg(alternative)
```

In the above `checking` block, the description (trivial for now) would describe why certain cases are being tested, or why certain conditions are likely to be encountered. This might even link to a `%%conditionalreturn` block. The `basecase` tag refers to the next piece of code to be evaluated in sequence.

## Installation:

For now, this is not quite a package, but it's coming along. Purely proof of concept on the one file for now.

## Usage:

After evaluating the [`process_literate()`](https://github.com/jonocarroll/literate/blob/master/literate.R) function, and a literate-programmed function (e.g. taking Donald Knuth's example, [`literate.ks.test()`](https://github.com/jonocarroll/literate/blob/master/literate.ks.test.R)), the literate view can be generated with

```
process_literate("literate.ks.test")
```

where the only argument is the quoted name of the literate function to be processed. `process_literate` will extract the literate-specific blocks, generate links, save as a temporary .html file (via `tempfile`) and load the processed HTML into a browser via `browseURL`.

[The results for this example are shown here](http://jonocarroll.github.io/literate/).

Since the literate blocks are all commented, there should be no impact on non-literate-programming functions, in which case it should just open a browser to the original code. At the moment that's broken (edge case).

## Ideas for going forward:

 + Fix the edge case where there is no literate markup, in which case this currently fails. (easy)
 + add a table of contents of all literate links. (easy)
 + better processing of the tags with more sophisticated regex. (moderate)
 + CSS styling on the links to distinguish them from the code, and add top/bottom jumps. (moderate)
 + Use a monospace font specifically for output. (easy)
 + htmlify the remainder of the function body. (easy)
 + find out how to hook into the internal RStudio browser. (hard)
 + build a better example case. (easy)
 + `%%` is not a particularly protected choice, and perhaps something else would be better. (moderate)
 + this list will eventually be in [Issues](https://github.com/jonocarroll/literate/issues). (easy)
 + include links to GitHub issues right in the comments. (easy)
