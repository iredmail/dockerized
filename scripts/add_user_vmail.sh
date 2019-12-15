#!/bin/sh

addgroup -g 2000 vmail
adduser -D -H -u 2000 -G vmail -s /sbin/nologin vmail
