PDF := $(shell find fig -mindepth 1 -maxdepth 1 -type d)
CROP := $(join $(PDF), $(addprefix /,$(addsuffix -crop.pdf, $(notdir $(PDF)))))

MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables

%.pdf: %.emf
	inkscape $< --export-margin=10 --export-filename=$@

%-crop.pdf: %.pdf
	pdfcrop --verbose --luatex $< $@

all: $(CROP)
	latexmk -bibtex -pdflatex="lualatex --interaction=nonstopmode" -pdf -halt-on-error

clean: 
	latexmk -c
