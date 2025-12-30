SYSTEMD ?= true
FAILFAST ?= true

all: build

build: xlibre-server
	@echo "Compiling with SYSTEMD=${SYSTEMD}"
	./compile.sh ${SYSTEMD} ${FAILFAST}

actions: xlibre-server
	@echo "Compiling with SYSTEMD=${SYSTEMD} using CI scripts"
	./actionscompile.sh ${SYSTEMD} ${FAILFAST}

clean:
	./clean.sh

distclean:
	./distclean.sh

xlibre-server: get

get:
	./download.sh

.PHONY: all clean distclean get # build is a real dir
