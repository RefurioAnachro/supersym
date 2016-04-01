
.PHONY: all
all: gamma ghost

gamma: field.ml index.ml matrix.ml tensor.ml gamma.ml gamma_main.ml
	ocamlopt -g -o gamma $^

ghost: field.ml index.ml matrix.ml tensor.ml gamma.ml ghost.ml ghost_main.ml
	ocamlopt -g -o ghost $^

.PHONY: test
test: gamma
	./gamma -d 6 -t 0 > gamma.6.out
	diff gamma.6.ok gamma.6.out

.PHONY: clean
clean:
	rm -f *.cmi *.cmx *.o *.out ghost gamma
