all:
	git submodule init
	git submodule update
	cabal sandbox init
	cabal sandbox add-source deps/cron
	cabal install
