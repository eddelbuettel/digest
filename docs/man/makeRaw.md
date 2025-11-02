

# Create a raw object

[**Source code**](https://github.com/eddelbuettel/digest/tree/master/R/#L)

## Description

A helper function used to create <code>raw</code> methods.

## Usage

<pre><code class='language-R'>makeRaw(object)

# S3 method for class 'raw'
makeRaw(object)

# S3 method for class 'character'
makeRaw(object)

# S3 method for class 'digest'
makeRaw(object)

# S3 method for class 'raw'
makeRaw(object)
</code></pre>

## Arguments

<table role="presentation">
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="object">object</code>
</td>
<td>
The object to convert into a <code>raw</code> vector
</td>
</tr>
</table>

## Value

A <code>raw</code> vector is returned.

## Author(s)

Dirk Eddelbuettel

## Examples

``` r
library("digest")

makeRaw("1234567890ABCDE")
```

     [1] 31 32 33 34 35 36 37 38 39 30 41 42 43 44 45
