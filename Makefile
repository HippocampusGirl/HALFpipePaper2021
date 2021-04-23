all:
	latexmk -pdflatex=lualatex -pdf -quiet -halt-on-error -interaction=nonstopmode
