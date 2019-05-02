# homebrew-pass-osx
Pass for osx by default is very slow.

This repo contains a formula for a [forked](https://github.com/Fingel/password-store) version of
the excellent [passwordstore](https://www.passwordstore.org) script by zx2c4 with fix(es)
to make it run better on OSX.

The current version of the code contains some
[very inefficient](https://git.zx2c4.com/password-store/tree/src/platform/darwin.sh#n46) code
for finding gnu getopt on the system, always calling `brew --prefix`. Spinning up a ruby interpreter
causes a noticeable, and annoying lag, for every pass command.
[This commit](https://github.com/Fingel/password-store/commit/6e6f4f745b66f0d5a964dabc9965f609da61cb3d)
fixes that.

There [have been some patches](https://lists.zx2c4.com/pipermail/password-store/2018-October/003447.html) submitted to the mailing list but after a few years it doesn't look like they are going
to be merged. Thus this fork.
