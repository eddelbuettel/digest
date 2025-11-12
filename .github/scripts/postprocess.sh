#!/bin/sh

test -d docs || exit 0

#test -f inst/NEWS.Rd || exit 0

## the one vignette has a yaml header delineated by the standard '---'
## which becomes '<hr />' in the html -- so now we print first everything up
## to the first occurence, and then everything including the second occurence
## to the end, and then filter out that one occurrence
file=$(mktemp)
awk 'BEGIN{flag=0} /<hr \/>/{flag++}; flag<1' docs/vignettes/sha1/index.html > ${file}
awk 'BEGIN{flag=0} /<hr \/>/{flag++}; flag>1' docs/vignettes/sha1/index.html >> ${file}
awk '!/<hr \/>/' ${file} > docs/vignettes/sha1/index.html
