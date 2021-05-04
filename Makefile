all:
	latexmk -bibtex -pdflatex="lualatex --interaction=nonstopmode" -pdf -quiet -halt-on-error

clean: 
	latexmk -c
