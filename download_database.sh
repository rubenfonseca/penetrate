#!/bin/sh

curl 'http://penetrate.s3.amazonaws.com/database.sqlite3.bz2' | bunzip2 > database.sqlite3

