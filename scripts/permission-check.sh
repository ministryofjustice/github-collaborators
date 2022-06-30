#!/usr/bin/env bash

if [ -z $(grep permission *.tf | awk '{ print $4 }' | sed 's/"//g' | awk -e '$NF !~ /admin/ || /pull/ || /triage/ || /push/ || /maintain/') ]
then
    exit 0
else
    exit 1
fi