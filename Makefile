# Copyright (c) 2001, 2007  Peter Pentchev
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
# $Ringlet$

CC?=		gcc
CFLAGS?=		-O -pipe
LDFLAGS?=
LFLAGS?=	${LDFLAGS}
LIBS?=

RM=		rm -f

PROG=		timelimit
OBJS=		timelimit.o
SRCS=		timelimit.c

MAN8=		timelimit.8
MAN8GZ=		${MAN8}.gz

LOCALBASE?=	/usr/local
PREFIX?=	${LOCALBASE}
BINDIR?=	${PREFIX}/bin
MANDIR?=	${PREFIX}/man/man

BINOWN?=	root
BINGRP?=	wheel
BINMODE?=	555

MANOWN?=	root
MANGRP?=	wheel
MANMODE?=	644

# comment this if you do not have err(3) and errx(3) (most BSD systems do)
CFLAGS+=	-DHAVE_ERR
# comment this if you do not have the sysexits.h header file (most systems do)
CFLAGS+=	-DHAVE_SYSEXITS_H
# comment this if you do not have the errno.h header file (most systems do)
CFLAGS+=	-DHAVE_ERRNO_H
# comment this if you do not have sigaction(2) (most systems do)
CFLAGS+=	-DHAVE_SIGACTION

# development/debugging flags, you may safely ignore them
#CFLAGS+=	${BDECFLAGS}
#CFLAGS+=	-ggdb -g3

all:		${PROG} ${MAN8GZ}

clean:
		${RM} ${PROG} ${OBJS} ${MAN8GZ}

${PROG}:	${OBJS}
		${CC} ${LFLAGS} -o ${PROG} ${OBJS}

timelimit.o:	timelimit.c config.h
		${CC} ${CFLAGS} -c timelimit.c

${MAN8GZ}:	${MAN8}
		gzip -c9 ${MAN8} > ${MAN8GZ}.tmp
		mv ${MAN8GZ}.tmp ${MAN8GZ}

install:	all
		install -c -o ${BINOWN} -g ${BINGRP} -m ${BINMODE} ${PROG} ${DESTDIR}${BINDIR}/
		install -c -o ${MANOWN} -g ${MANGRP} -m ${MANMODE} ${MAN8GZ} ${DESTDIR}${MANDIR}8/
