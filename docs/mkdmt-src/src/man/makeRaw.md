

## Create a raw object

### Description

A helper function used to create `raw` methods.

### Usage

``` R
makeRaw(object)

## S3 method for class 'raw'
makeRaw(object)

## S3 method for class 'character'
makeRaw(object)

## S3 method for class 'digest'
makeRaw(object)

## S3 method for class 'raw'
makeRaw(object)
```

### Arguments

|          |                                           |
|----------|-------------------------------------------|
| `object` | The object to convert into a `raw` vector |

### Value

A `raw` vector is returned.

### Author(s)

Dirk Eddelbuettel

### Examples

``` R
makeRaw("1234567890ABCDE")
```


