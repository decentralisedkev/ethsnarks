ROOT_DIR := $(shell dirname $(realpath $(MAKEFILE_LIST)))

ifeq ($(OS),Windows_NT)
	detected_OS := Windows
	DLL_EXT := .dll
else
	detected_OS := $(shell uname -s)
	ifeq ($(detected_OS),Darwin)
		DLL_EXT := .dylib
		export LD_LIBRARY_PATH := /usr/local/opt/openssl/lib:"$(LD_LIBRARY_PATH)"
		export CPATH := /usr/local/opt/openssl/include:"$(CPATH)"
		export PKG_CONFIG_PATH := /usr/local/opt/openssl/lib/pkgconfig:"$(PKG_CONFIG_PATH)"
	else
		DLL_EXT := .so
	endif
endif

PIP_ARGS ?= --user
PYTHON ?= python3
NAME ?= ethsnarks
NPM ?= npm

GANACHE ?= $(ROOT_DIR)/node_modules/.bin/ganache-cli
TRUFFLE ?= $(ROOT_DIR)/node_modules/.bin/truffle
COVERAGE = $(PYTHON) -mcoverage run --source=$(NAME) -p

PINOCCHIO = build/src/pinocchio/pinocchio
PINOCCHIO_TESTS=$(wildcard test/pinocchio/*.circuit)


#######################################################################


all: node_modules build/src/verify truffle-compile

clean: coverage-clean python-clean
	rm -rf build


#######################################################################


build: depends/libsnarks/CMakeLists.txt
	mkdir -p build

cmake-debug: build
	cd build && cmake -DCMAKE_BUILD_TYPE=Debug ..

cmake-release: build
	cd build && cmake -DCMAKE_BUILD_TYPE=Release ..

cmake-performance: build
	cd build && cmake -DCMAKE_BUILD_TYPE=Release -DPERFORMANCE=ON ..

cmake-openmp-debug: build
	cd build && cmake -DCMAKE_BUILD_TYPE=Debug -DMULTICORE=1 ..

cmake-openmp-release: build
	cd build && cmake -DCMAKE_BUILD_TYPE=Release -DMULTICORE=1 ..

cmake-openmp-performance: build
	cd build && cmake -DCMAKE_BUILD_TYPE=Release -DMULTICORE=1 -DPERFORMANCE=ON ..

release: cmake-release all

debug: cmake-debug all

build/src/verify: build/Makefile
	$(MAKE) -C build

build/Makefile: build CMakeLists.txt
	cd build && cmake ..

depends/libsnarks/CMakeLists.txt:
	git submodule update --init --recursive

build/PVS-Studio.log: build/Makefile
	cd build && pvs-studio-analyzer analyze

pvs-tasks: build/PVS-Studio.log
	plog-converter -t tasklist $<


#######################################################################


.PHONY: test
test: pinocchio-test cxx-tests python-test truffle-test

python-test:
	$(COVERAGE) -m unittest discover test/

cxx-tests:
	$(MAKE) -C build test

.keys:
	mkdir -p $@


#######################################################################
# Pinocchio Tests


pinocchio-test: $(addsuffix .result, $(basename $(PINOCCHIO_TESTS)))

pinocchio-clean:
	rm -f test/pinocchio/*.result

test/pinocchio/%.result: test/pinocchio/%.circuit test/pinocchio/%.test test/pinocchio/%.input $(PINOCCHIO)
	$(PINOCCHIO) $< eval $(basename $<).input > $@
	diff -ru $(basename $<).test $@ || rm $@


#######################################################################


coverage: coverage-combine coverage-report

coverage-clean:
	rm -rf .coverage .coverage.* htmlcov

coverage-combine:
	$(PYTHON) -m coverage combine

coverage-report:
	$(PYTHON) -m coverage report

coverage-html:
	$(PYTHON) -m coverage html


#######################################################################


lint: python-pyflakes python-pylint cxx-lint solidity-lint

python-pyflakes:
	$(PYTHON) -mpyflakes $(NAME)

python-pylint:
	$(PYTHON) -mpylint $(NAME) || true

python-clean:
	find . -name '*.pyc' -exec rm -f '{}' ';' || true
	find . -name '__pycache__' -exec rm -rf '{}' ';' || true

cxx-lint:
	cppcheck -I depends/libsnark/ -I depends/libsnark/depends/libff/ -I depends/libsnark/depends/libfqfft/ -I src/ --enable=all src/ || true


#######################################################################


python-dependencies: requirements requirements-dev

requirements:
	$(PYTHON) -m pip install $(PIP_ARGS) -r requirements.txt

requirements-dev:
	$(PYTHON) -m pip install $(PIP_ARGS) -r requirements-dev.txt

fedora-dependencies:
	dnf install procps-ng-devel gmp-devel boost-devel cmake g++ python3-pip

ubuntu-dependencies:
	apt-get install cmake make g++ libgmp-dev libboost-all-dev libprocps-dev python3-pip

mac-dependencies:
	brew install python3 pkg-config boost cmake gmp openssl || true


#######################################################################


solidity-lint:
	$(NPM) run lint


#######################################################################


nvm-install:
	./utils/nvm-install
	nvm install --lts

node_modules:
	$(NPM) install

.PHONY: truffle-test
truffle-test: $(TRUFFLE)
	$(NPM) run test

truffle-migrate: $(TRUFFLE)
	$(TRUFFLE) migrate

truffle-compile: $(TRUFFLE)
	$(TRUFFLE) compile

testrpc: $(TRUFFLE)
	$(NPM) run testrpc

