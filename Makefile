SYSTEMD ?= true

all: build

build: xlibre-server
	@echo "Compiling with SYSTEMD=${SYSTEMD}"
	./compile.sh ${SYSTEMD}

clean:
	./clean.sh

distclean: clean
	./distclean.sh

xlibre-server: get

get:
	./download.sh

.PHONY: all clean distclean get # build is a real dir
