

all: pdf img

pdf:
	cd STI20_Attack_Access_Controls_GD_GR_CW_presentation// && latexmk -pdf
img:
	cd STI20_Attack_Access_Controls_GD_GR_CW_presentation// && convert -density 300 -scale 1920x1080 main.pdf main.jpg
