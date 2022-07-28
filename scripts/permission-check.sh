#!/usr/bin/env bash

if [[ -z $(grep permission terraform/*.tf | sed 's/"//g' | awk '$4 !~ /admin|push|maintain|pull|triage/') ]]
then
    exit 0
else
    echo ERROR: Permission must be admin, push, maintain, pull or triage
    exit 1
fi
