class GithubCollaborators
  describe OrganizationOutsideCollaborators do
    let(:params) {
      {
        login: "myorg",
        base_url: "https://github.com/ministryofjustice/cloud-platform-report-orphaned-resources"
      }
    }

    let(:org_ext_collabs) { described_class.new(params) }

    let(:org) { double(Organization, is_member?: false) }

    let(:aaa) { double(Repository, name: "aaa", url: "aaa_url") }
    let(:bbb) { double(Repository, name: "bbb", url: "bbb_url") }
    let(:repositories) { double(Repositories, current: [aaa, bbb]) }

    let(:alice) { double(Collaborator, login: "alice", url: "alice_url", permission: "admin", id:"someID") }

    let(:alice_hash) { {login: "alice", login_url: "alice_url", permission: "admin", last_commit: last_commit_date} }
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

    let(:last_commit_date) { "2020-12-24 11:12:13" }

    let(:last_commit) { double(LastCommit, date: last_commit_date) }

    before do
      allow(Repositories).to receive(:new).and_return(repositories)
      allow(RepositoryCollaborators).to receive(:new).and_return(repo_collabs)
      allow(Organization).to receive(:new).and_return(org)
      allow(TerraformCollaborator).to receive(:new).and_return(alice_collab)
      allow(TerraformCollaborator).to receive(:new).and_return(alice_collab)
      allow(LastCommit).to receive(:new).and_return(last_commit)
    end

    it "lists outside collaborators" do
      allow_any_instance_of(IssueClose).to receive_message_chain(:close_expired_issues)
      expect(org_ext_collabs.list).to eq(ext_collabs)
    end

    it "lists outside collaborators for a repo" do
      expect(org_ext_collabs.for_repository("aaa")).to eq([alice_hash])
    end
  end
end
