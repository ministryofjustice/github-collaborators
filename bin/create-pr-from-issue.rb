#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

# Grab GitHub token
token = ENV.fetch("ADMIN_GITHUB_TOKEN")

# GitHub settings
owner = "ministryofjustice"
repository = "github-collaborators"

# Returns block needed to insert into a collaborator file
# Pass it the infomation needed for such, see example at:
# https://github.com/ministryofjustice/github-collaborators/blob/main/terraform/yjaf-auth.tf
def return_insert(gh_user, perm, name, email, org, reason, added_by, review_after)
    <<~EOF
    \s\s\s\s{
        \s\sgithub_user  = "#{gh_user}"
        \s\spermission   = "#{perm}"
        \s\sname         = "#{name}"         
        \s\semail        = "#{email}"        
        \s\sorg          = "#{org}"          
        \s\sreason       = "#{reason}"       
        \s\sadded_by     = "#{added_by}"     
        \s\sreview_after = "#{review_after}" 
    \s\s\s\s},
    EOF
end

# Creates a branch and commits all changed files
# This probably deserves its own class but keeping it here for now until we need more major functionality in this area
def create_branch_for_pr
    # Init local Git
    g = Git.open(".")
  
    g.config("user.name", "Operations Engineering Bot")
    g.config("user.email", "dummy@email.com")
  
    # Generate random uuid for branch name
    branch_name = UUIDTools::UUID.timestamp_create.to_s
  
    # Create branch and checkout
    g.branch(branch_name).create
    g.checkout(branch_name)
  
    # Stage file
    g.add(paths = "terraform/*")
  
    # Commit
    g.commit("Pull request to add new collaborators")
  
    # Push
    g.push(
      remote = g.remote("origin"),
      branch = branch_name
    )
  
    # Cleanup
    g.checkout("main")
  
    # Return branch name for PR creation
    branch_name
end

# Returns string for PR body
def pull_hash(branch)
    {
        title: "External Collaborator PR",
        head: branch,
        base: "main",
        body: <<~EOF
        Hi there
        
        Please merge this pull request to add the attached external collaborators to GitHub.
        
        If you have any questions, please post in #ask-operations-engineering on Slack.
        EOF
    }
    end

# Util function to deal with Terraform . limitations
def tf_safe(string)
    string.tr(".", "-").strip
end

# Creates a hash of arrays with field: [0] value
# From a GitHub issues reponse created from an issue template
# Example:
# username: Array (1 element)
#   [0]: 'al-ben
# repositories: Array (4 elements)
#   [0]: 'repo1'
#   [1]: 'repo2'
def create_field_array(issue_response)
    Hash[issue_response
            # Fetch the body var and split on field seperator
            .fetch("body").split("###")
            # Remove empty lines
            .map { |line| line.strip }.map { |str| str.gsub /^$\n/, '' }
            # Split on \n characters to have field name and field value in seperator hash
            .map { |line| line.split("\n") }
            # Drop first hash element as not needed
            .drop(1)
            # Map values into array
            .map { |field| [field[0], field.drop(1)] }]
end

# Grab needed data from GitHub Actions payload
issue_json = JSON.parse(ENV.fetch("ISSUE"))

# Grab issue fields from GitHub Actions payload
fields = create_field_array(issue_json)

# For each repo
fields["repositories"].each { |repo| 

    # Read the file into array
    puts "Reading filename: terraform/#{tf_safe(repo)}.tf"
    file = File.read("terraform/#{tf_safe(repo)}.tf")
            .split("\n")
    
    # Create what we need to insert
    insert = return_insert(
                gh_user = fields["username"][0],
                permission = fields["permission"][0],
                email = fields["email"][0],
                name = fields["name"][0],
                org = fields["org"][0],
                reason = fields["reason"][0],
                added_by = fields["added_by"][0],
                review_after = fields["review_after"][0]
            )

    # Insert new collaborators into file array
    file.insert((file.length) - 2, insert)
    
    # Write file
    File.open("terraform/#{tf_safe(repo)}.tf", "w") { 
        |f| f.puts(file)  
    }
}

# At this point the required files have been changed and a PR needs to be opened
# PR Section

# Create branch and open PR
branch_name = create_branch_for_pr
url = "https://api.github.com/repos/#{owner}/#{repository}/pulls"
HttpClient.new.post_json(url, pull_hash(branch_name).to_json)
