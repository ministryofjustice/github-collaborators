# Given a repository name and a github login, return all the data for a
# given collaborator specified within the terraform source code.
class GithubCollaborators
  class TerraformCollaborator
    include Logging
    attr_reader :repository, :login, :base_url

    TERRAFORM_DIR = "terraform"
    PASS = "pass"
    FAIL = "fail"
    YEAR = 365
    MONTH = 31
    WEEK = 7
    PERMISSION = 0
    NAME = 1
    EMAIL = 2
    ORG = 3
    REASON = 4
    ADDED_BY = 5
    REVIEW_AFTER = 6

    REQUIRED_ATTRIBUTES = {
      "permission" => "Collaborator permission is missing",
      "name" => "Collaborator name is missing",
      "email" => "Collaborator email is missing",
      "org" => "Collaborator organisation is missing",
      "reason" => "Collaborator reason is missing",
      "added_by" => "Person who added this collaborator is missing",
      "review_after" => "Collaboration review date is missing"
    }

    def initialize(params)
      logger.debug "initialize"
      @repository = params.fetch(:repository, nil)
      @login = params.fetch(:login, nil)
      # URL of the github UI page listing all the terraform files
      @base_url = params.fetch(:base_url, nil)
      @terraform_dir = params.fetch(:terraform_dir, TERRAFORM_DIR)
      @repo_url = params.fetch(:repo_url, nil)
      # Enable the terraform source to be passed in, to make it easier to test the code
      @terraform_data_as_string = params.fetch(:tfsource, nil)
      @collaborator_exist = false
      set_up
    end

    def set_up
      logger.debug "set_up"
      if @terraform_data_as_string.nil?
        @terraform_data_as_string = read_terraform_file
      end
      @terraform_data = extract_collaborators_section
      @issues = check_for_issues
    end

    # The to_hash function returns the below hash structure
    # Example: for multiple collaborators create an array of this class (TerraformCollaborator ie hashes)
    # [
    #   {
    #     "repository"=>"vcms-test-automation",
    #     "login"=>"user-name",
    #     "status"=>"fail",
    #     "issues"=>[
    #       "Review after date is more than a year in the future"
    #     ],
    #     "href"=>"https://github.com/ministryofjustice/github-collaborators/blob/main/terraform/vcms-test-automation.tf",
    #     "defined_in_terraform"=>true,
    #     "review_date"=>"2022-10-10",
    #     "repo_url"=>"https://github.com/ministryofjustice/vcms-test-automation",
    #     "permission"=>"admin"
    #   },
    # ]

    def to_hash
      logger.debug "to_hash"
      {
        "repository" => @repository,
        "login" => @login,
        "issues" => @issues,
        "status" => status,
        "href" => get_href,
        "defined_in_terraform" => @collaborator_exist,
        "review_date" => @review_after_date,
        "repo_url" => @repo_url,
        "permission" => @permission
      }
    end

    def status
      @issues.any? ? FAIL : PASS
    end

    def extend_review_date
      logger.debug "extend_review_date"
      new_review_after_date = @review_after_date + 180
      write_new_date_to_file(new_review_after_date)
    end

    # Remove the collaborator from the current object terraform file
    def remove_collaborator
      logger.debug "remove_collaborator"
      # Split full file contents (as string) into array of line
      current_file = @terraform_data_as_string.split("\n")
      # Find the line for the collaborator
      # Get the line that starts with "{" before "github_user"
      line_to_remove = find_user_name_line_number(current_file) - 1
      # Remove the lines that contain the collaborator data
      remove_lines = 10
      until remove_lines == 0
        current_file.delete_at(line_to_remove)
        remove_lines -= 1
      end
      # Prepare the data and write to file
      new_data = current_file.join("\n")
      file_name = "#{@terraform_dir}/#{@repository}.tf"
      File.open(file_name, "w") { |f|
        f.puts(new_data)
      }
    end

    private

    def get_href
      logger.debug "get_href"
      filename = @terraform_data_as_string.nil? ? "" : "#{GithubCollaborators.tf_safe(repository)}.tf"
      @href = [base_url, filename].join("/")
    end

    def write_new_date_to_file(new_review_after_date)
      logger.debug "write_new_date_to_file"
      # Split full file contents (as string) into array of line
      current_file = @terraform_data_as_string.split("\n")
      # Find the line for the collaborator
      line_number = find_user_name_line_number(current_file)
      # Get the date line based on the collaborator username in the file
      # and offset it by REVIEW_AFTER to get the line with the review_after
      date_line = current_file[line_number + (REVIEW_AFTER + 1)]
      # Overwrite the review_after date
      date_line[22...32] = new_review_after_date.strftime("%Y-%m-%d")
      # Prepare the data and write to file
      new_data = current_file.join("\n")
      file_name = "#{@terraform_dir}/#{@repository}.tf"
      File.open(file_name, "w") { |f|
        f.puts(new_data)
      }
    end

    def exists?
      logger.debug "exists"
      collaborator_exists = does_collaborator_exist?
      if collaborator_exists
        @collaborator_exist = true
      end
      collaborator_exists
    end

    def check_for_issues
      logger.debug "check_for_issues"
      return ["Collaborator not defined in terraform"] unless exists?

      # Check each attribute value is present in the .tf file for this collaborator
      issues = REQUIRED_ATTRIBUTES.map { |attr, msg| msg if get_attribute(attr).nil? }.compact

      retrieve_collaborator_data_from_file(issues)

      # Add a specific issue message regarding the review date
      unless @review_after_date.nil?
        if @review_after_date < Date.today
          issues.push("Review after date has passed")
        elsif @review_after_date > (Date.today + YEAR)
          issues.push("Review after date is more than a year in the future")
        elsif (Date.today + WEEK) > @review_after_date
          issues.push("Review after date is within a week")
        elsif (Date.today + MONTH) > @review_after_date
          issues.push("Review after date is within a month")
        end
      end
      issues
    end

    def read_terraform_file
      logger.debug "read_terraform_file"
      source_file = "#{GithubCollaborators.tf_safe(repository)}.tf"
      filename = File.join(@terraform_dir, source_file)
      FileTest.exists?(filename) ? File.read(filename) : nil
    end

    # extracts all the lines a in terraform file between "collaborators" and "]"
    def extract_collaborators_section
      logger.debug "extract_collaborators_section"
      return nil if @terraform_data_as_string.nil?
      @terraform_data_as_string.split("\n").each_with_object([]) { |line, arr| arr << line if (line =~ / collaborators =/) .. (line =~ /]/); } # rubocop:disable Lint/FlipFlop
    end

    # Search each line of the passed in data to find the collaborators username
    # return the line number where discovered collaborators username
    def find_user_name_line_number(the_data)
      logger.debug "find_user_name_line_number"
      line_number = 0
      the_data.each do |line|
        if line.include?("github_user") && line.include?(@login.to_s)
          return line_number
        end
        line_number += 1
      end
      line_number = 0
    end

    def does_collaborator_exist?
      logger.debug "does_collaborator_exist"
      return false if @terraform_data_as_string.nil?
      @user_line_in_terraform_file = find_user_name_line_number(@terraform_data)
      @user_line_in_terraform_file != 0
    end

    # Retrieves the terraform data for a specific collaborator
    def retrieve_collaborator_data_from_file(issues)
      logger.debug "retrieve_collaborator_data_from_file"
      if issues.length == 0
        # Get the values from the file based on attribute name
        collaborator_data = REQUIRED_ATTRIBUTES.map { |attr, msg| get_attribute(attr) }
        @permission = collaborator_data[PERMISSION]
        @name = collaborator_data[NAME]
        @email = collaborator_data[EMAIL]
        @org = collaborator_data[ORG]
        @reason = collaborator_data[REASON]
        @added_by = collaborator_data[ADDED_BY]
        @review_after_date = if collaborator_data[REVIEW_AFTER].nil? || (collaborator_data[REVIEW_AFTER] == "")
          Date.today
        else
          Date.parse(collaborator_data[REVIEW_AFTER])
        end
      end
    end

    # Search for the val parameter within each line of the collaborator block
    # this checks the attribute and value exists within the file
    def get_attribute(val)
      logger.debug "get_attribute"
      # Use the offset to read from the line containing the collaborator username within the file
      offset = @user_line_in_terraform_file
      collaborator_block = @terraform_data[offset, (offset + REVIEW_AFTER)]
      collaborator_block.grep(/#{val}\s+=/).each do |line|
        if m = /#{val}.*"([^"]+?)"/.match(line) # rubocop:disable Lint/AssignmentInCondition
          return m[1]
        end
      end
      logger.error "The attribute #{val} is missing within #{repository}.tf for #{login}"
      nil
    end
  end

  class TerraformCollaborators
    include Logging
    attr_reader :folder_path

    TERRAFORM_DIR = "terraform"

    def initialize(params)
      logger.debug "initialize"
      @terraform_dir = params.fetch(:terraform_dir, TERRAFORM_DIR)
      @folder_path = params.fetch(:folder_path)
    end

    # Returns all the named collaborators in the terraform files
    def fetch_all_terraform_collaborators
      logger.debug "fetch_all_terraform_collaborators"

      collaborators = []
      exclude_files = ["acronyms.tf", "main.tf", "variables.tf", "versions.tf", "backend.tf"]

      # Go through all the terraform files and get the collaborators
      fetch_terraform_files.each do |terraform_file|
        # Ignore the above named files
        if !exclude_files.include?(File.basename(terraform_file))
          collaborators_in_file = return_collaborators_from_file(terraform_file)
          collaborators_in_file.each { |collaborator| collaborators.push(collaborator.to_hash) }
        end
      end
      collaborators.sort_by { |collaborator| collaborator["login"] }
    end

    private

    # Returns an array of TerraformCollaborator objects
    def return_collaborators_from_file(file_name)
      logger.debug "return_collaborators_from_file"

      # Grab repo name
      repo = file_name[/(?<=#{@terraform_dir}\/)(.*)(?=.tf)/, 1]

      if FileTest.exists?(file_name)
        File.open file_name do |file|
          # Grab each github_user line
          lines = file.find_all { |line| line =~ /\s{4}github_user/ }
          # For each github_user line, grab just the user
          lines.each_with_object([]) do |line, arr|
            # Grab username
            user = /(?<=(["']\b))(?:(?=(\\?))\2.)*?(?=\1)/.match(line)[0]
            # Create TerraformCollaborator and push to arr
            tc = GithubCollaborators::TerraformCollaborator.new(
              repository: repo,
              login: user,
              base_url: @folder_path
            )
            arr.push(tc)
          end
        end
      end
    end

    # Return absolute paths for every .tf file in the terraform directory
    def fetch_terraform_files
      logger.debug "fetch_terraform_files"
      Dir["#{@terraform_dir}/*.tf"]
    end
  end
end
