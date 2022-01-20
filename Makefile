PDF := $(shell find fig -mindepth 1 -maxdepth 1 -type d)
CROP := $(join $(PDF), $(addprefix /,$(addsuffix -crop.pdf, $(notdir $(PDF)))))

MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables

%.pdf: %.emf
	inkscape $< \
		--export-margin=10 \
		--export-filename=$@

%-crop.pdf: %.pdf
	pdfcrop \
		--verbose \
		--luatex $< $@

pdf: $(CROP)
	latexmk \
		-bibtex \
		-pdflatex="lualatex --interaction=nonstopmode" \
		-pdf \
		-halt-on-error

annotated: $(CROP) pdf
	git latexdiff \
		submission \
		--preamble preamble.latexdiff \
		--filter "./bin/remove_deletions.py document.tex"\
		--append-safecmd="item" \
		--main document.tex \
		--biber \
		--lualatex \
		--no-view \
		--ln-untracked \
		--output annotated.pdf \
		--cleanup none \
		--verbose

clean:
	latexmk -c
