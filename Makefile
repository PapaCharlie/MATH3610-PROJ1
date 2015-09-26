SHELL := /bin/sh

SRC := $(wildcard *.tex)
PDF := $(SRC:.tex=.pdf)

ifeq ($(OS),Windows_NT)
	pdflatexflags := "-aux-directory=_build"
else
	pdflatexflags := -output-directory=_build
endif

all:
	-mkdir _build
	-rm $(PDF)
	for t in $(SRC) ; do \
		pdflatex -shell-escape $(pdflatexflags) $$t ; \
	done
	make links

clean:
	-rm $(PDF)
	-rm -rf _build/*

links:
	-rm $(PDF)
	ln -s _build/*.pdf .

