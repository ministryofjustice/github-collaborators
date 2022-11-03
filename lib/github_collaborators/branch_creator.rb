class GithubCollaborators
  class BranchCreator
    include Logging
    POST_TO_GH = ENV.fetch("REALLY_POST_TO_GH", 0) == "1"

    def initialize
      logger.debug "initialize"
      @g = Git.open(".")
    end

    def create_branch(branch_name)
      logger.debug "create_branch"
      if POST_TO_GH
        @branch_name = branch_name
        @g.config("user.name", "Operations Engineering Bot")
        @g.config("user.email", "dummy@email.com")
        @g.checkout(branch_name, new_branch: true, start_point: "main")
      else
        logger.debug "Didnt create git branch #{branch_name}, this is a dry run"
      end
    end

    def add(files)
      logger.debug "add"
      if POST_TO_GH
        @g.add(files)
      else
        logger.debug "Didnt add files to git #{files}, this is a dry run"
      end
    end

    def remove(files)
      logger.debug "remove"
      if POST_TO_GH
        @g.remove(files)
      else
        logger.debug "Didnt remove files from git #{files}, this is a dry run"
      end
    end

    def commit_and_push(commit_message)
      logger.debug "commit_and_push"
      if POST_TO_GH
        @g.commit(commit_message)
        @g.push(@g.remote("origin"), @branch_name)
  
        # Cleanup
        @g.checkout("main")
        sleep 4
      else
        logger.debug "Didnt commit and push files to github, this is a dry run"
      end
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
