class GithubCollaborators
  class TerraformBlock
    include Logging
    attr_reader :username, :permission, :reason, :added_by, :review_after, :email, :name, :org
    attr_writer :review_after, :permission

    def initialize
      logger.debug "initialize"
      @username = ""
      @permission = ""
      @email = ""
      @name = ""
      @org = ""
      @reason = ""
      @added_by = ""
      @review_after = ""
      @defined_in_terraform = true
    end

    # This is called when a full org member / collaborator is missing from a Terraform file
    def add_org_member_collaborator_data(collaborator, repository_permission)
      logger.debug "add_org_member_collaborator_data"
      @username = collaborator.login
      @permission = repository_permission
      @email = collaborator.email
      @name = collaborator.name
      @org = collaborator.org
      @reason = "Full Org member / collaborator missing from Terraform file"
      @added_by = "opseng-bot@digital.justice.gov.uk"
      review_date = (Date.today + 90).strftime("%Y-%m-%d")
      @review_after = review_date.to_s
    end

    # This is not used, keeping it, in case create PR's for unknown GitHub collaborators
    # at the moment they are removed automatically and the add_unknown_collaborator_data
    # is used instead.
    def add_missing_collaborator_data(collaborator_name)
      logger.debug "add_missing_collaborator_data"
      @username = collaborator_name.to_s
      @reason = "Collaborator missing from Terraform file"
      @added_by = "opseng-bot@digital.justice.gov.uk"
      review_date = (Date.today + 90).strftime("%Y-%m-%d")
      @review_after = review_date.to_s
      @defined_in_terraform = false
    end

    # This is called when a collaborator is found on GitHub but not defined in a Terraform file
    def add_unknown_collaborator_data(collaborator_name)
      logger.debug "add_unknown_collaborator_data"
      @username = collaborator_name
      @defined_in_terraform = false
    end

    def add_terraform_file_collaborator_data(collaborator)
      logger.debug "add_terraform_file_collaborator_data"
      @username = collaborator.fetch(:login, "")
      @permission = collaborator.fetch(:permission, "")
      @email = collaborator.fetch(:email, "")
      @name = collaborator.fetch(:name, "")
      @org = collaborator.fetch(:org, "")
      @reason = collaborator.fetch(:reason, "")
      @added_by = collaborator.fetch(:added_by, "")
      @review_after = collaborator.fetch(:review_after, "").to_s
    end

    # This functions takes the body generated from a GitHub ticket created from /.github/ISSUE_TEMPLATE/create-pr-from-issue.yaml
    def add_collector_from_issue_data(issue_data)
      logger.debug "add_collector_from_issue_data"
      # Creates a hash of arrays with field: [0] value
      # From a GitHub issues reponse created from an issue template
      # Example:
      # username: Array (1 element)
      #   [0]: 'al-ben
      # repositories: Array (4 elements)
      #   [0]: 'repo1'
      #   [1]: 'repo2'
      the_data = issue_data
        # Fetch the body var and split on field seperator
        .fetch("body").split("###")
        # Remove empty lines
        .map { |line| line.strip }.map { |str| str.gsub(/^$\n/, "") }
        # Split on \n characters to have field name and field value in seperator hash
        .map { |line| line.split("\n") }
        # Drop first hash element as not needed
        .drop(1)
        # Map values into array
        .map { |field| [field[0], field.drop(1)] }.to_h

      @username = the_data["username"][0]
      @permission = the_data["permission"][0]
      @email = the_data["email"][0]
      @name = the_data["name"][0]
      @org = the_data["org"][0]
      @reason = the_data["reason"][0]
      @added_by = the_data["added_by"][0]
      @review_after = the_data["review_after"][0]
      @repositories = the_data["repositories"]
    end

    def copy_block(block)
      logger.debug "copy_block"
      @username = block.username
      @permission = block.permission
      @reason = block.reason
      @added_by = block.added_by
      @review_after = block.review_after
      @email = block.email
      @name = block.name
      @org = block.org
    end
  end

  class TerraformFile
    include Logging
    attr_reader :terraform_blocks, :filename

    def initialize(repository_name)
      logger.debug "initialize"
      @filename = repository_name
      @file_path = "terraform/#{GithubCollaborators.tf_safe(@filename)}.tf"
      @terraform_blocks = []
      @terraform_file_data = []
      @terraform_modified_blocks = []
      @add_removed_terraform_blocks = []
    end

    def revert_terraform_blocks
      logger.debug "revert_terraform_blocks"
      # Revert matching Terraform blocks with the original values
      @terraform_modified_blocks.each do |original_block|
        @terraform_blocks.each do |terraform_block|
          if terraform_block.username == original_block.username
            terraform_block.copy_block(original_block)
          end
        end
      end
      @terraform_modified_blocks.clear
    end

    # This is not used, keeping it, in case
    def add_collaborator(collaborator)
      logger.debug "add_collaborator"
      block = GithubCollaborators::TerraformBlock.new
      block.add_collaborator_data(collaborator)
      @terraform_blocks.push(block)
      @add_removed_terraform_blocks.push({added: true, removed: false, block: terraform_block.clone, index: @terraform_blocks.index(block)})
    end

    def add_org_member_collaborator(collaborator, permission)
      logger.debug "add_org_member_collaborator"
      block = GithubCollaborators::TerraformBlock.new
      block.add_org_member_collaborator_data(collaborator, permission)
      @terraform_blocks.push(block)
      @add_removed_terraform_blocks.push({added: true, removed: false, block: block.clone, index: @terraform_blocks.index(block)})
    end

    def add_collaborators_from_issue(collaborator_data)
      logger.debug "add_collaborators_from_issue"
      block = GithubCollaborators::TerraformBlock.new
      block.add_collector_from_issue_data(collaborator_data)
      @terraform_blocks.push(block)
      @add_removed_terraform_blocks.push({added: true, removed: false, block: block.clone, index: @terraform_blocks.index(block)})
    end

    # Extend the review date for a collaborator within a Terraform file
    def extend_review_date(collaborator_name)
      logger.debug "extend_review_date"
      @terraform_blocks.each do |terraform_block|
        if terraform_block.username == collaborator_name
          @terraform_modified_blocks.push(terraform_block.clone)
          terraform_block.review_after = (Date.parse(terraform_block.review_after) + 180).to_s
        end
      end
    end

    # Remove collaborator from a Terraform file
    def remove_collaborator(collaborator_name)
      logger.debug "remove_collaborator"
      @terraform_blocks.each do |terraform_block|
        if terraform_block.username == collaborator_name
          index = @terraform_blocks.index(terraform_block)
          @add_removed_terraform_blocks.push({added: false, removed: true, block: terraform_block.clone, index: index})
          @terraform_blocks.delete_at(index)
        end
      end
    end

    # Restore Terraform blocks to original state
    def restore_terraform_blocks
      logger.debug "restore_terraform_blocks"
      @add_removed_terraform_blocks.each do |original_block|
        if original_block[:removed]
          @terraform_blocks.insert(original_block[:index], original_block[:block])
        elsif original_block[:added]
          @terraform_blocks.delete_at(original_block[:index])
        end
      end
      @add_removed_terraform_blocks.clear
    end

    # Write Terraform block/s to a single Terraform file
    def write_to_file
      logger.debug "write_to_file"
      File.write(@file_path, create_file_template)
    end

    def read_file
      logger.debug "read_file"
      @terraform_file_data = File.read(@file_path).split("\n")
    end

    def get_collaborator_permission(collaborator_name)
      logger.debug "get_collaborator_permission"
      @terraform_blocks.each do |terraform_block|
        if terraform_block.username == collaborator_name
          return terraform_block.permission
        end
      end
      ""
    end

    def change_collaborator_permission(collaborator_name, permission)
      logger.debug "get_collaborator_permission"
      @terraform_blocks.each do |terraform_block|
        if terraform_block.username == collaborator_name
          @terraform_modified_blocks.push(terraform_block.clone)
          terraform_block.permission = permission
        end
      end
    end

    def create_terraform_collaborator_blocks
      logger.debug "create_terraform_collaborator_blocks"
      # In the file find the "github_user" lines
      get_github_user_line_numbers.each do |line_number|
        # Create a Terraform block for each "github_user"
        @terraform_blocks.push(get_collaborator_from_file(line_number))
      end
    end

    private

    # Search each line for "github_user" and return the line number
    def get_github_user_line_numbers
      logger.debug "get_github_user_line_numbers"
      github_user_line_numbers = []

      # Find the strings that contain "github_user"
      github_users = @terraform_file_data.find_all { |line| line =~ /\s{4}github_user/ }

      # Get the line number for each "github_user"
      github_users.each do |github_user|
        line_number = 0
        @terraform_file_data.each do |line|
          # Find the line
          if line.include?(github_user)
            github_user_line_numbers.push(line_number)
          end
          line_number += 1
        end
      end

      # Return the line numbers that have a "github_user"
      github_user_line_numbers
    end

    REQUIRED_ATTRIBUTES = {
      "github_user" => "Collaborator username is missing",
      "permission" => "Collaborator permission is missing",
      "name" => "Collaborator name is missing",
      "email" => "Collaborator email is missing",
      "org" => "Collaborator organisation is missing",
      "reason" => "Collaborator reason is missing",
      "added_by" => "Person who added this collaborator is missing",
      "review_after" => "Collaboration review date is missing"
    }

    USERNAME = 0
    PERMISSION = 1
    NAME = 2
    EMAIL = 3
    ORG = 4
    REASON = 5
    ADDED_BY = 6
    REVIEW_AFTER = 7

    # Retrieves the Terraform data for a single collaborator based on the
    # line number and returns an equivalent TerraformBlock object
    def get_collaborator_from_file(line_number)
      logger.debug "get_collaborator_from_file"

      # Get the values from the file based on attribute name
      collaborator_data = REQUIRED_ATTRIBUTES.map { |attr, msg| get_attribute(attr, line_number) }

      collaborator = {
        login: collaborator_data[USERNAME],
        permission: collaborator_data[PERMISSION],
        name: collaborator_data[NAME],
        email: collaborator_data[EMAIL],
        org: collaborator_data[ORG],
        reason: collaborator_data[REASON],
        added_by: collaborator_data[ADDED_BY],
        review_after: collaborator_data[REVIEW_AFTER]
      }

      terraform_block = TerraformBlock.new
      terraform_block.add_terraform_file_collaborator_data(collaborator)
      terraform_block
    end

    # Search for the val parameter within a block of data that starts from
    # the line_number start position. This checks both the attribute and
    # value exists within the file
    def get_attribute(val, line_number)
      logger.debug "get_attribute"
      # Extract the "github_user" to "review_after" lines
      collaborator_block = @terraform_file_data[line_number, (REVIEW_AFTER + 1)]
      collaborator_block.grep(/#{val}\s+=/).each do |line|
        if m = /#{val}.*"([^"]+?)"/.match(line) # rubocop:disable Lint/AssignmentInCondition
          return m[1]
        end
      end
      logger.warn "The attribute #{val} is missing within #{@filename}.tf"
      nil
    end

    def create_file_template
      logger.debug "create_file_template"

      template = <<~EOF
        module "<%= @filename %>" {
          source     = "./modules/repository-collaborators"
          repository = "<%= @filename %>"
          collaborators = [
          <% @terraform_blocks.each do |collaborator| %>
          {
              github_user  = "<%= collaborator.username %>"
              permission   = "<%= collaborator.permission %>"
              name         = "<%= collaborator.name %>"
              email        = "<%= collaborator.email %>"
              org          = "<%= collaborator.org %>"
              reason       = "<%= collaborator.reason %>"
              added_by     = "<%= collaborator.added_by %>"
              review_after = "<%= collaborator.review_after %>"
            },
          <% end %>
        ]
        }
      EOF
      renderer = ERB.new(template, trim_mode: ">")
      renderer.result(binding)
    end
  end

  class TerraformFiles
    include Logging
    attr_reader :terraform_files

    def initialize
      logger.debug "initialize"

      # Array Terraform files
      @terraform_files = []
      exclude_files = ["acronyms.tf", "main.tf", "variables.tf", "versions.tf", "backend.tf"]

      # Go through all the Terraform files
      fetch_terraform_files.each do |terraform_file_path|
        terraform_file_name = File.basename(terraform_file_path)
        # Ignore the above named files
        if !exclude_files.include?(terraform_file_name)
          # Strip away prefix and file type
          repository_name = File.basename(terraform_file_path, ".tf")
          terraform_file = GithubCollaborators::TerraformFile.new(repository_name)
          # Read the file
          terraform_file.read_file
          # Make Terraform blocks for each collaborator
          terraform_file.create_terraform_collaborator_blocks
          # Store Terraform file
          @terraform_files.push(terraform_file)
        end
      end
    end

    def create_new_file(repository_name)
      logger.debug "create_new_file"
      terraform_file = GithubCollaborators::TerraformFile.new(repository_name)
      # Store Terraform file
      @terraform_files.push(terraform_file)
    end

    def remove_empty_file(empty_file_name)
      logger.debug "remove_empty_file"
      path_to_file = "terraform/#{empty_file_name}.tf"
      if File.exist?(path_to_file)
        File.delete(path_to_file)
        @terraform_files.delete_if { |terraform_file| terraform_file.filename == empty_file_name }
      end
    end

    def extend_date_in_file(repository_name, login)
      logger.debug "extend_date_in_file"
      @terraform_files.each do |terraform_file|
        if terraform_file.filename == GithubCollaborators.tf_safe(repository_name)
          terraform_file.extend_review_date(login)
          terraform_file.write_to_file
          terraform_file.revert_terraform_blocks
        end
      end
    end

    def remove_collaborator_from_file(repository_name, login)
      logger.debug "remove_collaborator_from_file"
      @terraform_files.each do |terraform_file|
        if terraform_file.filename == GithubCollaborators.tf_safe(repository_name)
          terraform_file.remove_collaborator(login)
          terraform_file.write_to_file
          terraform_file.restore_terraform_blocks
        end
      end
    end

    def change_collaborator_permission_in_file(collaborator_name, repository_name, permission)
      logger.debug "change_collaborator_permission_in_file"
      @terraform_files.each do |terraform_file|
        if terraform_file.filename == GithubCollaborators.tf_safe(repository_name)
          terraform_file.change_collaborator_permission(collaborator_name, permission)
          terraform_file.write_to_file
          terraform_file.revert_terraform_blocks
        end
      end
    end

    def add_collaborator_to_file(collaborator, repository_name, repository_permission)
      logger.debug "add_collaborator_to_file"
      @terraform_files.each do |terraform_file|
        if terraform_file.filename == GithubCollaborators.tf_safe(repository_name)
          terraform_file.add_org_member_collaborator(collaborator, repository_permission)
          terraform_file.write_to_file
          terraform_file.restore_terraform_blocks
        end
      end
    end

    def get_empty_files
      logger.debug "get_empty_files"
      empty_files = []
      @terraform_files.each do |terraform_file|
        if terraform_file.terraform_blocks.length == 0
          empty_files.push(terraform_file.filename)
        end
      end
      empty_files
    end

    def check_file_exists(repository_name)
      logger.debug "check_file_exists"
      file_exists = false
      @terraform_files.each do |terraform_file|
        if terraform_file.filename == GithubCollaborators.tf_safe(repository_name)
          file_exists = true
          break
        end
      end

      if file_exists == false
        # It doesn't so create a new file
        create_new_file(repository_name)
      end
    end

    def get_collaborators_in_file(repository_name)
      logger.debug "get_collaborators_in_file"
      collaborators_in_file = []
      @terraform_files.each do |terraform_file|
        if terraform_file.filename == GithubCollaborators.tf_safe(repository_name)
          terraform_file.terraform_blocks.each do |block|
            collaborators_in_file.push(block.username)
          end
        end
      end
      collaborators_in_file
    end

    private

    # Return absolute paths for the Terraform files in the Terraform directory
    def fetch_terraform_files
      logger.debug "fetch_terraform_files"
      Dir["terraform/*.tf"]
    end
  end
end
