# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "ZCMBuilder"
version = v"0.0.1"

# Collection of sources required to build ZCMBuilder
sources = [
    "https://github.com/AndreHat/zcm.git" =>
    "a8da98ff240887d4d8a2a25b23bcff80cfac7a12",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd ~
mkdir -p julia-software
cd julia-software/
wget https://julialang-s3.julialang.org/bin/linux/x64/1.0/julia-1.0.3-linux-x86_64.tar.gz
tar -xvf julia-1.0.3-linux-x86_64.tar.gz
cd /usr/bin
ln -s ~/julia-software/julia-1.0.3/bin/julia julia
ln -s /opt/x86_64-linux-gnu/bin/gcc cc
cd $WORKSPACE/srcdir/zcm
./waf configure --use-julia  --use-udpm
./waf build
./waf install --destdir=$WORKSPACE/destdir

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, libc=:glibc),
    Linux(:x86_64, libc=:glibc),
    Linux(:aarch64, libc=:glibc),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf),
    Linux(:powerpc64le, libc=:glibc)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libzcm", :libzcm),
    LibraryProduct(prefix, "libzcmjulia", :libzcmjulia)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

