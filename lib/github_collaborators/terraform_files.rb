# The GithubCollaborators class namespace
class GithubCollaborators
  # The TerraformBlock class
  class TerraformBlock
    include Logging
    include HelperModule
    include Constants

    attr_reader :username, :permission, :reason, :added_by, :review_after, :email, :name, :org
    attr_writer :review_after

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

    # Add collaborator name to the TerraformBlock. This is called when a
    # collaborator is found on GitHub but not defined in a Terraform file.
    #
    # @param collaborator_name [String] the name of the collaborator
    def add_unknown_collaborator_data(collaborator_name)
      logger.debug "add_unknown_collaborator_data"
      @username = collaborator_name.downcase
      @defined_in_terraform = false
    end

    # Add a email address to collaborator TerraformBlock
    #
    # @param email_address [String] the email address
    def add_collaborator_email_address(email_address)
      logger.debug "add_collaborator_email_address"
      @email = email_address.downcase
    end

    # Add collaborator details to the TerraformBlock. This is called to
    # create TerraformBlocks for the collaborators found in Terraform files.
    #
    # @param collaborator [GithubCollaborators::Collaborator] a collaborator object
    def add_terraform_file_collaborator_data(collaborator)
      logger.debug "add_terraform_file_collaborator_data"
      @username = collaborator.fetch(:login, "").downcase
      @permission = collaborator.fetch(:permission, "")
      @email = collaborator.fetch(:email, "")
      @name = collaborator.fetch(:name, "")
      @org = collaborator.fetch(:org, "")
      @reason = collaborator.fetch(:reason, "")
      @added_by = collaborator.fetch(:added_by, "")
      @review_after = collaborator.fetch(:review_after, "").to_s
    end

    # Overwrite the TerraformBlock with new values. This is called to
    # to revert a modified TerraformBlock back to its original state.
    #
    # @param block [GithubCollaborators::TerraformBlock] a TerraformBlock object
    def revert_block(block)
      logger.debug "revert_block"
      @username = block.username.downcase
      @permission = block.permission
      @reason = block.reason
      @added_by = block.added_by
      @review_after = block.review_after
      @email = block.email
      @name = block.name
      @org = block.org
    end
  end

  # The TerraformFile class
  class TerraformFile
    include Logging
    include HelperModule

    attr_reader :filename

    def initialize(repository_name, folder)
      logger.debug "initialize"
      @filename = repository_name.downcase
      @real_repository_name = repository_name.downcase
      @file_path = "#{folder}/#{tf_safe(@filename)}.tf"

      # A list of TerraformBlock objects that represent
      # the collaborators within the TerraformFile
      @terraform_blocks = []

      # A temporary list of the TerraformBlock objects
      # that have been modified by the App, these objects
      # need to be reverted back to their original state
      # after the App has finished modifying the Terraform
      # file object
      @terraform_modified_blocks = []

      # A temporary list of the TerraformBlock objects
      # that have been removed by the App, these
      # objects need to be added back in after the
      # App has finished modifying the Terraform file object
      @removed_terraform_blocks = []

      # The contents of the Terraform file stored as an array
      @terraform_file_data = []
    end

    # Get the TerraformBlock objects for this file
    #
    # @return [Array<GithubCollaborators::TerraformBlock>] a list of TerraformBlock objects
    def get_terraform_blocks
      logger.debug "get_terraform_blocks"
      @terraform_blocks
    end

    # Revert any modified TerraformBlocks back to their original state
    def revert_terraform_blocks
      logger.debug "revert_terraform_blocks"
      @terraform_modified_blocks.each do |original_block|
        @terraform_blocks.each do |terraform_block|
          if terraform_block.username.downcase == original_block.username.downcase
            terraform_block.revert_block(original_block)
          end
        end
      end
      @terraform_modified_blocks.clear
    end

    # Add a collaborator from an GitHub issue to a
    # TerraformBlock. This is called outside of the
    # App, called by a script in the bin folder.
    #
    # @param collaborator_data [Hash{ login => String, permission => String, name => String, email => String, org => String, reason => String, added_by => String, review_after => String }] the collaborator data
    def add_collaborator_from_issue(collaborator_data)
      logger.debug "add_collaborator_from_issue"
      block = GithubCollaborators::TerraformBlock.new
      block.add_terraform_file_collaborator_data(collaborator_data)
      @terraform_blocks.push(block)
    end

    # Temporarily extend the review date for a specific
    # collaborator within a TerraformBlock object
    #
    # @param collaborator_name [String] the collaborator login name
    def extend_review_date(collaborator_name)
      logger.debug "extend_review_date"
      @terraform_blocks.each do |terraform_block|
        if terraform_block.username.downcase == collaborator_name.downcase
          @terraform_modified_blocks.push(terraform_block.clone)
          terraform_block.review_after = (Date.parse(terraform_block.review_after) + 180).to_s
        end
      end
    end

    # Temporarily remove a TerraformBlock object for a specific collaborator
    #
    # @param collaborator_name [String] the collaborator login name
    def remove_collaborator(collaborator_name)
      logger.debug "remove_collaborator"
      @terraform_blocks.delete_if do |terraform_block|
        if terraform_block.username.downcase == collaborator_name.downcase
          index = @terraform_blocks.index(terraform_block)
          @removed_terraform_blocks.push({removed: true, block: terraform_block.clone, index: index})
          true
        end
      end
    end

    # Restore TerraformBlock objects within the Terraform file
    # back to their original state.
    def restore_terraform_blocks
      logger.debug "restore_terraform_blocks"
      @removed_terraform_blocks.each do |original_block|
        if original_block[:removed]
          @terraform_blocks.insert(original_block[:index], original_block[:block])
        end
      end
      @removed_terraform_blocks.clear
    end

    # Write the TerraformBlock objects to a Terraform file
    def write_to_file
      logger.debug "write_to_file"
      File.write(@file_path, create_file_template)
    end

    # Read the contents of a Terraform file
    def read_file
      logger.debug "read_file"
      if File.exist?(@file_path)
        @terraform_file_data = File.read(@file_path).split("\n")
      else
        logger.error("Read file #{@file_path} does not exist")
      end
    end

    # Return the added_by value in a TerraformBlock object for a specific collaborator
    #
    # @param collaborator_name [String] the collaborator login name
    # @return [String] the added_by value
    def get_collaborator_added_by(collaborator_name)
      logger.debug "get_collaborator_added_by"
      @terraform_blocks.each do |terraform_block|
        if terraform_block.username.downcase == collaborator_name.downcase
          return terraform_block.added_by
        end
      end
      ""
    end

    # Return the repository name from the Terraform file
    #
    # @return [String] the repository name
    def get_repository_name
      logger.debug "get_repository_name"
      # In the file find the "repository" line
      line_number = 0
      initialize_read_file
      name = get_attribute("repository", line_number)
      @real_repository_name = name.downcase
    end

    # For each collaborator in the Terraform file
    # create a TerraformBlock object
    def create_terraform_collaborator_blocks
      logger.debug "create_terraform_collaborator_blocks"
      # In the file find each "github_user" line
      get_github_user_line_numbers.each do |line_number|
        @terraform_blocks.push(get_collaborator_from_file(line_number))
      end
    end

    private

    # Wrapper function to call the function read_file
    # if the Terraform file hasn't been read yet.
    def initialize_read_file
      logger.debug "initialize_read_file"
      if @terraform_file_data.length == 0
        read_file
      end
    end

    # Return each "github_user" line number within the
    # Terraform file.
    #
    # @return [Array<Numeric>] a list of the line numbers
    def get_github_user_line_numbers
      logger.debug "get_github_user_line_numbers"
      github_user_line_numbers = []

      initialize_read_file

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

    # Maps the collaborator fields within a Terraform file
    # into an equivalent TerraformBlock object
    #
    # @param line_number [Numeric] the line number of the collaborator in the Terraform file
    # @return [GithubCollaborators::TerraformBlock] a TerraformBlock object
    def get_collaborator_from_file(line_number)
      logger.debug "get_collaborator_from_file"

      # Get the values from the file based on attribute name
      collaborator_data = REQUIRED_ATTRIBUTES.map { |attr, msg| get_attribute(attr, line_number) }

      collaborator = {
        login: collaborator_data[USERNAME].downcase,
        permission: collaborator_data[PERMISSION],
        name: collaborator_data[NAME],
        email: collaborator_data[EMAIL],
        org: collaborator_data[ORG_LINE],
        reason: collaborator_data[REASON],
        added_by: collaborator_data[ADDED_BY],
        review_after: collaborator_data[REVIEW_AFTER]
      }

      terraform_block = GithubCollaborators::TerraformBlock.new
      terraform_block.add_terraform_file_collaborator_data(collaborator)
      terraform_block
    end

    # Search for the val parameter within a Terraform file that is stored an an array.
    # Use line_number as the start position to find the val value. This checks both
    # the attribute and value exists within the file correctly.
    #
    # @param val [String] the field within the Terraform file to find
    # @param line_number [Numeric] the line number within the Terraform file to start reading from
    # @return [String] the value of the field if it is found, else return an empty string
    def get_attribute(val, line_number)
      logger.debug "get_attribute"

      initialize_read_file

      # Extract the "github_user" to "review_after" lines
      collaborator_block = @terraform_file_data[line_number, (REVIEW_AFTER + 1)]
      collaborator_block.grep(/#{val}\s+=/).each do |line|
        if m = /#{val}.*"([^"]+?)"/.match(line) # rubocop:disable Lint/AssignmentInCondition
          return m[1]
        end
      end
      logger.warn "The attribute #{val} is missing within #{@filename}.tf"
      ""
    end

    # Creates a Terraform file layout. It will dynamically add
    # the collaborators, the module name and the repository name
    #
    # @return [String] a formatted version of the Terraform file
    def create_file_template
      logger.debug "create_file_template"
      module_name = tf_safe(@filename)

      template = <<~EOF
        module "<%= module_name %>" {
          source     = "./modules/repository-collaborators"
          repository = "<%= @real_repository_name %>"
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

  # The TerraformFiles class
  class TerraformFiles
    include Logging
    include HelperModule

    def initialize
      logger.debug "initialize"

      # Array of Terraform file objects
      # [Array<GithubCollaborators::TerraformFile>]
      @terraform_files = []

      # Get then iterator over the Terraform folder Terraform files
      tf_files = fetch_terraform_files
      tf_files.each do |terraform_file_path|
        terraform_file_name = File.basename(terraform_file_path)
        # Ignore the excluded files
        if !EXCLUDE_FILES.include?(terraform_file_name.downcase)
          # Strip away the prefix and file type
          repository_name = File.basename(terraform_file_path, ".tf")
          terraform_file = GithubCollaborators::TerraformFile.new(repository_name.downcase, TERRAFORM_DIR)
          # Read the Terraform file
          terraform_file.read_file
          # Read the real repository name from Terraform file
          terraform_file.get_repository_name
          # Make TerraformBlock objects for each collaborator within the Terraform file
          terraform_file.create_terraform_collaborator_blocks

          @terraform_files.push(terraform_file)
        end
      end

      if ENV.fetch("REALLY_POST_TO_GH", 0) == "1" && tf_files.length == 0
        # 1. Exit the app when posting to GitHub as there should always be Terraform files.
        # 2. This allows the tests to be run.
        logger.error "The TerraformFiles class did not find any Terraform files!"
        exit(1)
      end
    end

    # Temporarily create a new TerraformFile object in memory.
    # There is no actual Terraform file in the Terraform folder
    # at this point. This is to add collaborators to the object
    # later on.
    #
    # @param repository_name [String] the repository name
    def create_new_file_in_memory(repository_name)
      logger.debug "create_new_file_in_memory"
      terraform_file = GithubCollaborators::TerraformFile.new(repository_name.downcase, TERRAFORM_DIR)
      @terraform_files.push(terraform_file)
    end

    # Delete a Terraform file in the Terraform folder
    # and delete the matching TerraformFile object
    #
    # @param file_name [String] the Terraform file name in the Terraform folder
    def remove_file(file_name)
      logger.debug "remove_file"
      path_to_file = "#{TERRAFORM_DIR}/#{file_name.downcase}.tf"
      if File.exist?(path_to_file)
        File.delete(path_to_file)
        @terraform_files.delete_if { |terraform_file| terraform_file.filename.downcase == file_name.downcase }
      end
    end

    # Call the functions to extend the review data for a specific collaborator
    # within a TerraformFile object, then write that Terraform file in the
    # Terraform folder and revert the TerraformFile object back to its original
    # state.
    #
    # @param repository_name [String] the name of the repository to modify
    # @param collaborator_name [String] the collaborator login name
    def extend_date_in_file(repository_name, collaborator_name)
      logger.debug "extend_date_in_file"
      @terraform_files.each do |terraform_file|
        if terraform_file.filename.downcase == tf_safe(repository_name.downcase)
          terraform_file.extend_review_date(collaborator_name.downcase)
          terraform_file.write_to_file
          terraform_file.revert_terraform_blocks
        end
      end
    end

    # Call the functions to remove a specific collaborator from a within
    # a TerraformFile object, then write that Terraform file in the Terraform
    # folder and revert the TerraformFile object back to its original
    # state.
    #
    # @param repository_name [String] the name of the repository to modify
    # @param collaborator_name [String] the collaborator login name
    def remove_collaborator_from_file(repository_name, collaborator_name)
      logger.debug "remove_collaborator_from_file"
      @terraform_files.each do |terraform_file|
        if terraform_file.filename.downcase == tf_safe(repository_name.downcase)
          terraform_file.remove_collaborator(collaborator_name.downcase)
          terraform_file.write_to_file
          terraform_file.restore_terraform_blocks
        end
      end
    end

    # Find which Terraform files have zero TerraformBlock objects
    #
    # @return [Array<String>] the name of the empty Terraform files
    def get_empty_files
      logger.debug "get_empty_files"
      empty_files = []
      @terraform_files.each do |terraform_file|
        terraform_blocks = terraform_file.get_terraform_blocks
        if terraform_blocks.length == 0
          empty_files.push(terraform_file.filename.downcase)
        end
      end
      empty_files
    end

    # Calls the functions to check if a TerraformFile exists for
    # a specific repository then creates a new TerraformFile object
    # if the object doesn't exist already
    #
    # @param repository_name [String] the name of the repository
    def ensure_file_exists_in_memory(repository_name)
      logger.debug "ensure_file_exists_in_memory"
      if does_file_exist(repository_name.downcase) == false
        create_new_file_in_memory(repository_name.downcase)
      end
    end

    # Check if a TerraformFile exists for a specific repository
    #
    # @param repository_name [String] the name of the repository
    # @return [Bool] true if TerraformFile object exists
    def does_file_exist(repository_name)
      logger.debug "does_file_exist"
      @terraform_files.each do |terraform_file|
        if terraform_file.filename.downcase == tf_safe(repository_name.downcase)
          return true
        end
      end
      false
    end

    # Check if a collaborator name is in a Terraform file for a specific repository
    #
    # @param repository_name [String] the name of the repository
    # @param collaborator_name [String] the name of the collaborator
    # @return [Bool] true if collaborator login within the Terraform file
    def is_user_in_file(repository_name, collaborator_name)
      logger.debug "is_user_in_file"
      collaborators_in_file = get_collaborators_in_file(repository_name)
      if collaborators_in_file.include?(collaborator_name)
        return true
      end
      false
    end

    # Returns the collaborator login names of the
    # collaborators within a TerraformFile object
    #
    # @param repository_name [String] the name of the repository
    # @return [Array<String>] the collaborator login names
    def get_collaborators_in_file(repository_name)
      logger.debug "get_collaborators_in_file"
      collaborators_in_file = []
      @terraform_files.each do |terraform_file|
        if terraform_file.filename.downcase == tf_safe(repository_name.downcase)
          terraform_blocks = terraform_file.get_terraform_blocks
          terraform_blocks.each do |block|
            collaborators_in_file.push(block.username.downcase)
          end
        end
      end
      collaborators_in_file
    end

    # Returns a list of TerraformFile objects that represent
    # the Terraform files in the Terraform folder
    #
    # @return [Array<GithubCollaborators::::TerraformFile>] the TerraformFile objects
    def get_terraform_files
      logger.debug "get_terraform_files"
      @terraform_files
    end

    # Return absolute paths for the Terraform files in the Terraform directory
    #
    # @return [Array<String>] a list of file paths to Terraform files
    def fetch_terraform_files
      logger.debug "fetch_terraform_files"
      Dir[TERRAFORM_FILES]
    end
  end
end
