SYSTEMD ?= true

all: build

build:
	@echo "Compiling with SYSTEMD=${SYSTEMD}"
	./compile.sh ${SYSTEMD}

clean:
	./clean.sh

distclean: clean
	rm -r ./build

.PHONY: all clean distclean # build is a real dir
