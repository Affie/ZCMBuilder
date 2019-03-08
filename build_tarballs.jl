# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "ZCMBuilder"
version = v"0.1.0"

# Collection of sources required to build ZCMBuilder
sources = [
    "https://github.com/AndreHat/zcm.git" =>
    "28c84ef6ad9edd1604ed85a8f3774b0b39b4647e",

    "https://github.com/zeromq/libzmq.git" =>
    "fcc6489eda787924df45b85bbacf5f90d54ce8c1",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/libzmq
sh autogen.sh
./configure --prefix=$prefix --host=$target
make -j${nproc}
make install
cd ~
mkdir -p julia-software
cd julia-software/
wget https://julialang-s3.julialang.org/bin/linux/x64/1.0/julia-1.0.3-linux-x86_64.tar.gz
tar -xvf julia-1.0.3-linux-x86_64.tar.gz
ln -s ~/julia-software/julia-1.0.3/bin/julia /usr/bin/julia
ln -s /opt/x86_64-linux-gnu/bin/gcc /usr/bin/cc
cd $WORKSPACE/srcdir/zcm
./waf configure --use-julia --use-udpm --use-zmq --use-inproc --use-ipc --use-serial
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
    LibraryProduct(prefix, "libzcmjulia", :libzcmjulia),
    LibraryProduct(prefix, "libzmq", :libzmq)
]

# Dependencies that must be installed before this package can be built
dependencies = [

]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
