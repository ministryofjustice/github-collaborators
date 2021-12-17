#!/bin/bash

# email_domains=( $( git diff -U0 --diff-filter=ACMRT ${{ github.event.pull_request.base.sha }} ${{ github.sha }} | grep '+      added_by' | grep -EFiEio '\b@[a-z0-9A-Z.]+.[a-z0-9A-Z]{2,4}\b' | xargs ) )

# Search the merge diff for the added_by line and record the email addresses
email_domains=( $( git diff -U0 | grep '+      added_by' | grep -EFiEio '@\b[a-z0-9A-Z.]+.[a-z0-9A-Z]{2,4}\b' | xargs ) )

# If no modified added_by lines then exit
if [ ${#email_domains[@]} == 0 ]; then
    exit 0
else
    emails_detected=0
    echo "Checking user email domains"
    # Loop through the discovered email addresses
    for email_domain in "${email_domains[@]}"
    do
        # Check the email domain is the expected type
        if [ "$email_domain" = "@digital.justice.gov.uk" ]; then
            # echo "correct email domain found @digital.justice.gov.uk"
            emails_detected=$(($emails_detected+1))
        else
            # Check the other expected email domain has been used
            if [ "$email_domain" = "@justice.gov.uk" ]; then
                # echo "correct email domain found @justice.gov.uk"
                emails_detected=$(($emails_detected+1))
            else
                echo "Error: The expected email domains @digital.justice.gov.uk or @justice.gov.uk have not been used!"
                echo "User has used \" ${email_domain} \""
                exit 1
            fi
        fi
    done
    # This is used to catch any special symbols that are missed by the grep which leads to a false positive result
    if [ $(($emails_detected % 2 )) != "0" ]; then
        echo "Error: Within a .tf file on the added_by line there is an issue with the email domain. It is not @digital.justice.gov.uk or @justice.gov.uk."
        exit 1
    fi
fi
