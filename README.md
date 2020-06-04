# libnv-portable

A cross-platform userspace version of libnv ported from FreeBSD 12.

libnv is a library that facilitates the creation of lists of name-value pairs,
and the sending of those lists over sockets.


# Dependencies

- `libbsd`, which provides those BSD libc includes which differ from (or don't
  exist in) glibc.
- `atf-c`, `atf-c++`, and `kyua` if you want to build and run the ATF tests.


# Building

- The default install prefix is /usr/local . For a different prefix, set `-DCMAKE_INSTALL_PREFIX=/new/prefix`
- To build with tests, set `-DNVP_TEST=ON`
- To make, run `make`, to execute tests, run `make test` and to install, run `make install`


# License
```
BSD 2-Clause License

Copyright (c) 2013, The FreeBSD Foundation
Copyright (c) 2013, Mariusz Zaborski <oshogbo@FreeBSD.org>
Copyright (c) 2020, David Zero <zero-one@zer0-one.net>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```
