

all:
	cd presentation/ && latexmk -pdf
	cd presentation/ && convert -density 1000 -scale 1920x1080 main.pdf main.jpg
