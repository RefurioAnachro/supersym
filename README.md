# supersym

ocaml code to compute supersymmetry algebra cohomology according to this paper:

    Friedmann Brandt:
    _"Supersymmetry cohomology I"_

You'll need a recent ocaml and gnu make to build two commandline programs:

*gamma* will compute gamma matrices for d space and t time dimensions. If you don't pick one of the d+t gammas it will print all of them:

    $ ./gamma --help
    fun with supersymmetry 0.1
    usage: gamma [-d n] [-t n] [n]
      -d <n> dimension
      -t <n> time dimensions

For example, print the 6th one of the 7-dimensional spacetime with one time dimension:

    $ ./gamma -d 6 -t 1 6
    Gamma_6: 332
    0       -i      0       0       0       0       0       0
    i       0       0       0       0       0       0       0
    0       0       0       i       0       0       0       0
    0       0       -i      0       0       0       0       0
    0       0       0       0       0       i       0       0
    0       0       0       0       -i      0       0       0
    0       0       0       0       0       0       0       -i
    0       0       0       0       0       0       i       0

*ghost* can compute linear combinations of gammas and the charge conjugation matrix. For example:

    $ ./ghost -d 6 -t 1   1 c + 2 3 c + 4 5 6 c
    0       -1      0       1       0       -i      0       0
    -1      0       1       0       i       0       0       0
    0       -1      0       1       0       0       0       -i
    -1      0       1       0       0       0       i       0
    0       i       0       0       0       -1      0       1
    -i      0       0       0       -1      0       1       0
    0       0       0       i       0       -1      0       1
    0       0       -i      0       -1      0       1       0
