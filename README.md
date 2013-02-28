=========================
jachymko's home directory
=========================

Readme work in progress, sorry.

## Install on OS X or FreeBSD
```sh
git clone https://github.com/jachymko/home.git ~/.jachymko
```

## Install on FreeBSD without git
```sh
fetch -o - http://github.com/jachymko/home/tarball/master | pax -z -r -s,jachymko[^/]*,$HOME/.jachymko,p
```

## Install on Windows
1. Install [GitHub for Windows](http://windows.github.com/).
2. Clone this repository.
