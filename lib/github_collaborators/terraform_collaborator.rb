# Given a repository name and a github login, return all the collaborator
# metadata specified in the terraform source code.
#
# NB: The terraform statefile only contains the parameters used by
# the `github_repository_collaborator` module, which omits all the metadata
# that describes the collaboration. That's the data we want here, which is why
# we go to the terraform source to get it.
class GithubCollaborators
  class TerraformCollaborator
    attr_reader :repository, :login, :base_url

    TERRAFORM_DIR = "terraform"

    PASS = "pass"
    FAIL = "fail"

    REQUIRED_ATTRIBUTES = {
      "name" => "Collaborator name is missing",
      "email" => "Collaborator email is missing",
      "org" => "Collaborator organisation is missing",
      "reason" => "Collaborator reason is missing",
      "added_by" => "Person who added this collaborator is missing",
      "review_after" => "Collaboration review date is missing"
    }

    YEAR = 365
    MONTH = 31
    WEEK = 7

    def initialize(params)
      @repository = params.fetch(:repository)
      @login = params.fetch(:login)
      @terraform_dir = params.fetch(:terraform_dir, TERRAFORM_DIR)
      # Enable the terraform source to be passed in, to make it easier to test the code
      @tfsource = params.fetch(:tfsource) { fetch_terraform_source }
      @base_url = params.fetch(:base_url) # URL of the github UI page listing all the terraform files
    end

    def exists?
      collaborator_source != nil
    end

    def status
      issues.any? ? FAIL : PASS
    end

    def issues
      return ["Collaborator not defined in terraform"] unless exists?

      rtn = REQUIRED_ATTRIBUTES.map { |attr, msg| msg if get_value(attr).nil? }.compact
      unless review_after.nil?
        if review_after < Date.today
          rtn << "Review after date has passed"
        elsif review_after > (Date.today + YEAR)
          rtn << "Review after date is more than a year in the future"
        elsif (Date.today + MONTH) > review_after
          rtn << "Review after date is within a month"
        elsif (Date.today + WEEK) > review_after
          rtn << "Review after date is within a week"
        end
      end
      rtn
    end

    def to_hash
      {
        "repository" => repository,
        "login" => login,
        "status" => status,
        "issues" => issues,
        "href" => href,
        "defined_in_terraform" => exists?
      }
    end

    def name
      get_value("name")
    end

    def email
      get_value("email")
    end

    def org
      get_value("org")
    end

    def reason
      get_value("reason")
    end

    def added_by
      get_value("added_by")
    end

    def review_after
      str = get_value("review_after")
      str.nil? ? nil : Date.parse(str)
    rescue Date::Error
      nil
    end

    def href
      filename = fetch_terraform_source.nil? ? "" : "#{GithubCollaborators.tf_safe(repository)}.tf"
      [base_url, filename].join("/")
    end

    private

    def fetch_terraform_source
      source_file = "#{GithubCollaborators.tf_safe(repository)}.tf"
      filename = File.join(@terraform_dir, source_file)
      FileTest.exists?(filename) ? File.read(filename) : nil
    end

    # Extract the lines of the terraform source which define this specific collaborator
    def collaborator_source
      return nil if @tfsource.nil?

      @str ||= begin
        # extract all the "collaborators" lines from the terraform source
        lines = @tfsource.split("\n").each_with_object([]) { |line, arr| arr << line if (line =~ / collaborators =/) .. (line =~ /]/); } # rubocop:disable Lint/FlipFlop

        # break into individual collaborator string chunks (plus some trailing junk)
        collabs = lines.join("\n").split("}")

        # pull out the block (string) with the collaborator we want
        collabs.grep(/github_user.*#{login}/).first
      end
    end

    def get_value(val)
      collaborator_source.split("\n").grep(/#{val}\s+=/).each do |line|
        if m = /#{val}.*"([^"]+?)"/.match(line) # rubocop:disable Lint/AssignmentInCondition
          return m[1]
        end
      end
      nil
    end
  end

  # Most of the functionality within this class is file based
  # Unlike the GithubCollaborator functionality which can be pointed else where
  # If you wish to use this elsewhere, the code must be copied to the repo with
  # The target terraform/*.tf files
  class TerraformCollaborators
    attr_reader :base_url

    TERRAFORM_DIR = "terraform"

    def initialize(params)
      @terraform_dir = params.fetch(:terraform_dir, TERRAFORM_DIR)
      # Location of the Terraform folder containing collaborators
      @base_url = params.fetch(:base_url)
    end

    # This function returns the collaborators from a tf file as an array of TerraformCollaborator (singular class)
    # file_name: string
    def return_collaborators_from_file(file_name)
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
            arr.push(
              GithubCollaborators::TerraformCollaborator.new(
                repository: repo,
                login: user,
                base_url: @base_url
              )
            )
          end
        end
      end
    end

    private

    # Return absolute paths for every .tf file in the terraform directory
    def fetch_terraform_files
      Dir["#{@terraform_dir}/*.tf"]
    end
  end
end
