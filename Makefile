init:
	cd ~ && mkdir .Hondana
	mv ~/Library/Safari/Bookmarks.plist ~/.Hondana/Bookmarks.plist && ln -s ~/.Hondana/Bookmarks.plist ~/Library/Safari/Bookmarks.plist

undo:
	unlink ~/Library/Safari/Bookmarks.plist
	mv ~/.Hondana/Bookmarks.plist ~/Library/Safari/Bookmarks.plist
	rm -r ~/.Hondana

link:
	ln -s ~/.Hondana/Bookmarks.plist ~/Library/Safari/Bookmarks.plist

unlink:
	unlink ~/Library/Safari/Bookmarks.plist

prefix ?= /usr/local
bindir = $(prefix)/bin
toolName = hondana

build:
	swift build --disable-sandbox -c release

install: build
	mkdir -p $(bindir)
	cp -f ".build/release/$(toolName)" "$(bindir)/$(toolName)"

uninstall:
	rm -rf "$(bindir)/$(toolName)"

clean:
	rm -rf .build

.PHONY: init undo build install uninstall clean link unlink
