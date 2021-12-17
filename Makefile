FIGURES := $(shell find fig -mindepth 2 -not -path "*/.*" -type f -name "*.pdf")
CROPPED_FIGURES := $(addsuffix -crop.pdf, $(realpath $(dir $(FIGURES))))

$(CROPPED_FIGURES): $(FIGURES)
	pdfcrop --verbose --luatex $< $@

all: $(CROPPED_FIGURES)
	latexmk -bibtex -pdflatex="lualatex --interaction=nonstopmode" -pdf -halt-on-error

clean: 
	latexmk -c
