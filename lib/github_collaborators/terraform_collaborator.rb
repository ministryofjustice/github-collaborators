# Given a repository name and a github login, return all the collaborator
# metadata specified in the terraform source code.
#
# NB: The terraform statefile only contains the parameters used by
# the `github_repository_collaborator` module, which omits all the metadata
# that describes the collaboration. That's the data we want here, which is why
# we go to the terraform source to get it.
class GithubCollaborators
  class TerraformCollaborator
    attr_reader :repository, :login

    TERRAFORM_DIR = "terraform"

    GREEN = "green"
    AMBER = "amber"
    RED = "red"

    REQUIRED_ATTRIBUTES = {
      "name" => "Collaborator name is missing",
      "email" => "Collaborator email is missing",
      "org" => "Collaborator organisation is missing",
      "reason" => "Collaborator reason is missing",
      "added_by" => "Person who added this collaborator is missing",
      "review_after" => "Collaboration review date is missing",
    }

    def initialize(params)
      @repository = params.fetch(:repository)
      @login = params.fetch(:login)
      @terraform_dir = params.fetch(:terraform_dir, TERRAFORM_DIR)
      # Enable the terraform source to be passed in, to make it easier to test the code
      @tfsource = params.fetch(:tfsource) { fetch_terraform_source }
    end

    def exists?
      collaborator_source != nil
    end

    def status
      issues.any? ? RED : GREEN
    end

    def issues
      REQUIRED_ATTRIBUTES.map { |attr, msg| msg if get_value(attr).nil? }.compact
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

    private

    def fetch_terraform_source
      filename = "#{GithubCollaborators.tf_safe(repository)}.tf"
      File.read(File.join(@terraform_dir, filename))
    end

    # Extract the lines of the terraform source which define this specific collaborator
    def collaborator_source
      @str ||= begin
                 # extract all the "collaborators" lines from the terraform source
                 lines = @tfsource.split("\n").inject([]) { |arr, line| arr << line if (line =~ / collaborators =/) .. (line =~ /]/); arr }

                 # break into individual collaborator string chunks (plus some trailing junk)
                 collabs = lines.join("\n").split("}")

                 # pull out the block (string) with the collaborator we want
                 collabs.grep(/github_user.*#{login}/).first
               end
    end

    def get_value(val)
      if m = /#{val}.*"([^"]+)"$/.match(collaborator_source)
        m[1]
      else
        nil
      end
    end
  end
end
