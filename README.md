# ZCMBuilder builder

[![Build Status](https://travis-ci.org/Affie/ZCMBuilder.svg?branch=master)](https://travis-ci.org/Affie/ZCMBuilder)

This repository builds binary artifacts for the ZCM.jl project.
This repository has a default .travis.yml file that can be used to build
binary artifacts on Travis CI. You will however need to setup the release
upload manually. See https://docs.travis-ci.com/user/deployment/releases/.

If you don't wish to use travis, you can use the build_tarballs.jl
file manually and upload the resulting artifacts to a hosting provider
of your choice.
