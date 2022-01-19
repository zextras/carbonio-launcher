# SPDX-FileCopyrightText: 2022 Zextras <https://www.zextras.com>
#
# SPDX-License-Identifier: GPL-2.0-only

# Build mailboxd launcher and manager process.  Note that paths you
# specify here must not be owned in the install by less privileged
# user who could then hijack this launcher binary.  The defaults are
# bad bad bad, as those symlinks might not be owned by root.

SRC     = src

BUILD   = build

BUILD_ROOT := $(shell pwd)

all: $(BUILD) $(BUILD)/zmmailboxdmgr $(BUILD)/zmmailboxdmgr.unrestricted

$(BUILD):
	mkdir $(BUILD)

JAVA_BINARY ?= /opt/zextras/common/bin/java
MAILBOXD_MANAGER_PIDFILE ?= /opt/zextras/log/zmmailboxd_manager.pid
MAILBOXD_MANAGER_DEPRECATED_PIDFILE ?= /opt/zextras/log/zmmailboxd.pid
MAILBOXD_JAVA_PIDFILE ?= /opt/zextras/log/zmmailboxd_java.pid
MAILBOXD_CWD ?= /opt/zextras/log
JETTY_BASE ?= /opt/zextras/mailboxd
JETTY_HOME ?= /opt/zextras/common/jetty_home
MAILBOXD_OUTFILE ?= /opt/zextras/log/zmmailboxd.out
GC_OUTFILE ?= /opt/zextras/log/gc.log
ZIMBRA_LIB ?= /opt/zextras/lib
ZIMBRA_USER ?= zextras
ZIMBRA_CONFIG ?= /opt/zextras/conf/localconfig.xml

LAUNCHER_CFLAGS = \
	-DJAVA_BINARY='"$(JAVA_BINARY)"' \
	-DMAILBOXD_MANAGER_PIDFILE='"$(MAILBOXD_MANAGER_PIDFILE)"' \
	-DMAILBOXD_MANAGER_DEPRECATED_PIDFILE='"$(MAILBOXD_MANAGER_DEPRECATED_PIDFILE)"' \
	-DMAILBOXD_JAVA_PIDFILE='"$(MAILBOXD_JAVA_PIDFILE)"' \
	-DMAILBOXD_CWD='"$(MAILBOXD_CWD)"' \
	-DJETTY_BASE='"$(JETTY_BASE)"' \
	-DJETTY_HOME='"$(JETTY_HOME)"' \
	-DMAILBOXD_OUTFILE='"$(MAILBOXD_OUTFILE)"' \
	-DGC_OUTFILE='"$(GC_OUTFILE)"' \
	-DZIMBRA_LIB='"$(ZIMBRA_LIB)"' \
	-DZIMBRA_USER='"$(ZIMBRA_USER)"' \
	-DZIMBRA_CONFIG='"$(ZIMBRA_CONFIG)"'

ifeq ($(ZIMBRA_USE_TOMCAT), 1)
LAUNCHER_CFLAGS += -DZIMBRA_USE_TOMCAT=1
endif

$(BUILD)/zmmailboxdmgr: $(SRC)/launcher/zmmailboxdmgr.c
	gcc $(MACDEF) $(LAUNCHER_CFLAGS) -g -Wall -Wmissing-prototypes -o $@ $<

$(BUILD)/zmmailboxdmgr.unrestricted: $(SRC)/launcher/zmmailboxdmgr.c
	gcc $(MACDEF) $(LAUNCHER_CFLAGS) -DUNRESTRICTED_JVM_ARGS -Wall -Wmissing-prototypes -o $@ $<

#
# Clean
#
clean:
	$(RM) -r $(BUILD)

FORCE: ;

