class GithubCollaborators
  class Branch
    attr_reader :name
    def initialize(branch_name)
      @name = branch_name
    end
  end

  describe BranchCreator do
    before {
      allow_any_instance_of(GithubCollaborators::BranchCreator).to receive(:sleep)
    }

    context "test BranchCreator when env var doesn't exist" do
      before {
        ENV.delete("REALLY_POST_TO_GH")
      }

      it "call create_branch" do
        expect(Git).not_to receive(:config)
        branch_creator = GithubCollaborators::BranchCreator.new
        branch_creator.create_branch("branch")
      end
    end

    context "test BranchCreator when env var does exist" do
      before {
        ENV["REALLY_POST_TO_GH"] = "1"
      }

      it "call add" do
        allow_any_instance_of(Git::Base).to receive(:add)
        branch_creator = GithubCollaborators::BranchCreator.new
        branch_creator.add(["file1", "file2"])
      end

      context " " do
        before {
          allow_any_instance_of(Git).to receive(:config).with("user.name", "Operations Engineering Bot")
          allow_any_instance_of(Git).to receive(:config).with("user.email", "github-actions[bot]@users.noreply.github.com")
          allow_any_instance_of(Git::Base).to receive(:checkout).with("branch", new_branch: true, start_point: "main")
        }

        it "call create_branch" do
          branch_creator = GithubCollaborators::BranchCreator.new
          branch_creator.create_branch("branch")
        end

        it "call commit_and_push" do
          allow_any_instance_of(Git::Base).to receive(:commit).with("commit_message")
          allow_any_instance_of(Git::Base).to receive(:remote).with("origin").and_return("origin")
          allow_any_instance_of(Git::Base).to receive(:push).with("origin", "branch")
          allow_any_instance_of(Git::Base).to receive(:checkout).with("main")
          branch_creator = GithubCollaborators::BranchCreator.new
          branch_creator.create_branch("branch")
          branch_creator.commit_and_push("commit_message")
        end
      end
    end

    context "call check_branch_name_is_valid" do
      context " " do
        before {
          allow_any_instance_of(Git::Base).to receive(:fetch)
        }

        branch_name = "branch-name"
        branch_name1 = "some-branch"
        branch_name2 = "other-branch"

        it "when branch name is valid" do
          branch1 = Branch.new(branch_name1)
          branch2 = Branch.new(branch_name2)
          allow_any_instance_of(Git::Branches).to receive(:remote).and_return([branch1, branch2])
          branch_creator = GithubCollaborators::BranchCreator.new
          test_equal(branch_creator.check_branch_name_is_valid(branch_name, TEST_USER_1), branch_name)
        end

        branch_name1 = "branch_name1"
        branch_name2 = "branch_name2"
        branch_name3 = "branch_name"
        expected_new_branch_name1 = "branch_name-1"
        expected_new_branch_name2 = "branch_name3"
        expected_new_branch_name3 = "branch_name2-1"

        it "when branch name is taken and has no number in it, add a post fix number" do
          branch1 = Branch.new(branch_name1)
          branch2 = Branch.new(branch_name3)
          allow_any_instance_of(Git::Branches).to receive(:remote).and_return([branch1, branch2])
          branch_creator = GithubCollaborators::BranchCreator.new
          new_branch_name = branch_creator.check_branch_name_is_valid(branch_name3, TEST_USER_1)          
          test_equal(new_branch_name, expected_new_branch_name1)
        end

        it "when branch name is taken and has a number in it, increment branch number" do
          branch1 = Branch.new(branch_name1)
          branch2 = Branch.new(branch_name2)
          allow_any_instance_of(Git::Branches).to receive(:remote).and_return([branch1, branch2])
          branch_creator = GithubCollaborators::BranchCreator.new
          new_branch_name = branch_creator.check_branch_name_is_valid(branch_name2, TEST_USER_1)
          test_equal(new_branch_name, expected_new_branch_name2)
        end

        it "when branch name is taken, has a number in it but collaborator name doesn't, increment branch number" do
          branch1 = Branch.new(branch_name1)
          branch2 = Branch.new(branch_name2)
          allow_any_instance_of(Git::Branches).to receive(:remote).and_return([branch1, branch2])
          branch_creator = GithubCollaborators::BranchCreator.new
          new_branch_name = branch_creator.check_branch_name_is_valid(branch_name2, TEST_COLLABORATOR_LOGIN)
          test_equal(new_branch_name, expected_new_branch_name2)
        end

        it "when branch name is taken, branch name and collaborator name have the same number, add a post fix" do
          branch1 = Branch.new(branch_name1)
          branch2 = Branch.new(branch_name2)
          allow_any_instance_of(Git::Branches).to receive(:remote).and_return([branch1, branch2])
          branch_creator = GithubCollaborators::BranchCreator.new
          new_branch_name = branch_creator.check_branch_name_is_valid(branch_name2, TEST_USER_2)
          test_equal(new_branch_name, expected_new_branch_name3)
        end
      end
    end
  end
end
