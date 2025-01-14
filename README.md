# EthSnarks

[![Join the chat at https://gitter.im/ethsnarks](https://badges.gitter.im/ethsnarks.png)](https://gitter.im/ethsnarks?utm_source=share-link&utm_medium=link&utm_campaign=share-link)

Zero-Knowledge proofs are coming to Ethereum and Dapps in 2019!

EthSnarks is a collection of zkSNARK circuits and supporting libraries to use them with Ethereum smart contracts, it aims to help solve one of the biggest problems facing zkSNARKS on Ethereum - cross-platform on desktop, mobile and in-browser, cheap enough to run on-chain, and with algorithms that significantly reduces the time it takes to run the prover.

The notable advantages of using EthSnarks are:

 * Reduced cost, 500k gas with 1 input, using [Groth16](https://eprint.iacr.org/2016/260.pdf).
 * Prove zkSNARKs in-browser, with WebAssembly and Emscripten
 * Linux, Mac and Windows builds
 * Solidity, Python and C++ support in one place
 * A growing library of gadgets and algorithms

EthSnarks is participating in the Ethereum Foundation's grants program, development will continue full-time and we will be working with companies and developers to help overcome the common challenges and hurdles that we all face. Get in-touch for more information.

**WARNING: EthSnarks is beta quality software, improvements and fixes are made frequently, and documentation doesn't yet exist**

## Examples

 * [Miximus - a self-service coin mixer and anonymous transfer method for Ethereum](https://github.com/HarryR/ethsnarks-miximus)
 * [Hopper: an Open-Source Mixer for Mobile-friendly private transfers on Ethereum](https://github.com/argentlabs/hopper)
 * [Example implementations of ethsnarks](https://github.com/LayerXcom/ethsnarks-examples)
 * [An example of a zero-knowledge-proof of a SHA256 pre-image for Ethereum](https://github.com/Ethsnarks/ethsnarks-hashpreimage)

## Building

[![Build Status](https://travis-ci.org/HarryR/ethsnarks.svg?branch=master)](https://travis-ci.org/HarryR/ethsnarks) [![BCH compliance](https://bettercodehub.com/edge/badge/HarryR/ethsnarks?branch=master)](https://bettercodehub.com/)

```
git clone git@github.com:HarryR/ethsnarks.git
cd ethsnarks
make
```

Type `make` - the first time you run it will retrieve submodules, setup cmake and build everything, for more information about the build process see the [Travis-CI build logs](https://travis-ci.org/HarryR/ethsnarks).

 * cmake
 * g++ or clang++
 * gmp
 * npm / nvm

WebAssembly and JavaScript builds are partially supported via [ethsnarks-emscripten](https://github.com/harryr/ethsnarks-emscripten)

# Requests and Contributions

This project aims to help create an ecosystem where a small number of well tested but simple zkSNARK circuits can be easily integrated into your project without having to do all of the work up-front.

If you have any ideas for new components, please [Open an issue](https://github.com/HarryR/ethsnarks/issues/new), or submit a pull request.

# Gadgets

We are surely increasing the range of gadgets, supporting libraries, available documentation and examples; at the moment the best way to find out how to use something is to dig into the code or ask questions via a [new issue](https://github.com/HarryR/ethsnarks/issues/new?labels=question,help%20wanted)

The following gadgets are available

 * 1-of-N
 * [2-bit lookup table](src/gadgets/lookup_2bit.cpp)
 * [3-bit lookup table](src/gadgets/lookup_3bit.cpp)
 * [MiMC](https://eprint.iacr.org/2016/492) hash and cipher
 * [Poseidon](https://eprint.iacr.org/2019/458.pdf) hash function
 * [Miyaguchi-Preneel one-way function](https://en.wikipedia.org/wiki/One-way_compression_function)
 * Merkle tree
 * SHA256 (Ethereum compatible, full round)
 * [Shamir's Secret Sharing Scheme](https://en.wikipedia.org/wiki/Shamir%27s_Secret_Sharing)
 * 'Baby JubJub' twisted Edwards curve
   * EdDSA
   * Pedersen hash

## Maintainers

[@HarryR](https://github.com/HarryR)
