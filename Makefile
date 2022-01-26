PDF := $(shell find fig -mindepth 1 -maxdepth 1 -type d)
CROP := $(join $(PDF), $(addprefix /,$(addsuffix -crop.pdf, $(notdir $(PDF)))))

MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables

fig/%.pdf: %.emf
	inkscape $< \
		--export-margin=10 \
		--export-filename=$@

fig/%-crop.pdf: %.pdf
	pdfcrop \
		--verbose \
		--luatex $< $@

expand.tex: document.tex
	latexpand document.tex > expand.tex

document.pdf: document.tex $(CROP)
	latexmk \
		-bibtex \
		-pdflatex="lualatex --interaction=nonstopmode" \
		-pdf \
		-halt-on-error \
		document.tex

annotated.pdf: document.tex $(CROP)
	git latexdiff \
		submission \
		--preamble preamble.latexdiff \
		--filter "./bin/remove_deletions.py document.tex && ./bin/patch_latexdiff.py document.tex" \
		--append-safecmd="soft" --append-safecmd="filename" \
		--main document.tex \
		--biber \
		--lualatex \
		--no-view \
		--output annotated.pdf \
		--tmpdirprefix . \
		--cleanup none \
		--verbose

response_to_reviewers.pdf: response_to_reviewers.tex $(CROP)
	latexmk \
		-bibtex \
		-pdflatex="lualatex --interaction=nonstopmode --shell-escape" \
		-pdf \
		-halt-on-error \
		response_to_reviewers.tex

all: document.pdf annotated.pdf response_to_reviewers.pdf

clean:
	latexmk -c
