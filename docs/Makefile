# See LICENSE for details

# Minimal makefile for Sphinx documentation


# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = .venv/bin/sphinx-build
SPHINXPROJ    = river_core
SOURCEDIR     = source
BUILDDIR      = build

# Put it first so that "make" without argument is like "make help".
help: .venv
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.venv:
	echo Creating Python venv for Sphinx build
	python -m venv .venv
	.venv/bin/pip -q install --upgrade pip
	.venv/bin/pip -q install -r requirements.txt

clean: .venv Makefile
	@$(SPHINXBUILD) -M clean "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

distclean:
	rm -rf .venv build sphinxext/__pycache__

.PHONY: help Makefile

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
.DEFAULT:
# Dependencies for this special target are ignored by make, as discussed in
# http://stackoverflow.com/questions/26875072/dependencies-for-special-make-target-default-not-firing
# We hack around that by calling the target explicitly.
	make .venv

	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
