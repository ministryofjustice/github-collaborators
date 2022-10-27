class GithubCollaborators
  class BranchCreator

    include Logging

    def initialize()
      logger.debug "initialize"
      @g = Git.open(".")
    end

    def create_branch(branch_name)
      logger.debug "create_branch"
      @branch_name = branch_name
      @g.config("user.name", "Operations Engineering Bot")
      @g.config("user.email", "dummy@email.com")
      @g.branch(branch_name).create
      @g.checkout(branch_name)
    end

    def add(files)
      logger.debug "add"
      @g.add(files)
    end

    def remove(files)
      logger.debug "remove"
      @g.remove(files)
    end

    def commit_and_push(commit_message)
      logger.debug "commit_and_push"
      @g.commit(commit_message)
      @g.push(g.remote("origin"), @branch_name)

      # Cleanup
      # TODO: Revert this after testing
      # @g.checkout("main")
      @g.checkout("raise-review-date-pr")
    end
  end
end
