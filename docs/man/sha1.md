

# Calculate a SHA1 hash of an object

[**Source code**](https://github.com/eddelbuettel/digest/tree/master/R/#L)

## Description

Calculate a SHA1 hash of an object. The main difference with
<code>digest(x, algo = “sha1”)</code> is that <code>sha1()</code> will
give the same hash on 32-bit and 64-bit systems. Note that the results
depends on the setting of <code>digits</code> and <code>zapsmall</code>
when handling floating point numbers. The current defaults keep
<code>digits</code> and <code>zapsmall</code> as large as possible while
maintaining the same hash on 32 bit and 64 bit systems.

## Usage

<pre><code class='language-R'>sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
# S3 method for class 'numeric'
sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
# S3 method for class 'complex'
sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
# S3 method for class 'Date'
sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
# S3 method for class 'matrix'
sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
# S3 method for class 'data.frame'
sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
# S3 method for class 'array'
sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
# S3 method for class 'list'
sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
# S3 method for class 'pairlist'
sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
# S3 method for class 'POSIXlt'
sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
# S3 method for class 'POSIXct'
sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
# S3 method for class 'anova'
sha1(x, digits = 4, zapsmall = 7, ..., algo = "sha1")
# S3 method for class 'function'
sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")

# S3 method for class 'formula'
sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
# S3 method for class ''(''
sha1(...)

sha1_digest(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
# S3 method for class 'NULL'
sha1(...)
# S3 method for class 'name'
sha1(...)

sha1_attr_digest(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
# S3 method for class 'call'
sha1(...)
# S3 method for class 'character'
sha1(...)
# S3 method for class 'factor'
sha1(...)
# S3 method for class 'integer'
sha1(...)
# S3 method for class 'logical'
sha1(...)
# S3 method for class 'raw'
sha1(...)
# S3 method for class 'environment'
sha1(...)
# S3 method for class ''&lt;-''
sha1(...)
</code></pre>

## Arguments

<table role="presentation">
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="x">x</code>
</td>
<td>
the object to calculate the SHA1
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="digits">digits</code>
</td>
<td>
the approximate number of significant digits in base 10. Will be
converted to a base 16 equivalent. Defaults to <code>digits = 14</code>,
except for sha1.anova where <code>digits = 4</code>
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="zapsmall">zapsmall</code>
</td>
<td>
the approximate negative magnitude of the smallest relevant digit. Will
be converted to a base 2 equivalent. Values smaller than this number are
equivalent to 0. Defaults to <code>zapsmall = 7</code>
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="...">…</code>
</td>
<td>
If it is the only defined argument, passed to another <code>sha1</code>
method. If other arguments exist, see Details for usage.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="algo">algo</code>
</td>
<td>
The hashing algorithm to be used by <code>digest</code>. Defaults to
"sha1"
</td>
</tr>
</table>

## Details

<code>sha1_digest()</code> is a convenience function for objects where
attributes cannot be added to apply the <code>digest()</code> function
to its arguments. <code>sha1_attr_digest()</code> is a convenience
function for objects where objects can be added to generate the hash. If
generating hashes for objects in other packages, one of these two
functions is recommended for use (typically,
<code>sha1_attr_digest()</code>).

Extra arguments:

environment: An optional extra argument for <code>sha1.function</code>
and <code>sha1.formula</code> should be TRUE, FALSE or missing.
<code>sha1.function</code> and <code>sha1.formula</code> will ignore the
environment of the function only when <code>environment = FALSE</code>.

## Note

<code>sha1</code> gained an <code>algo</code> argument since version
0.6.15. This allows <code>sha1()</code> to use all hashing algorithms
available in <code>digest()</code>. The hashes created with
<code>sha1(x)</code> from digest \>= 0.6.15 are identical to
<code>sha1(x)</code> from digest \<= 0.6.14. The only exceptions are
hashes created with <code>sha1(x, algo = “sha1”)</code>, they will be
different starting from digest 0.6.15

Until version 0.6.22, <code>sha1</code> ignored the attributes of the
object for some classes. This was fixed in version 0.6.23. Use
<code>options(sha1PackageVersion = “0.6.22”)</code> to get the old
behaviour.

Version 0.6.24 and later ignore attributes named <code>srcref</code>.

Version 0.6.38 and later use <code>digest()</code> as a fallback for
undefined methods. Note that this breaks the guarantee for identical
hashes between 32-bit and 64-bit system. We recommend to write a custom
method for such class. The basic idea is the convert the class in a list
of classes that <code>sha1</code> can handle. The project
<a href="https://github.com/inbo/n2kanalysis/">https://github.com/inbo/n2kanalysis/</a>
demonstrates how to create custom <code>sha1</code> dispatchers for
other S3 classes, see file
<a href="https://github.com/inbo/n2kanalysis/blob/main/R/sha1.R">https://github.com/inbo/n2kanalysis/blob/main/R/sha1.R</a>.

## Author(s)

Thierry Onkelinx
