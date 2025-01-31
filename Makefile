CFLAGS?=	-Wall -ggdb -W -O -I/usr/include/tirpc
CC?=		gcc
LIBS?=      -ltirpc
LDFLAGS?=
PREFIX?=	/usr/local/webbench
VERSION=1.5
TMPDIR=/tmp/webbench-$(VERSION)

all:   webbench tags

tags:  *.c
	-ctags *.c

install: webbench
	install -d $(DESTDIR)$(PREFIX)/bin
	install -s webbench $(DESTDIR)$(PREFIX)/bin
	ln -sf $(DESTDIR)$(PREFIX)/bin/webbench $(DESTDIR)/usr/local/bin/webbench

	install -d $(DESTDIR)/usr/local/man/man1
	install -d $(DESTDIR)$(PREFIX)/man/man1
	install -m 644 webbench.1 $(DESTDIR)$(PREFIX)/man/man1
	ln -sf $(DESTDIR)$(PREFIX)/man/man1/webbench.1 $(DESTDIR)/usr/local/man/man1/webbench.1

	install -d $(DESTDIR)$(PREFIX)/share/doc/webbench
	install -m 644 debian/copyright $(DESTDIR)$(PREFIX)/share/doc/webbench
	install -m 644 debian/changelog $(DESTDIR)$(PREFIX)/share/doc/webbench

webbench: webbench.o Makefile
	$(CC) $(CFLAGS) $(LDFLAGS) -o webbench webbench.o $(LIBS) 

clean:
	-rm -f *.o webbench *~ core *.core tags
	
tar:   clean
	-debian/rules clean
	rm -rf $(TMPDIR)
	install -d $(TMPDIR)
	cp -p Makefile webbench.c socket.c webbench.1 $(TMPDIR)
	install -d $(TMPDIR)/debian
	-cp -p debian/* $(TMPDIR)/debian
	ln -sf debian/copyright $(TMPDIR)/COPYRIGHT
	ln -sf debian/changelog $(TMPDIR)/ChangeLog
	-cd $(TMPDIR) && cd .. && tar cozf webbench-$(VERSION).tar.gz webbench-$(VERSION)

webbench.o:	webbench.c socket.c Makefile

.PHONY: clean install all tar
