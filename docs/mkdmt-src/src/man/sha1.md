
## Calculate a SHA1 hash of an object

### Description

Calculate a SHA1 hash of an object. The main difference with
`digest(x, algo = "sha1")` is that `sha1()` will give the same hash on
32-bit and 64-bit systems. Note that the results depends on the setting
of `digits` and `zapsmall` when handling floating point numbers. The
current defaults keep `digits` and `zapsmall` as large as possible while
maintaining the same hash on 32 bit and 64 bit systems.

### Usage

``` R
sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
## S3 method for class 'numeric'
sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
## S3 method for class 'complex'
sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
## S3 method for class 'Date'
sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
## S3 method for class 'matrix'
sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
## S3 method for class 'data.frame'
sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
## S3 method for class 'array'
sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
## S3 method for class 'list'
sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
## S3 method for class 'pairlist'
sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
## S3 method for class 'POSIXlt'
sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
## S3 method for class 'POSIXct'
sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
## S3 method for class 'anova'
sha1(x, digits = 4, zapsmall = 7, ..., algo = "sha1")
## S3 method for class 'function'
sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")

## S3 method for class 'formula'
sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
## S3 method for class ''(''
sha1(...)

sha1_digest(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
## S3 method for class 'NULL'
sha1(...)
## S3 method for class 'name'
sha1(...)

sha1_attr_digest(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
## S3 method for class 'call'
sha1(...)
## S3 method for class 'character'
sha1(...)
## S3 method for class 'factor'
sha1(...)
## S3 method for class 'integer'
sha1(...)
## S3 method for class 'logical'
sha1(...)
## S3 method for class 'raw'
sha1(...)
```

### Arguments

|            |                                                                                                                                                                                              |
|------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `x`        | the object to calculate the SHA1                                                                                                                                                             |
| `digits`   | the approximate number of significant digits in base 10. Will be converted to a base 16 equivalent. Defaults to `digits = 14`, except for sha1.anova where `digits = 4`                      |
| `zapsmall` | the approximate negative magnitude of the smallest relevant digit. Will be converted to a base 2 equivalent. Values smaller than this number are equivalent to 0. Defaults to `zapsmall = 7` |
| `...`      | If it is the only defined argument, passed to another `sha1` method. If other arguments exist, see Details for usage.                                                                        |
| `algo`     | The hashing algoritm to be used by `digest`. Defaults to "sha1"                                                                                                                              |

### Details

`sha1_digest()` is a convenience function for objects where attributes
cannot be added to apply the `digest()` function to its arguments.
`sha1_attr_digest()` is a convenience function for objects where objects
can be added to generate the hash. If generating hashes for objects in
other packages, one of these two functions is recommended for use
(typically, `sha1_attr_digest()`).

Extra arguments:

environment: An optional extra argument for `sha1.function` and
`sha1.formula` should be TRUE, FALSE or missing. `sha1.function` and
`sha1.formula` will ignore the enviroment of the function only when
`environment = FALSE`.

### Note

`sha1` gained an `algo` argument since version 0.6.15. This allows
`sha1()` to use all hashing algoritms available in `digest()`. The
hashes created with `sha1(x)` from digest \>= 0.6.15 are identical to
`sha1(x)` from digest \<= 0.6.14. The only exceptions are hashes created
with `sha1(x, algo = "sha1")`, they will be different starting from
digest 0.6.15

Until version 0.6.22, `sha1` ignored the attributes of the object for
some classes. This was fixed in version 0.6.23. Use
`options(sha1PackageVersion = "0.6.22")` to get the old behaviour.

Version 0.6.24 and later ignore attributes named `srcref`.

### Author(s)

Thierry Onkelinx

