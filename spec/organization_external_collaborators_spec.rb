class GithubCollaborators
  describe OrganizationOutsideCollaborators do
    let(:params) {
      {
        login: "myorg",
        base_url: "https://github.com/ministryofjustice/cloud-platform-report-orphaned-resources"
      }
    }

    let(:org_outside_collabs) { described_class.new(params) }

    let(:org) { double(Organization, is_member?: false) }

    let(:aaa) { double(Repository, name: "aaa", url: "aaa_url") }
    let(:bbb) { double(Repository, name: "bbb", url: "bbb_url") }
    let(:repositories) { double(Repositories, current: [aaa, bbb]) }

    let(:alice) { double(Collaborator, login: "alice", url: "alice_url", permission: "admin") }

    let(:alice_hash) { {login: "alice", login_url: "alice_url", permission: "admin"} }
    let(:alice_collab) { double(TerraformCollaborator, to_hash: alice_hash, status: "fail") }

    let(:repo_collabs) { double(RepositoryCollaborators, list: [alice]) }

    let(:aaa_collab) {
      alice_collab.merge(repository: "aaa", repo_url: "aaa_url")
    }

    let(:ext_collabs) {
      [
        alice_hash.merge(repo_url: "aaa_url"),
        alice_hash.merge(repo_url: "bbb_url")
      ]
    }

    before do
      allow(Repositories).to receive(:new).and_return(repositories)
      allow(RepositoryCollaborators).to receive(:new).and_return(repo_collabs)
      allow(Organization).to receive(:new).and_return(org)
      allow(TerraformCollaborator).to receive(:new).and_return(alice_collab)
    end

    it "lists outside collaborators" do
      allow_any_instance_of(IssueClose).to receive_message_chain(:close_expired_issues)
      expect(org_outside_collabs.fetch_collaborators_with_issues).to eq(ext_collabs)
    end

    it "lists outside collaborators for a repo" do
      expect(org_outside_collabs.fetch_repository_collaborators("aaa")).to eq([alice_hash])
    end
  end
end
