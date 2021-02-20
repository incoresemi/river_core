# shakti-documentation

# Requirements
Has been tested using ``python3``
```sh
$ pip install -r requirements.txt
```

## HTML documentation

```sh
$ cd doc

# build the HTML documentation
$ make html

# viewing
$ xdg-open build/html/index.html

# chrome
$ google-chrome build/html/index.html

# firefox
$ firefox build/html/index.html

```
Documents are present in ``doc/source`` directory where you can edit

## PDF documentation

``Requisites:``
```sh
$ sudo apt-get install  texlive
$ sudo apt install xelatex
```
Commands to build and view
```sh
# build 
$ make latexpdf

# view
$ xdg-open build/latex/river_core.pdf
```
## Build clean

```sh
# build clean
$ make clean
```

# References
[Sphinx](http://www.sphinx-doc.org/en/master/)
