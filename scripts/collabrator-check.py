#!/usr/bin/env python3

import subprocess
import sys

# email_domains=( $( git diff -U0 --diff-filter=ACMRT ${{ github.event.pull_request.base.sha }} ${{ github.sha }} | grep '+      added_by' | grep -EFiEio '\b@[a-z0-9A-Z.]+.[a-z0-9A-Z]{2,4}\b' | xargs ) )

# Get the merge diff results
ps = subprocess.Popen(('git', 'diff' , '-U0', '--diff-filter=ACMRT', '$\{\{ github.event.pull_request.base.sha \}\}', '$\{\{ github.sha \}\}' ), stdout=subprocess.PIPE)
ps.wait()
if ps.stdout != "":
    # Look for the added_by line
    grep_output = subprocess.check_output(('grep', '+      added_by'), stdin=ps.stdout, text=True)

    # Count number of email @ symbols
    emails_symbols_found = grep_output.count('@')
    # print("There are ", emails_symbols_found, " @ in the changes")

    digital_justice_emails_found = grep_output.count('@digital.justice.gov.uk')
    # print ("@digital.justice.gov.uk found ", digital_justice_emails_found, " times" )

    justice_emails_found = grep_output.count('@justice.gov.uk')
    # print ("@justice.gov.uk found ", justice_emails_found, " times" )

    if emails_symbols_found == (digital_justice_emails_found + justice_emails_found) :
        # print ("Pass")
        sys.exit(0)
    else:
        # print ("Fail")
        sys.exit(1)
else:
    sys.exit(0)