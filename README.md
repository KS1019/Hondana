# Hondana

Hondana (本棚; Bookshelf in Japanese) is a cli tool to manage your bookmarklets.

## Install
Hondana can be installed via Homebrew
```shell
brew install KS1019/formulae/Hondana
```

## Setup
After you have successfully finished the installation, you will need to create `~/.Hondana/` directory. It can be done by 
```shell
cd ~
mkdir .Hondana
```
After that, you first need to move `Bookmarks.plist` from `~/Library/Safari/` to `~/.Hondana/` and then symlink `~/.Hondana/Bookmarks.plist` to `~/Library/Safari/Bookmarks.plist`. This process can be done by
```shell
mv ~/Library/Safari/Bookmarks.plist ~/.Hondana/ && ln -s ~/.Hondana/Bookmarks.plist 
```
This oneliner requires Terminal to have full disk access and you can grant the access from Settings. However, it could potentially be a security risk so if you are not sure about what you are trying to do, please refrain from using this tool.

If you know what you are doing, grant the access and make sure to remove the access after you finished the set up.

## Usage

## Contributing
If you want to report a bug or request a feature, please open an issue. If you want to improve the tool, please submit a Pull Request.
