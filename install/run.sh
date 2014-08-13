#!/bin/sh
service mysql start
service postfix start
#trick to keep daemon running (is there a better way?):
tail -f /var/log/*
