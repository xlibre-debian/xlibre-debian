SYSTEMD ?= true

all: build

build:
	@echo "Compiling with SYSTEMD=${SYSTEMD}"
	./compile.sh ${SYSTEMD}

clean:
	./clean.sh

distclean: clean
	./distclean.sh

get:
	./download.sh

.PHONY: all clean distclean get # build is a real dir
