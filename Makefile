all: index.html

clean:
	rm -f index.html

index.html: src/Main.elm
	elm make $< --optimize --output=$@
