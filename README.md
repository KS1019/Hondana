# Hondana
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FKS1019%2FHondana%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/KS1019/Hondana)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FKS1019%2FHondana%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/KS1019/Hondana)

Hondana (本棚; Bookshelf in Japanese) is a cli tool to manage your bookmarklets.

## Install
Hondana can be installed via Homebrew
```shell
brew install KS1019/formulae/Hondana
```

## Setup
After you have successfully finished the installation, you will need to create `~/.Hondana/Bookmarklets/` directory. It can be done by 
```shell
hondana init
```

## Usage
```shell
OVERVIEW: `hondana` helps you manage bookmarklets.

`hondana` is the root command to access other subcommands in order to manage
your bookmarklets.

USAGE: hondana <subcommand>

OPTIONS:
  --version               Show the version.
  -h, --help              Show help information.

SUBCOMMANDS:
  add                     `hondana add` adds a new bookmarklet in
                          `~/.Hondana/Bookmarklets/`
  init                    `hondana init` initilizes `~/.Hondana/Bookmarklets/`
                          directory.
  install                 `hondana install`
  list                    `hondana list` lists every bookmarklet present in
                          `~/.Hondana/Bookmarklets/`

  See 'hondana help <subcommand>' for detailed help.
```

## Contributing
If you want to report a bug or request a feature, please [open an issue](https://github.com/KS1019/Hondana/issues/new). If you want to improve the tool, please [submit a PR](https://github.com/KS1019/Hondana/pulls).
