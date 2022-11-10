class GithubCollaborators
  class Collaborator
    include Logging
    attr_reader :repository, :href, :repo_url, :login, :permission, :reason, :added_by, :review_after_date, :email, :name, :org, :issues, :defined_in_terraform

    # collaborator: TerraformBlock object
    def initialize(collaborator, repository_name)
      logger.debug "initialize"

      @login = collaborator.username
      @permission = collaborator.permission
      @email = collaborator.email
      @name = collaborator.name
      @org = collaborator.org
      @reason = collaborator.reason
      @added_by = collaborator.added_by
      @issues = []
      @href = "https://github.com/ministryofjustice/github-collaborators/blob/main/terraform/#{repository_name}.tf"
      @repo_url = "https://github.com/ministryofjustice/#{repository_name}"
      @repository = repository_name
      @defined_in_terraform = true

      @review_after_date = if collaborator.review_after == ""
        ""
      else
        Date.parse(collaborator.review_after)
      end
    end

    YEAR = 365
    MONTH = 31
    WEEK = 7

    def check_for_issues
      logger.debug "check_for_issues"

      if @login == ""
        @issues.push("Collaborator username is missing")
      end

      if @permission == ""
        @issues.push("Collaborator permission is missing")
      end

      if @email == ""
        @issues.push("Collaborator email is missing")
      end

      if @name == ""
        @issues.push("Collaborator name is missing")
      end

      if @org == ""
        @issues.push("Collaborator organisation is missing")
      end

      if @reason == ""
        @issues.push("Collaborator reason is missing")
      end

      if @added_by == ""
        @issues.push("Person who added this collaborator is missing")
      end

      if @review_after_date == ""
        @issues.push("Collaboration review date is missing")
      elsif @review_after_date < Date.today
        @issues.push("Review after date has passed")
      elsif @review_after_date > (Date.today + YEAR)
        @issues.push("Review after date is more than a year in the future")
      elsif (Date.today + WEEK) > @review_after_date
        @issues.push("Review after date is within a week")
      elsif (Date.today + MONTH) > @review_after_date
        @issues.push("Review after date is within a month")
      end
    end

    def add_issue(reason)
      logger.debug ""
      if reason == "missing"
        @issues.push("Collaborator not defined in terraform")
        @defined_in_terraform = false
      end
    end
  end
end
