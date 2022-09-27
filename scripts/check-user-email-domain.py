#!/usr/bin/env python3

import subprocess
import sys

base_git_sha = sys.argv[1]
branch_git_sha = sys.argv[2]

# Get the merge diff results using the git sha of the base branch and the new branch. The filter checks for files that have
# been added, modified, etc and filters out deleted changes. It will put the result into a pipe to be used with grep below.
ps = subprocess.Popen(('git', 'diff', '-U0', '--diff-filter=ACMRT',
                      base_git_sha[0:7], branch_git_sha[0:7]), stdout=subprocess.PIPE)
ps.wait()
# The diff will return a string value if there were changes.
if ps.stdout != "":
    # Need a try exception block here because grep returns a negative result if it doesn't find the expected value.
    try:
        # Look for the 'added_by' line in the diff results
        grep_output = subprocess.check_output(
            ('grep', '+      added_by'), stdin=ps.stdout, text=True)
    except:
        # Grep didn't find an 'added_by' line, check finished.
        print("Check N/A")
        sys.exit(0)
    else:

        print(grep_output)

        # Some .tf files have this comment, so remove it at the start of the check
        grep_output = grep_output.replace(
            "awesome.team@digital.justice.gov.uk", "abc")

        # Count the number of email @ symbols in the diff output
        num_email_symbols = grep_output.count('@')
        # print("There are ", num_email_symbols, " @ in the changes")

        # The check for no email symbols
        if num_email_symbols == 0:
            print("Check Failed: No email domains discovered in the 'added_by' line of a .tf file. Expected @digital.justice.gov.uk or @justice.gov.uk")
            sys.exit(1)

        # Count the number of 'digital.justice.gov.uk' email domains
        digital_justice_emails_found = grep_output.count(
            '@digital.justice.gov.uk')
        # print ("@digital.justice.gov.uk found ", digital_justice_emails_found, " times" )

        # Count the number of 'justice.gov.uk' email domains
        justice_emails_found = grep_output.count('@justice.gov.uk')
        # print ("@justice.gov.uk found ", justice_emails_found, " times" )

        # Ensure the number of discovered expected email addresses matches the number of discovered email symbols
        if num_email_symbols != (digital_justice_emails_found + justice_emails_found):
            print("Check Failed: The expected email domains that should be used in the 'added_by' line of a .tf file are @digital.justice.gov.uk or @justice.gov.uk")
            sys.exit(1)

        # Count the number of added_by lines
        num_changed_lines = grep_output.count('added_by')
        # print("There are ", num_changed_lines, " changed lines")

        # Ensure the number of changed lines matches the number of discovered email symbols
        if num_changed_lines != (digital_justice_emails_found + justice_emails_found):
            print("Check Failed: There is a missing email domain on the 'added_by' line of a .tf file. Expected @digital.justice.gov.uk or @justice.gov.uk")
            sys.exit(1)

        # Check finished.
        print("Check Passed")
        sys.exit(0)
else:
    # No git diff result, check finished.
    print("Check N/A")
    sys.exit(0)
