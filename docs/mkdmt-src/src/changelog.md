###  2024 

2024-12-31  Bill Denney  <wdenney@humanpredictions.com> 
 
        * DESCRiPTION (Description): Correct typos 
        * README.md: Idem 
        * man/digest.Rd: Idem 
        * sha1.Rd: Idem 
        * vignette/sha1.md: Idem 
 
2024-12-31  Dirk Eddelbuettel  <edd@debian.org> 
 
        * .github/workflows/ci.yaml: Simplify to r-ci with included bootstrap 
 
2024-09-19  Carl A. B. Pearson  <carl.ab.pearson@gmail.com> 
 
        * src/digest.h: introduced, to enable additional registrations in init.c 
        * src/digest.c: add digest.h, prune other imports, eliminate version check 
        * src/init.c: introduce digest.h in anticipation of new registrations 
 
2024-08-28  Carl A. B. Pearson  <carl.ab.pearson@gmail.com> 
 
        * R/digest.R (digest): parse errormode only if in error conditions 
        * R/vdigest.R (getVDigest): parse errormode only if in error conditions 
 
2024-08-24  Dirk Eddelbuettel  <edd@debian.org> 
 
        * src/digest.c (digest): Remove unused variables 
 
2024-08-24  Carl A. B. Pearson  <carl.ab.pearson@gmail.com> 
 
        * src/digest.c (digest): Address signedness warnings 
 
2024-08-22  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Authors@R): Add two more ORCID IDs 
 
2024-08-22  Carl A. B. Pearson  <carl.ab.pearson@gmail.com> 
 
        * src/digest.c: switch output handling from macro to function; 
        consolidate stringification loop approaches 
 
2024-08-21  Dirk Eddelbuettel  <edd@debian.org> 
 
        * man/digest.Rd: Update \code{raw} entry 
 
        * DESCRIPTION (Authors@R): Add two more ORCID IDs 
 
2024-08-20  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Roll micro version and date 
 
        * DESCRIPTION (Authors@R): Add five ORCID IDs 
 
2024-08-19  Carl A. B. Pearson  <carl.ab.pearson@gmail.com> 
 
        * src/digest.c: enable all hashing algorithms to return raw output. 
        * inst/tinytest/test_raw.R: test raw vs not consistency for all algos. 
 
2024-08-19  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Release 0.6.37 
 
2024-08-18  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Authors@R): Added 
 
2024-08-15  Kevin Ushey  <kevinushey@gmail.com> 
 
        * src/raes.c: Calloc -> R_Calloc; Free -> R_Free 
 
2024-07-15  Dirk Eddelbuettel  <edd@debian.org> 
 
        * README.md: Switch some URLs from http to https 
 
2024-06-23  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Release 0.6.36 
 
        * src/digest.c (is_little_endian): Define alternate helper too 
        * man/digest.Rd: Compare to spookyhash ref only on little endian 
 
2024-06-22  Dirk Eddelbuettel  <edd@debian.org> 
 
        * src/digest.c (is_big_endian): Use endian-ness definition from 
        Rconfig.h and define one-line helper 
 
        * inst/tinytest/test_digest.R: Skip spookyhash test on big endian 
 
2024-06-21  Sergey Fedorov  <vital.had@gmail.com> 
 
        * src/blake3.c: Upstream patch for big endian systems 
        * src/blake3_impl.h: Idem 
        * src/blake3_portable.c: Idem 
 
2024-06-15  Dirk Eddelbuettel  <edd@debian.org> 
 
        * .github/workflows/ci.yaml (jobs): Update to r-ci-setup action 
 
2024-05-16  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Roll micro version and date 
 
        * README.md: Use tinyverse.netlify.app for dependency badge 
 
        * src/spooky_serialize.cpp: Several small updates to please clang++ 
        * src/SpookyV2.cpp: Idem 
 
        * .github/workflows/ci.yaml: Show logs in case of failure 
 
2024-03-12  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Roll micro version and date 
 
        * src/spooky_serialize.cpp: Use R_NO_REMAP, add three Rf_ prefixes 
 
2024-03-10  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Release 0.6.35 
 
        * src/xxhash.h: Update to current release 0.8.2 
        * src/xxhash.c: Idem 
        * src/digest.c: Support added xxhash algorithms xxh3_64 and xxh3_128 
        * R/digest.R: Idem 
        * R/vdigest.R: Support xxh3_64 and xxh3_128 in vectorized mode 
        * inst/tinytest/test_digest.R: Add tests for xxh3_64 and xxh3_128 
        * man/digest.Rd: Documentation 
        * man/vdigest.Rd: Idem 
        * DESCRIPTION (Description): Mention xxh3_64 and xxh3_128 
        * README.md: Idem 
 
        * src/digest.c (digest): Consistently print uint64_t via PRIx 
 
2024-01-11  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Release 0.6.34 
 
2024-01-05  Dirk Eddelbuettel  <edd@debian.org> 
 
        * .github/workflows/ci.yaml (jobs): Update to actions/checkout@v4 
 
2024-01-04  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Roll micro version and date 
 
        * src/digest.c (open_with_widechar_on_windows): Correct format 
        specification in error() call on Windows 
 
###  2023 

2023-08-23  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Roll micro version and date 
 
        * DESCRIPTION: Add Michael contributors 
        * README.md: Idem 
 
2023-08-03  Michael Chirico  <chiricom@google.com> 
 
        * tests/tinytest.R: Define `expect_length()` if needed (it is only 
        available from tinytest 1.4.1 released February 2023) 
        * src/digest.c: `#include <stdint.h>` for `uint32_t` 
 
2023-06-28  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Release 0.6.33 
 
        * src/crc32c/crc32c_config.h: Minor comment edit 
 
2023-06-27  Sergey Fedorov  <vital.had@gmail.com> 
 
        * src/crc32c/crc32c_config.h: Use endian macros to set endianness 
 
2023-06-27  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Roll micro version and date 
 
        * src/crc32c/crc32c_config.h: Undefine HAVE_BUILTIN_PREFETCH and 
        HAVE_MM_PREFETCH for maximum portability and builds on M1/M2/Arm64 
 
2023-06-26  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Release 0.6.32 
 
        * README.md: Add r-universe badge 
        * README.md: Add crc32c, and link to docs site, to Overview 
 
2023-06-25  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Roll micro version and date 
 
        * DESCRIPTION (Author): Add Dean Attali 
 
2023-06-25  Dean Attali  <daattali@gmail.com> 
 
        * R/AES.R: Add `padding` parameter to `AES()` to allow CBC mode to use 
        PKCS#7 padding 
        * inst/tinytest/test_aes.R: Add tests for new `padding` parameter 
        * man/AES.Rd: Document the `raw` argument of `AES()$decrypt()` and the 
        new `padding` parameter 
 
