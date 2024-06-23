

## hash arbitrary string to integer

### Description

The `digest2int` function calculates integer hash of an arbitrary
string. This is useful for randomized experiments, feature hashing, etc.

### Usage

``` R
digest2int(x, seed = 0L)
```

### Arguments

|        |                                                                                                                          |
|--------|--------------------------------------------------------------------------------------------------------------------------|
| `x`    | An arbitrary character vector.                                                                                           |
| `seed` | an integer for algorithm initial state. Function will produce different hashes for same input and different seed values. |

### Value

The `digest2int` function returns integer vector of the same length as
input vector `x`.

### Author(s)

Dmitriy Selivanov <selivanov.dmitriy@gmail.com> for the <span
class="rlang">**R**</span> interface; Bob Jenkins for original
implementation <http://www.burtleburtle.net/bob/hash/doobs.html>

### References

Jenkins's `one_at_a_time` hash:
<https://en.wikipedia.org/wiki/Jenkins_hash_function#one_at_a_time>.

### See Also

`digest`

### Examples

``` R
current <- digest2int("The quick brown fox jumps over the lazy dog", 0L)
target <- 1369346549L
stopifnot(identical(target, current))
```


