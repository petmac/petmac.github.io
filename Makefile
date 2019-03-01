all: index.html

clean:
	rm -f index.html

index.html: src/*.elm
	elm make src/Main.elm --optimize --output=$@