2023-04-30  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Roll micro version and date 
 
        * R/vdigest.R: Enable vectorised operation for blake3 and crc32v 
        * man/vdigest.Rd: Update documentation 
 
2023-04-29  Dirk Eddelbuettel  <edd@debian.org> 
 
        * src/digest.c (digest): Support crc33c 
        * man/digest.Rd: Document crc32c option, add two examples 
 
        * src/crc32c.h: Adding new CRC32C implementation 
        * src/crc32c.cpp: Idem 
        * src/crc32c_portable.cpp: Idem; also added codecov nocov 
        * src/crc32c/*: Idem 
 
        * src/Makevars: Added for PKG_CPPFLAGS 
        * src/Makevars.win: Idem 
 
        * R/init.R: Added some codecov nocov 
 
        * .codecov.yml (coverage): Added coverage diff settings 
 
2023-02-05  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Roll minor version 
 
        * src/Makevars: No longer require CXX_STD 
 
###  2022 

2022-12-10  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Release 0.6.31 
 
        * src/digest.c: Replace sprintf with snprintf 
 
        * .editorconfig: Added 
        * .Rbuildignore: Updated 
 
2022-11-05  Dirk Eddelbuettel  <edd@debian.org> 
 
        * .github/workflows/ci.yaml (jobs): Update to actions/checkout@v3 
 
2022-10-17  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Release 0.6.30 
 
        * src/crc32.c: Modernize three function signatures to current C 
        standards to appease clang-15 now used by CRAN 
 
        * src/sha2.c (SHA512_End): Align two function signatures to their 
        prototypes to appease gcc-12 
 
2022-10-02  Dirk Eddelbuettel  <edd@debian.org> 
 
        * docs/mkdmt-src/src/index.md: Several small updates with upgrade to 
        Material for MkDocs 8.5.5 
 
###  2021 

2021-11-30  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Release 0.6.29 
 
        * src/digest.c (digest): Accomodate Windows UCRT build 
        * man/AES.Rd: Remove one URL that upsets the URL checker 
        * README.md: Update one URL that upsets the URL checker 
 
2021-11-20  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Roll minor version 
 
        * vignettes/sha1.md: Renamed from .Rmd, corrected code block syntax 
 
2021-11-19  Dirk Eddelbuettel  <edd@debian.org> 
 
         * DESCRIPTION (VignetteBuilder): Converted to simplermarkdown engine 
        * vignettes/sha1.Rmd: Idem 
        * vignettes/water.css: Added 
 
2021-11-05  Dirk Eddelbuettel  <edd@debian.org> 
 
         * README.md: Remove Travis badge 
        * .travis.yml: Remove Travis YAML config 
 
2021-09-23  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Release 0.6.28 
 
2021-09-22  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Roll minor version 
 
        * vignettes/sha1.Rmd (date): Remove knitr date calculation in YAML 
        header which GitHub does not like and mistakes for Jekyll code 
        * docs/mkdmt-src/src/vignette.md (date): Idem 
 
        * README.md: Add total download badge, label other as monthly 
 
2021-09-22  András Svraka  <svraka.andras@gmail.com> 
 
        * R/vdigest.R (non_streaming_digest): Ensure UTF-8 encoded file paths 
        on Windows 
        * inst/tinytest/test_encoding.R: Expand test coverage for path name 
        encodings on Windows 
 
2021-03-28  Dirk Eddelbuettel  <edd@debian.org> 
 
        * docs/mkdmt-src/: Moved mkdocs-material input 
 
2021-03-26  Dirk Eddelbuettel  <edd@debian.org> 
 
        * README.md: Add 'last commit' badge 
 
2021-03-23  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (URL): Add link to repo 
 
2021-03-22  Dirk Eddelbuettel  <edd@debian.org> 
 
        * docs-src/mkdocs.yml (theme): Add (draft, incomplete) vignette 
        * docs-src/src/vignette.md (title): Idem 
 
2021-03-22  Floris Vanderhaeghe  <floris.vanderhaeghe@inbo.be> 
 
        * man/digest.Rd: Reworded to also highlight file mode 
 
2021-01-16  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Roll minor version 
 
        * src/SpookyV2.cpp: Disallow unaligned reads which have been seen to 
        trigger SAN issues as reported by Winston in #167 
 
###  2020 

2020-12-23  Dirk Eddelbuettel  <edd@debian.org> 
 
        * .github/workflows/ci.yaml: Add CI runner using r-ci 
        * README.md: Add new CI badge 
 
2020-10-20  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Release 0.6.27 
 
2020-10-19  Dirk Eddelbuettel  <edd@debian.org> 
 
        * src/blake3_dispatch.c: Comment-out include of intrinsics to also 
        comment-out erroring on insufficient architectures such as Solaris 
 
2020-10-17  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Release 0.6.26 
 
        * docs/: Added package website 
        * docs-src/: Added package website inputs 
 
        * .travis.yml (dist): Change to focal 
 
2020-10-15  Dirk Eddelbuettel  <edd@debian.org> 
 
        * README.md: Update URLs 
        * man/digest.Rd: Ditto 
        * man/hmac.Rd: Ditto 
 
2020-10-14  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Roll minor version 
 
        * inst/tinytest/test_blake3.R: Skip file-based blake3 tests on Windows 
 
        * vignettes/sha1.Rmd: Switch to minidown and 'framework: water' 
        * DESCRIPTION (Suggests): Add minidown 
 
2020-10-07  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Roll minor version 
 
2020-10-06  Winston Chang  <winston@stdout.org> 
 
        * R/digest.R: Speedup via explicit alternative values for 
        match.arg() and a direct call to serialize() 
        * R/vdigest.R: Idem 
        * R/init.R: Idem (for serialize()) 
        * inst/tinytest/test_digest.R: New test ensuring all variants hit 
 
2020-09-21  Dirk Eddelbuettel  <edd@debian.org> 
 
        * .travis.yml: Updated to 'bionic', R 4.0, and BSPM 
 
2020-08-03  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Depends): Roll Depends: on to R (>= 3.3.0) due to use 
        of startsWith(), with thanks to Florian Pein 
 
2020-05-20  Dirk Eddelbuettel  <edd@debian.org> 
 
        * .travis.yml: Switch to bionic and R 4.0.0 
 
2020-05-19  Dirk Schumacher  <mail@dirk-schumacher.net> 
 
        * src/digest.c: Support file operation 
        * inst/tinytest/test_blake3.R: Update test 
 
2020-05-19  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version): Roll minor version and date 
 
2020-05-19  Dirk Schumacher  <mail@dirk-schumacher.net> 
 
        * src/blake3.c: Add blake3 implementation 
        * src/blake3.h: Idem 
        * src/blake3_dispatch.c: Idem 
        * src/blake3_impl.h: Idem 
        * src/blake3_portable.c: Idem 
        * src/digest.c: Support blake3 call 
        * R/digest.R: Idem 
        * inst/tinytest/test_blake3.R: Add tests 
        * man/digest.Rd: Add documentation 
 
2020-03-05  Harris McGehee  <mcgehee.harris@gmail.com> 
 
        * man/sha1.Rd: Correct typo 
 
2020-02-26  Dirk Eddelbuettel  <edd@debian.org> 
 
        * README.md: Add Debian badge 
 
2020-02-22  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Release 0.6.25 
 
2020-02-15  Kendon Bell  <bellk@landcareresearch.co.nz> 
 
        * R/digest.R: Complete call to spookyhash 
 
2020-02-12  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Release 0.6.24 
 
###  2019 

2019-12-12  Thierry Onkelinx <thierry.onkelinx@inbo.be> 
 
        * DESCRIPTION (Version, Date): Roll minor version 
        * R/sha1.R: ignore the "srcref" attribute if set 
        * inst/tinytest/test_new_matrix_behaviour.R: update unit test 
        * inst/tinytest/test_sha1.R: update unit test 
        * man/sha1.Rd: update documentation 
 
2019-12-09  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Roll minor version 
 
        * src/init.c: Do not register a .Call method for PMurHash 
 
2019-12-05  Will Landau  <will.landau@gmail.com> 
 
        * R/init.R (.onLoad): Cache nosharing state in base::serialize 
        (.hasNoSharing): Return cached value 
        * R/digest.R (digest): Use cached value accessor 
        * R/vdigest.R (non_streaming_digest): Use cached value accessor 
 
2019-12-04  Dirk Eddelbuettel  <edd@debian.org> 
 
        * R/init.R (.onLoad): Cache isWindows state 
        (.isWindows): Return cached value 
        * R/digest.R (digest): Use cached value accessor 
 
2019-11-23  Dirk Eddelbuettel  <edd@debian.org> 
 
        * inst/tinytest/test_new_matrix_behaviour.R: Split off tests affected 
        by new matrix/array behavior in R-devel (i.e. future R 4.0.0) 
 
2019-11-22  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Release 0.6.23 
 
        * inst/tinytest/test_sha1.R: Uncomment several tests which failed 
        under r-devel on Linux at CRAN 
 
2019-11-13  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Roll minor version 
 
2019-11-11  Bill Denney  <wdenney@humanpredictions.com> 
 
        * R/sha1.R: Increase efficiency of num2hex() 
 
2019-11-07  Bill Denney  <wdenney@humanpredictions.com> 
 
        * NAMESPACE: add sha1_digest() and sha1_attr_digest() functions 
        * R/sha1.R: Idem 
        * man/sha1.Rd: Idem 
        * Also, renamed sha1.rd to sha1.Rd 
 
2019-11-03  Bill Denney  <wdenney@predictions.com> 
 
        * R/sha1.R: Add support for the "(" class used in some formulae 
        * NAMESPACE: Idem 
        * man/sha1.Rd: Idem; also corrected typo for old version behavior 
        * inst.tinytest/test_sha1.R: Add tests for the "(" class 
 
2019-10-27  Thierry Onkelinx  <thierry.onkelinx@inbo.be> 
 
        * DESCRIPTION (Version, Date): Roll minor version 
 
        * R/sha1.R: consider object attributes when calculating the hash 
        * man/sha1.Rd: update documentation 
        * R/init.R: add "sha1PackageVersion" option 
        * inst.tinytest/test_sha1.R: add units tests for new functionality 
 
        * NAMESPACE:  import utils::packageVersion 
 
2019-10-26  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Roll minor version 
 
        * R/digest.R (digest): Call enc2utf8() only on Windows; add internal 
        one-liner function to test for being on Windows 
 
2019-10-23  Dirk Eddelbuettel  <edd@debian.org> 
 
        * inst/tinytest/test_encoding.R: Skip test unless on Windows 
 
2019-10-21  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Release 0.6.22 
 
2019-10-20  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Roll minor version 
 
        * inst/tinytest/test_misc.R: File split off test_digest.R 
 
2019-10-19  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION: Add Ion and Bill to Authors 
        * README.md: Idem 
 
2019-10-13  Jim Hester <james.f.hester@gmail.com> 
 
        * src/digest.c: Add support for UTF-8 file paths on Windows 
        * R/digest.R: Idem 
        * inst/tinytest/test_encoding.R: Add tests for UTF-8 file paths. 
 
2019-10-13  Bill Denney <wdenney@humanpredictions.com> 
 
        * R/sha1.R: Add sha1.formula() 
        * NAMESPACE: Idem 
        * man/sha1.rd: Idem 
        * inst/tinytest/test_sha1.R: Add tests for sha1.formula() 
 
2019-10-12  Bill Denney <wdenney@humanpredictions.com> 
 
        * R/sha1.R: Fix issue with num2hex() and input of Inf 
        * inst/tinytest/test_sha1.R: Add Inf to the tests 
 
2019-10-05  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Roll minor version 
 
        * man/digest.Rd: Change three URL references to https 
        * man/hmac.Rd: Ditto 
 
        * R/utils.R: Move back functions used by digest() + makeVDigest() 
 
        * R/AES.R: Added copyright header 
        * R/digest.R: Idem 
        * R/hmac.R: Idem 
        * R/sha1.R: Idem 
        * R/vdigest.R: Idem 
 
2019-10-02  Ion Suruceanu  <ion.suruceanu@gapsquare.com> 
 
        * R/AES.R: Add support for CFB cipher mode 
        * man/AES.Rd: Add documentation 
        * inst/tinytest/test_aes.R: Add tests 
 
2019-09-20  Matthew de Queljoe <matthew.dequeljoe@gmail.com> 
 
        * R/digest.R: refactor digest function 
        * R/vdigest.R: remove helper functions from file 
        * R/utils.R: new file to hold helper functions 
 
2019-09-19  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Release 0.6.21 
 
2019-09-18  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Roll minor version 
 
        * DESCRIPTION (Author): Add Matthew 
        * README.md (Author): Ditto 
 
        * demo/vectorised.R: Add demo (based on Matthew's PR) 
 
        * R/vdigest.R: Added a handful of #nocov tags 
        * man/vdigest.Rd: Break up two long lines 
 
2019-09-17  Matthew de Queljoe <matthew.dequeljoe@gmail.com> 
 
        * src/digest.c: Add vectorised digest function 
        * R/vdigest.R: Add vectorised digest function factory 
        * man/vdigest.Rd: Add documentation 
        * NAMESPACE: Export new function getVDigest 
        * inst/tinytest/test_digest.R: Add tests 
 
2019-07-04  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Release 0.6.20 
 
2019-06-29  Dirk Eddelbuettel  <edd@debian.org> 
 
        * README.md: Add installation and continues testing sections 
 
        * .travis.yml (install): Use r-cran-tinytest from PPA 
 
2019-06-23  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Roll minor version 
 
        * inst/tinytest/test_num2hex.R: Quieter with sapply 
 
        * test/tinytest/test_aes.R: renamed from testAES.R 
        * test/tinytest/test_crc32.R: renamed from testCRC32.R 
        * test/tinytest/test_digest.R: renamed from testDigest.R 
        * test/tinytest/test_digest2int.R: from testDigest2Int.R 
        * test/tinytest/test_hmac.R: renamed from testHMAC.R 
        * test/tinytest/test_num2hex.R: renamed from testNum2Hex.R 
        * test/tinytest/test_raw.R: renamed from testRaw.R 
        * test/tinytest/test_sha1.R: renamed from testSHA1.R 
 
2019-06-10  Dirk Eddelbuettel  <edd@debian.org> 
 
        * inst/tinytest/testCRC32.R: Use expcect_* functions 
        * inst/tinytest/testDigest2Int.R: Idem 
        * inst/tinytest/testNum2Hex.R: Idem 
        * inst/tinytest/testRaw.R: Idem 
 
2019-05-26  Dirk Eddelbuettel  <edd@debian.org> 
 
        * tests/tinytest.R: New test driver using tinytest 
        * DESCRIPTION (Suggests): Added tinytest 
        * .travis.yml (install): Install tinytest 
 
        * inst/tinytest/testRaw.R: Converted from tests/raw.R 
        * inst/tinytest/testCRC32.R: Converted from tests/crc32.R 
        * inst/tinytest/testDigest2Int.R: From tests/digest2int.R 
        * inst/tinytest/testNum2Hex.R: From tests/num2hexTest.R 
        * inst/tinytest/testSHA1.R: Converted from tests/sha1Test.R 
        * inst/tinytest/testHMAC.R: Converted from tests/hmacTest.R 
        * inst/tinytest/testAES.R: Converted from tests/aesTest.R 
        * inst/tinytest/testDigest.R: From tests/digestTest.R 
 
        * R/AES.R: Additional #nocov tags 
        * R/digest.R: Idem 
        * R/hmac.R: Idem 
        * R/sha1.R: Idem 
 
2019-05-19  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Release 0.6.19 
 
        * src/SpookyV2.cpp: Add some #nocov tags 
 
2019-05-18  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): New minor version 
 
        * tests/digestTest.Rout.save: Updated reference output 
 
2019-05-12  Kendon Bell  <bellk@landcareresearch.co.nz> 
 
        * R/digest.R: Account for 'skip' bytes for streaming algos 
        * tests/digestTest.R: Adjust test for streaming_algos 
 
2019-05-09  Dirk Eddelbuettel  <edd@debian.org> 
 
        * src/Makevars: Added to ensure C++11 compilation standard 
        * cleanup: Do not delete src/Makevars now that we have one 
        * tests/digestTest.Rout.save: Updated reference output 
 
2019-05-06  Dirk Eddelbuettel  <edd@debian.org> 
 
        * README.md: Mention spookyhash and Kendon 
        * DESCRIPTION (Description): Mention spookyhash 
 
2019-05-04  Kendon Bell  <bellk@landcareresearch.co.nz> 
 
        * tests/digestTest.R: Added more tests 
        * src/spooky_serialize.cpp: Added copyright header 
 
2019-05-04  Dirk Eddelbuettel  <edd@debian.org> 
 
        * R/digest.R: Add some #nocov tags 
        * src/SpookyV2.h: Idem 
        * src/SpookyV2.cpp: Idem 
        * src/spooky_serialize.cpp: Idem 
 
2019-05-03  Dirk Eddelbuettel  <edd@debian.org> 
 
        * tests/digestTest.Rout.save: Updated reference output 
 
2019-04-30  Kendon Bell  <bellk@landcareresearch.co.nz> 
 
        * digest.R: Support spookyhash 
        * src/SpookyV2.h: Idem 
        * src/SpookyV2.cpp: Idem 
        * src/spooky_serialize.cpp: Idem 
        * man/digest.Rd: Document spookyhash 
 
2019-04-23  Kendon Bell  <bellk@landcareresearch.co.nz> 
 
        * src/digest.c: Switch length counter to R_xlen_t 
 
###  2018 

2018-12-23  Dirk Eddelbuettel  <edd@debian.org> 
 
        * NAMESPACE: Add .registration=TRUE to useDynLib() 
 
2018-11-10  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Roll minor version 
 
2018-11-08  Dmitriy Selivanov  <selivanov.dmitriy@gmail.com> 
 
        * src/digest2int.c: Removed (bad) redefinition of uint32_t 
        * tests/digest2intTest.R: Additional test 
 
2018-10-29  Dmitriy Selivanov  <selivanov.dmitriy@gmail.com> 
 
        * DESCRIPTION (Version, Date):  minor version 
        * digest2int.R (digest2int): added digest2int 
        * src/digest2int.c (digest2int): added Bob Jenkins `one_at_a_time` 
        function for hashing arbitrary character vectors to integer vectors 
 
2018-10-18  Dirk Eddelbuettel  <edd@debian.org> 
 
        * README.md: Added dependencies badge 
 
2018-10-10  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Date, Version): Release 0.6.18 
 
2018-09-16  Dirk Eddelbuettel  <edd@debian.org> 
 
        * src/digest.c (digest): Six more #nocov tags 
 
        * README.md: Small edits 
 
2018-09-14  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Roll minor version 
 
        * src/sha2.c: Explicitly #undef SHA256_ and SHA384_ functions not 
        used from this file 
 
2018-09-13  Radford Neal  <radfordneal@gmail.com> 
 
        * src/pmurhash.c (DOBYTES): Explicit cast to uint32_t avoids UBSAN 
 
2018-09-13  Jim Hester  <james.f.hester@gmail.com> 
 
        * src/xxhash.c: Updated to use xxHash v0.6.5 
        * src/xxhash.h: Ditto 
        * src/digest.c: Ditto 
 
2018-09-11  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Date, Version): Release 0.6.17 
 
2018-09-02  Dirk Eddelbuettel  <edd@debian.org> 
 
        * .travis.yml: Simplified as covr can be installed from c2d4u 
 
2018-08-30  Radford Neal  <radfordneal@gmail.com> 
 
        * src/sha2.c: Memory alignment changes motivated by 32bit sparc 
        * src/sha2.h: Ditto 
 
2018-08-21  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Date, Version): Release 0.6.16 
 
2018-08-20  Dirk Eddelbuettel  <edd@debian.org> 
 
        * tests/digestTest.Rout: Skip one test which creates different 
        results across versions and operating systems 
        * tests/digestTest.Rout.save: Ditto 
 
2018-08-19  Dirk Eddelbuettel  <edd@debian.org> 
 
        * tests/hmacTest.R: Added raw test 
        * tests/hmacTest.Rout.save: Updated reference output accordingly 
 
        * tests/raw.R: Added test for 'raw' vector input to sha1() 
 
        * R/sha1.R: Removed no longer needed #nocov tags 
 
2018-07-21  Henrik Bengtsson  <hb@aroma-project.org> 
 
        * DESCRIPTION: digest (>= 0.6.14) requires R (>= 3.0.3) 
 
2018-06-30  Dirk Eddelbuettel  <edd@debian.org> 
 
        * tests/crc32.R: Added test for crc32 and old versus new formats 
        * tests/raw.R: Added small test file for raw tests 
 
2018-06-29  Dirk Eddelbuettel  <edd@debian.org> 
 
        * R/init.R: Provide option 'digestOldCRC32Format' which if TRUE 
        returns without zero padding which can be shorter than eight bytes 
        * R/digest.R: If crc32 selected and option set, return in old format 
        * man/digest.Rd: Document new option 
 
2018-06-28  Dirk Eddelbuettel  <edd@debian.org> 
 
        * src/digest.c (digest): Change print format for crc32 to always 
        return eight characters and no longer drop leading zeros (thanks to 
        Henrik Bengtsson for the heads-up) 
 
2018-06-21  Dirk Eddelbuettel  <edd@debian.org> 
 
        * tests/sha1Test.R: Do not run test using serialize() as its output 
        always reflects the R version used (thanks, Radford Neal) 
 
2018-01-29  Dirk Eddelbuettel  <edd@debian.org> 
 
        * src/sha2.c: Comment-out three unused 'const static' variables 
 
2018-01-28  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Date, Version): Release 0.6.15 
 
        * R/sha1.R (sha1.POSIXlt): Unclass POSIXlt objects as suggested by 
        Kurt Hornik to accomodate R-devel changes 
 
        * tests/sha1Test.R: Condition one sha1 test seemingly affected by 
        R-devel serialization changes to run only with R < 3.5.0 
 
2018-01-21  Thierry Onkelinx  <thierry.onkelinx@inbo.be> 
 
        * sha1() gains an `algo` argument 
        * sha1() handles raw class 
 
2018-01-14  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Date, Version): Release 0.6.14 
 
        * man/AES.Rd: Use https for nist.gov reference 
        * man/digest.Rd: Idem 
        * man/hmac.Rd: Idem 
 
        * man/digest.Rd: Use Wikiepedia page as reference for SHA1 as the 
        reference page at NIST has (long) vanished. 
        * man/hmac.Rd: Idem 
 
2018-01-12  Thierry Onkelinx  <thierry.onkelinx@inbo.be> 
 
        * sha1() handles empty matrices 
 
###  2017 

2017-12-20  Dirk Eddelbuettel  <edd@debian.org> 
 
        * src/raes.c (AESencryptECB,AESdecryptECD): Replace two uses of NAMED 
        with MAYBE_REFERENCED 
 
2017-12-13  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Date, Version): Release 0.6.13 
 
2017-12-12  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): New minor version 
 
        * R/digest.R: Support serializeVersion format 
        * man/digest.Rd: Document new option 
 
        * R/init.R: Set a default version, and internal getter function 
 
2017-10-12  Chris Muir  <chrismuirRVA@gmail.com> 
 
        * vignette/sha1.Rmd: Correct simple typo 
 
2017-11-16  Moritz Beller  <Inventitech@users.noreply.github.com> 
 
        * man/digest.Rd: Replace old Google Code URLs with GitHub ones 
 
2017-02-20  Dirk Eddelbuettel  <edd@debian.org> 
 
        * man/digest.Rd: Expand example section with a Vectorize() use 
 
2017-01-29  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Roll minor version 
 
        * man/digest.Rd: Note that support for 'raw' is not available for all 
        hashing algorithms 
 
        * .travis.yml (before_install): Use https for curl fetch 
 
2017-01-26  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Release 0.6.12 
 
2017-01-23  Thierry Onkelinx <thierry.onkelinx@inbo.be> 
 
        * NAMESPACE: export sha1.function() and sha1.call() 
 
        * R/sha1.R: 
          - sha1() gains methods for the class "function" and "call" 
          - sha1() gains a ... argument, currently only relevant for 
            "function" 
          - sha1() takes arguments into account for hash for complex, 
            Date and array. Note that this will lead to different 
            hasheS for these classes and for objects containing 
            these classes 
 
        * man/sha1.rd: update helppage for sha1() 
 
        * tests/sha1Test.R: update unit tests for sha1() 
 
2017-01-01  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Release 0.6.11 
 
        * R/sha1.R (sha1.anova): Added more #nocov marks 
        * src/sha2.c (SHA256_Transform): Idem 
 
        * tests/AESTest.R (hextextToRaw): Print AES object 
        * tests/AESTest.Rout.save: Updated 
 
###  2016 

2016-12-08  Dirk Eddelbuettel  <edd@debian.org> 
 
        * NAMESPACE: Register (and exported) makeRaw S3 methods 
 
        * man/makeRaw.Rd: New manual page 
 
        * tests/hmacTest.R: Direct call to makeRaw() 
        * tests/hmacTest.Rout.save: Ditto 
 
        * src/digest.c: Additional #nocov tags 
        * src/xxhash.c: Ditto 
 
2016-12-07  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version, Date): Rolled minor version 
 
        * README.md: Use shields.io badge for codecov 
 
        * R/digest.R: Additional #nocov tags 
        * src/sha2.c: Ditto 
        * src/raes.c: Ditto 
 
        * tests/hmacTest.R: Additional tests 
        * tests/hmacTest.Rout.save: Ditto 
 
2016-11-30  Dirk Eddelbuettel  <edd@debian.org> 
 
        * .travis.yml (before_install): Activate PPA as we (currently) 
        need an updated version of (r-cran)-covr to run coverage 
        * tests/load-unload.R: Comment-out for now as it upsets coverage 
 
        * tests/digestTest.R: Test two more algorithms 
        * tests/digestTest.Rout.save: Updated reference output 
 
        * R/digest.R: Added #nocov tags 
        * R/zzz.R (.onUnload): Ditto 
        * src/crc32.c: Ditto 
        * src/pmurhash.c: Ditto 
        * src/raes.c: Ditto 
        * src/sha2.c: Ditto 
        * src/xxhash.c: Ditto 
 
2016-11-26  Dirk Eddelbuettel  <edd@debian.org> 
 
        * .travis.yml (after_success): Integrated Jim Hester's suggestion of 
        activating code coverage sent many moons ago (in PR #12) 
        * .codecov.yml (comment): Added 
        * .Rbuildignore: Exclude .codecov.yml 
        * README.md: Added code coverage badge 
 
2016-10-16  Dirk Eddelbuettel  <edd@debian.org> 
 
        * R/digest.R (digest): Support 'nosharing' option of base::serialize 
        as suggested by Radford Neal whose pqR uses this 
 
2016-08-02  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (License): Now GPL (>= 2), cf issue 36 on GH 
 
        * README.md: Updated badge accordingly 
 
2016-08-02  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version): Release 0.6.10 
 
        * DESCRIPTION (Description): Shortened to one paragraph 
        * DESCRIPTION (BugReports): URL to GH issues added 
 
        * .travis.yml: Rewritten for run.sh from forked r-travis 
 
2016-07-12  Henrik Bengtsson  <hb@aroma-project.org> 
 
        * src/digest.c: Correct bug with skip and file parameter interaction 
        * tests/digestTest.R: Test code 
        * tests/digestTest.Rout.save: Test reference output 
 
        * R/zzz.R: Allow for unloading of shared library 
        * tests/load-unload.R: Test code 
 
        * DESCRIPTION: Rolled minor Version and Date 
 
2016-05-25 Thierry Onkelinx <thierry.onkelinx@inbo.be> 
 
        * R/sha1.R: Support for pairlist and name 
        * tests/sha1Test.R: Support for pairlist and name 
        * man/sha1.Rd: Support for pairlist, name, complex, array and Date 
        * NAMESPACE: Support for pairlist, name and array 
        * DESCRIPTION: bump version number and date 
 
2016-05-01  Viliam Simko  <viliam.simko@gmail.com> 
 
        * R/sha1.R: Support for complex, Date and array 
        * tests/sha1Test.R: Ditto 
        * NAMESPACE: Ditto 
 
2016-04-27  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Author): Add Qiang Kou to Authors 
        * README.md: Ditto 
 
2016-01-25  Dirk Eddelbuettel  <edd@debian.org> 
 
        * src/digest.c (digest): Use XLENGTH if R >= 3.0.0 (issue #29) 
 
2016-01-11 Thierry Onkelinx  <thierry.onkelinx@inbo.be> 
 
        * R/sha1.R: handle empty list and empty dataframe (#issue 27); 
        take the object class, digits and zapsmall into account (#PR 28) 
 
        * vignettes/sha1.Rmd: Small edits to reflect changes is sha1() 
 
2016-01-09 Michel Lang  <michellang@gmail.com> 
 
        * R/sha1.R: Add a length check to sha1(), use vapply() 
 
2016-01-07  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version): Version 0.6.9 
 
        * DESCRIPTION (Date): Bumped Date: to current date 
 
2016-01-06  Dirk Eddelbuettel  <edd@debian.org> 
 
        * vignettes/sha1.Rmd: Small edits 
 
2016-01-06  Thierry Onkelinx <thierry.onkelinx@inbo.be> 
 
        * R/sha1.R: Add functions to calculate stable SHA1 with floating points 
        * man/sha1.Rd: Add helpfile for sha1() 
 
        * tests/num2hexTest.R: unit tests for num2hex() (non exported function) 
        * tests/sha1Test.R: unit tests for sha1() 
 
        * NAMESPACE: Export sha1 and its methods 
 
        * DESCRIPTION: Add Thierry Onkelinx as contributor, bump Version and Date 
        * README.md: Add Thierry Onkelinx as contributor 
 
        * vignette/sha1.Rmd: Added 
 
        * .travis.yml: Added 'sudo: required' per recent Travis changes 
 
###  2015 

2015-10-14  Dirk Eddelbuettel  <edd@debian.org> 
 
        * man/digest.Rd: Remove references to inaccessible web pages 
        * man/hmac.Rd: Ditto 
 
2015-10-13  Dirk Eddelbuettel  <edd@debian.org> 
 
        * src/digest.c: Use uint32_t instead of int for nchar 
 
2015-10-12  Qiang Kou <qkou@umail.iu.edu> 
 
        * src/digest.c: Use XLENGTH instead of LENGTH (PR #17, issue #16) 
 
2015-08-06  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Title): Updated now stressing 'compact' over 'crypto' 
 
###  2014 

2014-12-30  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version): Version 0.6.8 
 
        * DESCRIPTION (Date): Bumped Date: to current date 
 
2014-12-29  Dirk Eddelbuettel  <edd@debian.org> 
 
        * inst/include/pmurhashAPI.h: Added HOWTO comment to top of file 
 
2014-12-26  Dirk Eddelbuettel  <edd@debian.org> 
 
        * src/pmurhash.c: Protect against _BIG_ENDIAN defined but empty 
 
        * inst/include/pmurhash.h: Consistent four space indentation 
 
2014-12-25  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION: Bump Date: and Version: 
 
        * src/init.c: Minor edit and removal of unused headers 
 
2014-12-25  Wush Wu  <wush978@gmail.com> 
 
        * inst/include/pmurhash.h: Export function 
        * src/init.c: Register function for use by other packages 
 
2014-12-20  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version): Version 0.6.7 
 
        * DESCRIPTION (Date): Bumped Date: to current date 
 
2014-12-19  Dirk Eddelbuettel  <edd@debian.org> 
 
        * cleanup: Also remove src/symbols.rds 
 
        * src/sha2.c: Apply (slightly edited) patch from 
        https://www.nlnetlabs.nl/bugs-script/attachment.cgi?id=220&action=diff 
        to overcome the strict-aliasing warning 
 
        * src/digest.c: Use inttypes.h macro PRIx64 only on Windows 
 
2014-12-16  Dirk Eddelbuettel  <edd@debian.org> 
 
        * src/xxhash.c: Remove two semicolons to make gcc -pedantic happy 
        * tests/digestTest.Rout.save: Updated reflecting murmurHash test 
        * src/pmurhash.c: Renamed from PMurHash.c for naming consistency 
        * src/pmurhash.h: Renamed from PMurHash.h for naming consistency 
 
2014-12-16  Jim Hester <james.f.hester@gmail.com> 
 
        * src/digest.c: murmurHash implementation 
        * tests/digestTest.R: murmurHash implementation 
        * R/digest.R: murmurHash implementation 
        * src/PMurHash.c: murmurHash implementation 
        * src/PMurHash.h: murmurHash implementation 
 
2014-12-10  Dirk Eddelbuettel  <edd@debian.org> 
 
        * src/xxhash.c: Applied pull request #6 by Jim Hester with updated 
        upstream code and already corrected UBSAN issue identified by CRAN 
 
2014-12-09  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version): Version 0.6.6 
 
        * DESCRIPTION (Date): Bumped Date: to current date 
 
        * src/digest.c: Applied pull request #5 by Jim Hester providing 
        portable integer printing inttypes.h header 
 
2014-12-08  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version): Version 0.6.5 
 
        * DESCRIPTION (Date): Bumped Date: to current date 
 
        * NAMESPACE: Expanded useDynLib() declaring C level symbols, in 
        particular using digest_impl to for the C-level digest 
 
        * R/AES.R: Use R symbols from NAMESPACE declaration in .Call() 
        * R/digest.R: Use R symbol digest_impl to load C level digest 
 
2014-12-07  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION: Edited Title and Description 
 
        * R/digest.R: Added GPL copyright header, reindented to four spaces 
 
        * src/digest.c: Reindented to four spaces 
 
        * R/AES.R: Reindented to four spaces 
        * R/hmac.R: Reindented to four spaces 
 
2014-12-06  Dirk Eddelbuettel  <edd@debian.org> 
 
        * src/digest.c: Updated GPL copyright header 
 
        * src/xxhash.c: Removed two spurious ';' 
 
        * man/digest.Rd: Document 'seed' argument in \usage 
 
        * tests/digest.Rout.save: Updated for expanded tests 
 
        * DESCRIPTION: Add Jim Hester to list of Authors 
 
2014-12-05  Dirk Eddelbuettel  <edd@debian.org> 
 
        * R/digest.R: Applied pull request #3 by Jim Hester with support for 
        xxHash (https://code.google.com/p/xxhash/) 
        * src/digest.c: Ditto 
 
        * src/xxhash.c: xxHash implementation supplied as part of #3 
        * src/xxhash.h: xxHash implementation supplied as part of #3 
 
        * R/digest.R: Applied pull request #4 by Jim Hester with expanded 
        support for xxHash providing xxhash32 and xxhash64 
        * src/digest.c: Ditto 
        * man/digest.Rd: Added documentation for xxHash, corrected typos 
        * src/digest.R: New support for a seed parameter used by xxHash 
        * tests/digestTest.R: Added tests for xxHash 
 
2014-08-15  Dirk Eddelbuettel  <edd@debian.org> 
 
        * R/hmac.R: Applied (slightly edited) patch for crc32 computation of 
        hmac kindly supplied by Suchen Jin 
 
###  2013 

2013-12-02  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version): Version 0.6.4 
 
        * src/sha2.h (BYTE_ORDER): Define BYTE_ORDER unless already defined, 
        rely on Rconfig.h which itself goes back to an R compile-time test 
 
2013-02-16  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version): Version 0.6.3 
 
2013-02-06  Hannes Mühleisen  <hannes@cwi.nl> 
 
        * R/hmac.R: Fixed hmac for sha512 hashes 
        * tests/hmacTest.R: Added test cases for hmac with sha512 
        * tests/hmacTest.Rout.save: Updated accordingly 
 
2013-01-25  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version): Version 0.6.2 
 
        * man/AES.Rd: Switch from paste0() to paste() to permit use on 
        R-oldrelease as per email by Uwe Ligges 
 
        * tests/AESTest.R: Idem 
        * tests/AESTest.Rout.save: Updated accordingly 
 
2013-01-21  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Version): Version 0.6.1 
 
        * inst/GPL-2: Added as a fixed reference input for regression tests 
        via the scripts in tests/ as the versions installed by R differ 
        across OS and installations 
 
        * tests/digestTest.R: No longer rely on file.path(R.home(),"COPYING") 
        but rather use our own copy of GPL-2; ensure final test does not print 
        * tests/digestTest.Rout.save: Updated accordingly 
 
2013-01-19  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION (Authors): Added Duncan Murdoch 
 
2013-01-19  Duncan Murdoch <murdoch.duncan@gmail.com> 
 
        * src/aes.c: Devine's AES implementation added 
        * src/aes.h: header for AES implementation 
        * src/raes.c: interface to it 
        * R/AES.R: Add AES object to do AES encryption 
        * tests/AESTest.R: tests from the standards documents 
        * man/AES.Rd: document AES object 
        * NAMESPACE: export AES constructor and print method 
 
###  2012 

2012-11-25  Dirk Eddelbuettel  <edd@debian.org> 
 
        * Release 0.6.0 
 
        * src/sha2.h: In order to build on Windows: 
          - Include the newer header file stdint.h 
          - Enforce standard integer types by defining SHA2_USE_INTTYPES_H 
          - Define BYTE_ORDER and default to LITTLE_ENDIAN 
 
        * src/digest.c: Use uint8_t from stdint.h for sha256 
 
2012-11-24  Dirk Eddelbuettel  <edd@debian.org> 
 
        * src/digest.c: Allow for extra null character in output[] vector 
 
        * tests/digestTest.Rout.save: Update/Revert a change by Hannes; 
        Naturally we do not get a single set that works for R-release and 
        R-devel. Sigh. 
 
2012-11-24  Hannes Mühleisen  <hannes@cwi.nl> 
 
        * src/digest.c: sha-512 integration 
        * src/sha2.h: Header file for Aaron Gifford's SHA2 implementation 
        * src/sha2.c: Aaron Gifford's sha2 implementation 
        * R/digest.R: enabled new sha-512 algorithm parameter 
        * R/hmac.R: enabled new sha-512 algorithm parameter 
        * man/digest.Rd: documented new sha-512 algorithm parameter 
        * man/hmac.Rd: documented new sha-512 algorithm parameter 
        * tests/digestTest.R: Added sha-512 test cases 
 
2012-03-14  Dirk Eddelbuettel  <edd@debian.org> 
 
        * Release 0.5.2 
 
        * Applied patch by Murray Stokely: 
          - R/digest.R: Additional test for file accessibility; segfault can 
            happen if inaccesible file passed down 
          - tests/digestTest.R: New test which leads to segfault in unpatched 
            package, and passes with these changes 
          - src/digest.c: Simpler use of error() via format string 
 
        * DESCRIPTION: Fixed one typo in extended description 
 
        * tests/digest.Rout.save: Updated to current output; version 0.5.1 
        created the same difference so it is presumably once again something 
        that changed in R's serialization. Oh, and R-devel changes it again. 
 
###  2011 

2011-09-20  Dirk Eddelbuettel  <edd@debian.org> 
 
        * Release 0.5.1 
 
        * tests/digestTest.Rout.save: Updated reference output too 
 
2011-09-18  Bryan Lewis  <blewis@illposed.net> 
 
        * tests/digestTest.R: Added basic raw output md5 and sha1 tests 
 
2011-09-14  Dirk Eddelbuettel  <edd@debian.org> 
 
        * src/digest.c: Applied patch contributed by Bryan Lewis which 
        supports output of unmodified raw binary output if a new function 
        parameter 'raw' (which defaults to FALSE) is set to TRUE 
        * R/digest.R: Support new parameter 'raw' 
        * man/digest.Rd: Document new parameter 'raw' 
 
2011-05-29  Dirk Eddelbuettel  <edd@debian.org> 
 
        * Release 0.5.0 
 
2011-05-26  Dirk Eddelbuettel  <edd@debian.org> 
 
        * R/hmac.R: Switched to camelCase identifiers after discussion with 
          Henrik and Mario 
 
2011-05-25  Dirk Eddelbuettel  <edd@debian.org> 
 
        * R/hmac.R: New hmac() function contributed by Mario Frasca 
        * man/hmac.Rd: Documentation contributed by Mario Frasca 
 
        * tests/hmacTest.R: Added a new regression test file for hmac() 
        * tests/hmacTest.Rout.save: Added new reference output 
 
        * tests/digestTest.Rout.save: Updated reference digest output 
          for simple R structure to match what R 2.13.0 yields 
 
        * inst/ChangeLog: moved to ChangeLog (in top-level directory) 
 
        * INDEX: removed, as no longer needed 
 
###  2009 

2009-12-03  Henrik Bengtsson  <henrikb@braju.com> 
 
        * Release 0.4.2 
 
        * R/digest.R: Bug fix - digest(object, file=TRUE) where object 
          is a directory would cause R to crash.  Now it gives an error. 
 
2009-10-06  Dirk Eddelbuettel  <edd@debian.org> 
 
        * DESCRIPTION: set SVN properties Date and Id, fix indentation 
 
2009-09-24  Dirk Eddelbuettel  <edd@debian.org> 
 
        * Release 0.4.1 
 
        * src/Makefile.win: Removed as package builds on Windows without it 
          but not with it being present 
 
        * src/digest.c: Updated Copyright years, set SVN properties Date and Id 
        * R/digest.R: Idem 
        * man/digest.Rd: Idem 
 
2009-09-23  Dirk Eddelbuettel  <edd@debian.org> 
 
        * Release 0.4.0 
 
        * src/sha256.c: Added sha-256 implementation by Christophe Devine 
          as found (via Google Code Search) in a number of Open Source 
          projects such as mushclient, aescrypt2, scrypt, and ipanon 
        * src/sha256.h: Idem 
 
        * src/digest.c: Modified to support SHA-256 
        * R/digest.R: Idem 
        * man/digest.Rd: Idem, also added more references 
 
        * src/Makefile.win: Updated for SHA-256, and generally spruced up 
 
###  2007 

2007-09-28  Dirk Eddelbuettel  <edd@debian.org> 
 
        * Release 0.3.1 
 
        * DESCRIPTION: Switched to standardised form 'GPL-2' for License: 
 
        * src/digest.c: Added one explicit (char *) cast 
 
2007-04-27  Dirk Eddelbuettel  <edd@debian.org> 
 
        * Release 0.3.0 
        * R/digest.R: Adopted two more changes suggested by Henrik 
 
2007-03-12  Dirk Eddelbuettel  <edd@debian.org> 
 
        * R/digest.R: Adopted a few changes suggested by Henrik 
 
2007-03-09  Dirk Eddelbuettel  <edd@debian.org> 
 
        - R/digest.R, man/digest.Rd, Applied two more patches by 
          Simon Urbanek that clean object mangling (for better comparison 
          across R versions, adds an ascii flag, adds skip="auto" support 
          to by pass the version header info, and clean the file option 
          interface. This effectively replaces Henrik's patch relative to 
          the 0.2.3 release.  Thanks for the patches, Simon! 
        - tests/digestTest.Rout.save: New reference output; one line changed 
 
2007-03-08  Dirk Eddelbuettel  <edd@debian.org> 
 
        - R/digest.R, man/digest.Rd, src/digest.C: Applied two 
          patches by Simon Urbanek to help improve consistence 
          of digest output across different R versions by allowing 
          digest to 'skip' a certain number of bytes; and by adding 
          support for 'raw' serialization input 
 
2007-01-08  Dirk Eddelbuettel  <edd@debian.org> 
 
        - R/digest.R: Added improvement suggested by Henrik 
 
###  2006 

2006-12-30  Dirk Eddelbuettel  <edd@debian.org> 
 
        * Release 0.2.3 
        - R/digest.R: Added file.expand() around filename 
 
2006-07-28  Dirk Eddelbuettel  <edd@debian.org> 
 
        * Release 0.2.2 
        - R/digest.R: Added patch for R 2.4.0 by Henrik Bengtsson 
        - tests/: Added simple unit tests 
 
###  2005 

2005-11-02  Dirk Eddelbuettel  <deddelbu@lx-chprd97.wfg.com> 
 
        * Release 0.2.1 
        - R/digest.R, src/digest.c, man/digest.Rd: add support for file 
          mode based on a complete set of patches by Jarek Tuszynski 
 
2005-04-06  Dirk Eddelbuettel  <edd@debian.org> 
 
        * Release 0.2.0 
        - R/digest.R, src/digest.c, man/digest.Rd: add support for crc32 
          digests based on a complete set of patches by Antoine Lucas 
        - src/{crc32.c,crc32.h,zlib.h,zutil.h,zconf.h}: From zlib 
 
###  2004 

2004-05-26  Dirk Eddelbuettel  <edd@debian.org> 
 
        * Release 0.1.2 
        - R/zzz.R: remove test for R < 1.8.0 and load of serialize package 
          (as serialize has been removed from CRAN with serialize() in R) 
 
###  2003 

2003-11-29  Dirk Eddelbuettel  <edd@debian.org> 
 
        * Release 0.1.1 
        - DESCRIPTION: added to RCS, $Date$ is now filled 
        - DESCRIPTION: small rewording in Description field 
        - corrected minor packaging error by removing spurious tarball 
 
2003-11-28  Dirk Eddelbuettel  <edd@debian.org> 
 
        * Release 0.1.0 
        - DESCRIPTION: added extended Description 
        - inst/ChangeLog: added 
        - man/digest.Rd: added complete test vectors for md5 and sha-1 
          in example code, values taken from the examples of the C code 
 
2003-10-23  Dirk Eddelbuettel  <edd@debian.org> 
 
        * Release 0.0.1 
        - initial version 
