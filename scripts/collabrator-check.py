#!/usr/bin/env python3

import subprocess
import sys

firstarg=sys.argv[1]
secondarg=sys.argv[2]

# print(firstarg[0:7])
# print(secondarg[0:7])

# Get the merge diff results
ps = subprocess.Popen(('git', 'diff' , '-U0', '--diff-filter=ACMRT', firstarg[0:7], secondarg[0:7]), stdout=subprocess.PIPE)
ps.wait()
if ps.stdout != "":

    try:
        # Look for the added_by line
        grep_output = subprocess.check_output(('grep', '+      added_by'), stdin=ps.stdout, text=True)
        # print(grep_output)
    except:
        print ("Check N/A")
        sys.exit(0)
    else:
        # Count number of changed lines
        changed_lines = grep_output.count('added_by')
        # print("There are ", changed_lines, " changed lines")

        # Count number of email @ symbols
        emails_symbols_found = grep_output.count('@')
        # print("There are ", emails_symbols_found, " @ in the changes")

        digital_justice_emails_found = grep_output.count('@digital.justice.gov.uk')
        # print ("@digital.justice.gov.uk found ", digital_justice_emails_found, " times" )

        justice_emails_found = grep_output.count('@justice.gov.uk')
        # print ("@justice.gov.uk found ", justice_emails_found, " times" )

        if emails_symbols_found == (digital_justice_emails_found + justice_emails_found) :
            if emails_symbols_found == changed_lines:
                print ("Check Passed")
                sys.exit(0)
            else:
                print ("Check Failed: An email is missing in the added_by line of a .tf file")
                sys.exit(1)     
        else:
            print ("Check Failed: The expected email domains that should be used are @digital.justice.gov.uk or @justice.gov.uk")
            sys.exit(1)
else:
    print ("Check N/A")
    sys.exit(0)