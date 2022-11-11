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
        logger.debug "Didn't create git branch #{branch_name}, this is a dry run"
      end
    end

    def add(files)
      logger.debug "add"
      if POST_TO_GH
        @g.add(files)
      else
        logger.debug "Didn't add files to git #{files}, this is a dry run"
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
        logger.debug "Didn't commit and push files to github, this is a dry run"
      end
    end

    # Check remote branches, create a new branch name if already taken
    def check_branch_name_is_valid(branch_name, collaborator_name)
      logger.debug "check_branch_is_valid"

      # Step through all the remote branches
      @g.fetch
      remote_branches = @g.branches.remote
      remote_branches.each do |remote_branch|
        if remote_branch.name == branch_name
          # The branch name already exists
          new_branch_name = branch_name

          number_in_branch_name = remote_branch.name.scan(/\d+/).last
          if number_in_branch_name.nil?
            # The branch name has no number in the name
            # Add a new number to end of the branch name
            new_post_fix_number = 0
            loop do
              new_post_fix_number += 1
              new_branch_name = remote_branch.name + "-" + new_post_fix_number.to_s
              break unless branch_name_exist(new_branch_name, remote_branches)
            end
            return new_branch_name
          end

          number_in_collaborator_name = collaborator_name.scan(/\d+/).last
          if number_in_collaborator_name.nil?
            # The branch name has a number at the end, collaborator name does not.
            # Increment number IN branch name
            length = number_in_branch_name.length
            new_post_fix_number = 0
            loop do
              new_post_fix_number = + 1
              # Replace end digits with new number
              new_branch_name[-length..] = new_post_fix_number.to_s
              break unless branch_name_exist(new_branch_name, remote_branches)
            end
            return new_branch_name
          end

          if number_in_branch_name.to_i == number_in_collaborator_name.to_i
            # The branch name and collaborator name have the same number in them.
            # This can be confused as the branch name number.
            # Add a post fix number after the collaborators name.
            new_post_fix_number = 0
            loop do
              new_post_fix_number += 1
              new_branch_name = remote_branch.name + "-" + new_post_fix_number.to_s
              break unless branch_name_exist(new_branch_name, remote_branches)
            end
            return new_branch_name
          end

          if number_in_branch_name.to_i != number_in_collaborator_name.to_i
            # The branch name and collaborator name different numbers in them.
            # Increment the post fix number
            length = number_in_branch_name.length
            new_post_fix_number = 0
            loop do
              new_post_fix_number += 1
              new_branch_name = remote_branch.name
              new_branch_name[-length..] = new_post_fix_number.to_s
              break unless branch_name_exist(new_branch_name, remote_branches)
            end
            return new_branch_name
          end
        end
      end
    end

    private

    def branch_name_exist(new_name, remote_branches)
      logger.debug "branch_name_exist"
      exists = false
      remote_branches.each do |remote_branch|
        if remote_branch.name == new_name
          exists = true
        end
      end
      exists
    end
  end
end
