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
      @g.checkout(branch_name, new_branch: true, start_point: 'main')
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
      @g.push(@g.remote("origin"), @branch_name)

      # Cleanup
      # TODO: Revert this after testing
      # @g.checkout("main")
      @g.checkout("raise-review-date-pr")
    end
    
    # Check remote branches, create a new branch name if already taken
    def check_branch_name_is_valid(branch_name)
      logger.debug "check_branch_is_valid"
      branch_name = branch_name
      # Step through all the remote branches
      @g.fetch
      @g.branches.remote.each do |remote_branch|
        if remote_branch.name == branch_name
          # Branch name already exists
          number_as_string = remote_branch.name.scan(/\d+/).last
          if number_as_string.nil?
            # Branch name has no number in the name
            new_post_fix_number = 1
            # Add new number to end of name
            branch_name = branch_name + "-" + new_post_fix_number.to_s
          else
            # Branch name has a number in the name
            length = number_as_string.length
            number = number_as_string.to_i
            # Increment that number
            new_post_fix_number = number + 1
            # Replace end digits with new number
            branch_name[-length..] = new_post_fix_number.to_s
          end
        end
      end
      branch_name
    end
  end
end
