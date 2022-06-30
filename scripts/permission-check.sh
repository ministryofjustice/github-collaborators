#!/usr/bin/env bash

if [[ -z $(grep permission terraform/*.tf | sed 's/"//g' | awk '$4 !~ /admin|push|maintain|pull|triage/') ]]
then
    exit 0
else
    echo ERROR: Permission must be Admin, Push, Maintain, Pull or Triage
    exit 1
fi
