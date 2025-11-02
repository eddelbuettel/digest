

# hash arbitrary string to integer

[**Source code**](https://github.com/eddelbuettel/digest/tree/master/R/#L)

## Description

The <code>digest2int</code> function calculates integer hash of an
arbitrary string. This is useful for randomized experiments, feature
hashing, etc.

## Usage

<pre><code class='language-R'>digest2int(x, seed = 0L)
</code></pre>

## Arguments

<table role="presentation">
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="x">x</code>
</td>
<td>
An arbitrary character vector.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="seed">seed</code>
</td>
<td>
an integer for algorithm initial state. Function will produce different
hashes for same input and different seed values.
</td>
</tr>
</table>

## Value

The <code>digest2int</code> function returns integer vector of the same
length as input vector <code>x</code>.

## Author(s)

Dmitriy Selivanov
<a href="mailto:selivanov.dmitriy@gmail.com">selivanov.dmitriy@gmail.com</a>
for the <span class="rlang"><b>R</b></span> interface; Bob Jenkins for
original implementation
<a href="http://www.burtleburtle.net/bob/hash/doobs.html">http://www.burtleburtle.net/bob/hash/doobs.html</a>

## References

Jenkins’s <code>one_at_a_time</code> hash:
<a href="https://en.wikipedia.org/wiki/Jenkins_hash_function#one_at_a_time">https://en.wikipedia.org/wiki/Jenkins_hash_function#one_at_a_time</a>.

## See Also

<code>digest</code>

## Examples

``` r
library("digest")


current <- digest2int("The quick brown fox jumps over the lazy dog", 0L)
target <- 1369346549L
stopifnot(identical(target, current))
```
