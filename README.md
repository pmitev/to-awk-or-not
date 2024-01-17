[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/pmitev/to-awk-or-not/master)
![ci](https://github.com/pmitev/to-awk-or-not/workflows/ci/badge.svg)

# to-awk-or-not

This repository serves as an auxiliary material to an gawk course/seminar web page

[https://pmitev.github.io/to-awk-or-not/](https://pmitev.github.io/to-awk-or-not/)

## Files used for continuous integration scripts

Filename                           |Descriptions
-----------------------------------|------------------------------------------------------------------------------------------------------
[mlc_config.json](mlc_config.json) |Configuration of the link checker
[.spellcheck.yml](.spellcheck.yml) |Configuration of the spell checker, use `pyspelling -c .spellcheck.yml` to do spellcheck locally
[.wordlist.txt](.wordlist.txt)     |Whitelisted words for the spell checker, use `pyspelling -c .spellcheck.yml` to do spellcheck locally

