all:
	git submodule init
	git submodule update
	cabal sandbox init
	cabal sandbox add-source deps/Cron
#	cabal install --dependencies-only
	cabal build
