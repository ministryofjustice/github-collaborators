# The GithubCollaborators class namespace
class GithubCollaborators
  # The Collaborator class
  class Collaborator
    include Logging
    include Constants
    attr_reader :repository, :href, :repo_url, :login, :permission, :reason, :added_by, :review_after_date, :email, :name, :org, :issues, :defined_in_terraform

    # collaborator: TerraformBlock object
    def initialize(collaborator, repository_name)
      logger.debug "initialize"

      repository_name = repository_name.downcase
      @login = collaborator.username.downcase
      @permission = collaborator.permission
      @email = collaborator.email
      @name = collaborator.name
      @org = collaborator.org
      @reason = collaborator.reason
      @added_by = collaborator.added_by
      @issues = []
      @href = "#{GH_ORG_URL}/#{REPO_NAME}/blob/main/terraform/#{repository_name}.tf"
      @repo_url = "#{GH_ORG_URL}/#{repository_name}"
      @repository = repository_name
      @defined_in_terraform = true

      @review_after_date = if collaborator.review_after == ""
        ""
      else
        Date.parse(collaborator.review_after)
      end
    end

    # Check if any Terraform file fields are missing and if the review date has an issue
    #
    # @return [Array<String>] a list of found issues
    def check_for_issues
      logger.debug "check_for_issues"

      if @login == ""
        @issues.push(USERNAME_MISSING)
      end

      if @permission == ""
        @issues.push(PERMISSION_MISSING)
      end

      if @email == ""
        @issues.push(EMAIL_MISSING)
      end

      if @name == ""
        @issues.push(NAME_MISSING)
      end

      if @org == ""
        @issues.push(ORGANISATION_MISSING)
      end

      if @reason == ""
        @issues.push(REASON_MISSING)
      end

      if @added_by == ""
        @issues.push(ADDED_BY_MISSING)
      end

      if @review_after_date == ""
        @issues.push(REVIEW_DATE_MISSING)
      elsif @review_after_date < Date.today
        @issues.push(REVIEW_DATE_PASSED)
      elsif @review_after_date > (Date.today + YEAR)
        @issues.push(REVIEW_DATE_TO_LONG)
      elsif (Date.today + WEEK) > @review_after_date
        @issues.push(REVIEW_DATE_EXPIRES_SOON)
      elsif (Date.today + MONTH) > @review_after_date
        @issues.push(REVIEW_DATE_WITHIN_MONTH)
      end
      @issues
    end

    # Add a custom issue to the collaborator
    #
    # @param reason [String] the type of issue
    def add_issue(reason)
      logger.debug ""
      if reason == MISSING
        # This issue occurs when collaborator is defined on GitHub
        # but not defined in a Terraform file
        @issues.push(COLLABORATOR_MISSING)
        @defined_in_terraform = false
      end
    end
  end
end
