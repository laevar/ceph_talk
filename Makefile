GNUPLOT = $(addsuffix .pdf, $(basename $(wildcard *.plot)))
INKSCAPE = $(addsuffix .pdf, $(basename $(wildcard *.svg)))
DIRS= `find -maxdepth 1  -type d ! -wholename \*.svn\* | grep /`
PDF = $(addsuffix .pdf, $(basename $(wildcard *.eps)))
FILE = "slides"
BIB = "literature.bib"
IMAGES = "images"

show: all
	evince ./$(FILE).pdf & 2> /dev/null

all: $(PDF) $(GNUPLOT) $(INKSCAPE) 
	xelatex --halt-on-error ./$(FILE).tex

literature.bib:

%.pdf: %.plot *.dat $(FILE).bbl
	gnuplot $(IMAGES)/$(basename $@).plot 2> $(IMAGES)/$(basename $@).log
	touch $(IMAGES)/$(basename $@).pdf
	epstopdf $(IMAGES)/$(basename $@).eps

%.pdf: %.svg
	inkscape $(IMAGES)/$(basename $@).svg --export-pdf=$(IMAGES)/$(basename $@).pdf

%.pdf: %.eps
	epstopdf $(IMAGES)/$(basename $@).eps


.PHONY: clean
clean:
	-rm -f *~ *.bak *.aux *.log *.toc *.out *.nav *.snm

replot:
	for i in `find -type f ! -wholename \*.svn\* | grep .dat`; do touch $$i; echo $$i getoucht.; done
#	for i in `find -type f ! -wholename \*.svn\* | grep .plot`; do touch $$i; echo $$i getoucht.; done
	make all

.PHONY: all-evince
all-evince: show
