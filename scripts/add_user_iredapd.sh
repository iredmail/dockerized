#!/bin/sh

addgroup -g 2002 iredapd
adduser -D -H -u 2002 -G iredapd -s /sbin/nologin iredapd
