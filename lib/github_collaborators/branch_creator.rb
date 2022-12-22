# The GithubCollaborators class namespace
class GithubCollaborators
  # The BranchCreator class
  class BranchCreator
    include Logging
    include Constants

    def initialize
      logger.debug "initialize"
      @g = Git.open(".")
      @files_for_testing = []
      @remote_branches = nil
    end

    # Create and switch to a branch using a specific branch name
    #
    # @param branch_name [String] the name of the branch
    def create_branch(branch_name)
      logger.debug "create_branch"
      branch_name = branch_name.downcase
      if ENV.fetch("REALLY_POST_TO_GH", 0) == "1"
        @branch_name = branch_name
        @g.config("user.name", OPS_ENG_BOT_NAME)
        @g.config("user.email", GITHUB_BOT_EMAIL)
        @g.checkout(branch_name, new_branch: true, start_point: "main")
      else
        logger.debug "Didn't create git branch #{branch_name}, this is a dry run"
      end
    end

    # Add a file to the branch
    #
    # @param file_name [String] the name of the file to add
    def add(file_name)
      logger.debug "add"
      if ENV.fetch("REALLY_POST_TO_GH", 0) == "1"
        @g.add(file_name)
      else
        @files_for_testing.push(file_name)
        logger.debug "Didn't add files to git #{file_name}, this is a dry run"
      end
    end

    # Do a Git commit on the branch and push changes to the remote repository
    #
    # @param commit_message [String] the message to use in the Git commit
    def commit_and_push(commit_message)
      logger.debug "commit_and_push"
      if ENV.fetch("REALLY_POST_TO_GH", 0) == "1"
        @g.commit(commit_message)
        @g.push(@g.remote("origin"), @branch_name)

        # Cleanup
        @g.checkout("main")

        sleep 4
      else
        # Testing: revert changed files
        @files_for_testing.each do |file_name|
          system("git checkout #{file_name}")
          system("git clean -f")
        end
        logger.debug "Didn't commit and push files to github, this is a dry run"
      end
    end

    # Check a branch name is valid, if not add a post fix number
    # to the branch name and return the modified value
    #
    # @param branch_name [String] the original name of the branch
    # @param collaborator_name [String] the name of the collaborator
    # @return [String] a valid branch name
    def check_branch_name_is_valid(branch_name, collaborator_name)
      logger.debug "check_branch_is_valid"

      branch_name = branch_name.downcase

      update_remote_branches

      @remote_branches.each do |remote_branch|
        if remote_branch.name.downcase == branch_name
          # The branch name already exists

          # Search for any numbers in collaborator name and branch name
          number_in_branch_name = remote_branch.name.scan(/\d+/).last
          number_in_collaborator_name = collaborator_name.scan(/\d+/).last

          if number_in_branch_name.nil?
            # The branch name has no number in the name
            # Add a new number to end of the branch name
            new_branch_name = add_post_fix_number(branch_name)
            return new_branch_name.downcase
          end

          if number_in_collaborator_name.nil?
            # The branch name has a number at the end, collaborator name does not
            # Increment number in branch name
            new_branch_name = increment_post_fix_number(branch_name, number_in_branch_name)
            return new_branch_name.downcase
          end

          if number_in_branch_name.to_i == number_in_collaborator_name.to_i
            # The branch name and collaborator name have the same number in them
            # This can be confused as the branch name number
            # Add a post fix number after the collaborators name
            new_branch_name = add_post_fix_number(branch_name)
            return new_branch_name.downcase
          end

          if number_in_branch_name.to_i != number_in_collaborator_name.to_i
            # The branch name and collaborator name different numbers in them
            # Increment the post fix number after the collaborators name
            new_branch_name = increment_post_fix_number(branch_name, number_in_branch_name)
            return new_branch_name.downcase
          end
        end
      end
      branch_name
    end

    private

    # See if the new branch name already exists on the
    # remote repository or not
    #
    # @param new_branch_name [String] the new branch name
    # @return [Bool] true if branch name is already taken
    def branch_name_exist(new_branch_name)
      logger.debug "branch_name_exist"
      @remote_branches.each do |remote_branch|
        if remote_branch.name.downcase == new_branch_name.downcase
          return true
        end
      end
      false
    end

    # Add a post fix to the branch name
    #
    # @param branch_name [String] the original branch name
    # @return [String] the modified branch name
    def add_post_fix_number(branch_name)
      logger.debug "add_post_fix_number"
      new_post_fix_number = 0
      new_branch_name = ""
      # Keep adding a post fix to branch name until find a name that is free to use
      loop do
        new_post_fix_number += 1
        new_branch_name = branch_name.downcase + "-" + new_post_fix_number.to_s
        break unless branch_name_exist(new_branch_name.downcase)
      end
      new_branch_name.downcase
    end

    # Increment the number of a post fix already applied to a branch name
    #
    # @param branch_name [String] the original branch name
    # @param number_in_branch_name [Numeric] the number to start from
    # @return [String] the modified branch name
    def increment_post_fix_number(branch_name, number_in_branch_name)
      logger.debug "increment_post_fix_number"
      length = number_in_branch_name.length
      new_post_fix_number = 0
      new_branch_name = branch_name.downcase
      # Keep incrementing the post fix number in the branch name until find a name that is free to use
      loop do
        new_post_fix_number += 1
        new_branch_name[-length..] = new_post_fix_number.to_s
        break unless branch_name_exist(new_branch_name.downcase)
      end
      new_branch_name.downcase
    end

    # Get latest branches from the remote repository
    #
    def update_remote_branches
      logger.debug "update_remote_branches"
      @g.fetch
      @remote_branches = @g.branches.remote
    end
  end
end
