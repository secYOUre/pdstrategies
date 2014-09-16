.PHONY: deps

PDTOURNAMENT_CABAL = "pdtournament/pdtournament.cabal"

all: deps build

build: pdstrategies

pdstrategies:
	cabal sandbox init
	cabal install pdtournament/pdtournament.cabal
	cabal install --only-dependencies
	cabal configure
	cabal build

deps: distclean
	git clone --branch master --depth=1 --quiet https://github.com/pdtournament/pdtournament.git
	echo " exposed-modules:     Tournament, Bots" >> ${PDTOURNAMENT_CABAL}
	echo " build-depends:       base >=4.6 && <4.7, random, containers >=0.5 && <0.6" >> ${PDTOURNAMENT_CABAL}

clean:
	cabal clean

distclean:
	rm -rf ./pdtournament

run:
	cabal run
