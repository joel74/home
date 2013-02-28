=========================
jachymko's home directory
=========================

Readme work in progress, sorry.

## Install on OS X or FreeBSD
<pre>git clone https://github.com/jachymko/home.git ~/.jachymko</pre>

## Install on FreeBSD without git
<pre>fetch -o - http://github.com/jachymko/home/tarball/master |
    pax -z -r -s,jachymko[^/]*/,$HOME/.jachymko/,p</pre>

## Install on Windows
1. Install [GitHub for Windows](http://windows.github.com/).
2. Clone this repository.
