init:
	cd ~ && mkdir .Hondana
	mv ~/Library/Safari/Bookmarks.plist ~/.Hondana/ && ln -s ~/.Hondana/Bookmarks.plist ~/Library/Safari/Bookmarks.plist  

undo:
	unlink ~/Library/Safari/Bookmarks.plist
	mv ~/.Hondana/Bookmarks.plist ~/Library/Safari/
	rm -r ~/.Hondana
