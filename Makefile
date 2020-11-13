

all: pdf img

pdf:
	cd presentation/ && latexmk -pdf
img:
	cd presentation/ && convert -density 300 -scale 1920x1080 main.pdf main.jpg
