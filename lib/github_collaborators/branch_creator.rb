class GithubCollaborators
  class BranchCreator
    include Logging

    def initialize
      logger.debug "initialize"
      @g = Git.open(".")
      @files_for_testing = []
    end

    def create_branch(branch_name)
      logger.debug "create_branch"
      branch_name = branch_name.downcase
      if ENV.fetch("REALLY_POST_TO_GH", 0) == "1"
        @branch_name = branch_name
        @g.config("user.name", "Operations Engineering Bot")
        @g.config("user.email", "github-actions[bot]@users.noreply.github.com")
        @g.checkout(branch_name, new_branch: true, start_point: "main")
      else
        logger.debug "Didn't create git branch #{branch_name}, this is a dry run"
      end
    end

    def add(files)
      logger.debug "add"
      if ENV.fetch("REALLY_POST_TO_GH", 0) == "1"
        @g.add(files)
      else
        @files_for_testing.push(files)
        logger.debug "Didn't add files to git #{files}, this is a dry run"
      end
    end

    def commit_and_push(commit_message)
      logger.debug "commit_and_push"
      if ENV.fetch("REALLY_POST_TO_GH", 0) == "1"
        @g.commit(commit_message)
        @g.push(@g.remote("origin"), @branch_name)

        # Cleanup
        @g.checkout("main")
        sleep 4
      else
        # Revert any changed files
        @files_for_testing.each do |file_name|
          system("git checkout #{file_name}")
          system("git clean -f")
        end
        logger.debug "Didn't commit and push files to github, this is a dry run"
      end
    end

    # Check remote branches, create a new branch name if already taken
    def check_branch_name_is_valid(branch_name, collaborator_name)
      logger.debug "check_branch_is_valid"

      branch_name = branch_name.downcase

      # Step through all the remote branches
      @g.fetch
      remote_branches = @g.branches.remote
      remote_branches.each do |remote_branch|
        if remote_branch.name.downcase == branch_name
          # The branch name already exists

          # Search for any numbers in collaborator name and branch name
          number_in_branch_name = remote_branch.name.scan(/\d+/).last
          number_in_collaborator_name = collaborator_name.scan(/\d+/).last

          if number_in_branch_name.nil?
            # The branch name has no number in the name
            # Add a new number to end of the branch name
            new_branch_name = add_post_fix_number(branch_name, remote_branches)
            return new_branch_name.downcase
          end

          if number_in_collaborator_name.nil?
            # The branch name has a number at the end, collaborator name does not
            # Increment number in branch name
            new_branch_name = increment_post_fix_number(branch_name, remote_branches, number_in_branch_name)
            return new_branch_name.downcase
          end

          if number_in_branch_name.to_i == number_in_collaborator_name.to_i
            # The branch name and collaborator name have the same number in them
            # This can be confused as the branch name number
            # Add a post fix number after the collaborators name
            new_branch_name = add_post_fix_number(branch_name, remote_branches)
            return new_branch_name.downcase
          end

          if number_in_branch_name.to_i != number_in_collaborator_name.to_i
            # The branch name and collaborator name different numbers in them
            # Increment the post fix number after the collaborators name
            new_branch_name = increment_post_fix_number(branch_name, remote_branches, number_in_branch_name)
            return new_branch_name.downcase
          end
        end
      end
      branch_name
    end

    private

    def branch_name_exist(new_name, remote_branches)
      logger.debug "branch_name_exist"
      remote_branches.each do |remote_branch|
        if remote_branch.name.downcase == new_name.downcase
          return true
        end
      end
      false
    end

    def add_post_fix_number(branch_name, remote_branches)
      logger.debug "add_post_fix_number"
      new_post_fix_number = 0
      new_branch_name = ""
      loop do
        new_post_fix_number += 1
        new_branch_name = branch_name.downcase + "-" + new_post_fix_number.to_s
        break unless branch_name_exist(new_branch_name.downcase, remote_branches)
      end
      new_branch_name.downcase
    end

    def increment_post_fix_number(branch_name, remote_branches, number_in_branch_name)
      logger.debug "increment_post_fix_number"
      length = number_in_branch_name.length
      new_post_fix_number = 0
      new_branch_name = branch_name.downcase
      loop do
        new_post_fix_number += 1
        new_branch_name[-length..] = new_post_fix_number.to_s
        break unless branch_name_exist(new_branch_name.downcase, remote_branches)
      end
      new_branch_name.downcase
    end
  end
end
