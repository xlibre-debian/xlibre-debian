SYSTEMD ?= true

all: build

build:
	@echo "Compiling with SYSTEMD=${SYSTEMD}"
	./compile.sh ${SYSTEMD}

clean:
	./clean.sh

distclean: clean
	./distclean.sh

.PHONY: all clean distclean # build is a real dir
