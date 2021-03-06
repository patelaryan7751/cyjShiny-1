all:  npm docs install build check

docs:
	R -e "devtools::document()"
vig:
	R -e "devtools::build_vignettes()"

npm:
	(cd inst/browserCode; make)

build:
	(cd ..; R CMD build --no-build-vignettes cyjShiny)

install:
	(cd ..; R CMD INSTALL cyjShiny)

check:
	(cd ..; R CMD check `ls -t cyjShiny_* | head -1`)

biocCheck:
	(cd ..; R CMD BiocCheck `ls -t cyjShiny_* | head -1`)
