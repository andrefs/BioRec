#!/bin/bash

rm -rf files/sets/*
rm -rf files/uploads/*

sqlite3 bipi.db 'delete from paper;'
sqlite3 bipi.db 'delete from paper_set;'
sqlite3 bipi.db 'delete from pset;'

sqlite3 etc/theschwartz.sqlt 'delete from job;'
