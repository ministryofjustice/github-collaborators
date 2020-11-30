describe GithubCollaborators::OrganizationExternalCollaborators do
  let(:params) {
    {
      login: "myorg"
    }
  }

  let(:org_ext_collabs) { described_class.new(params) }

  let(:org) { double(GithubCollaborators::Organization, is_member?: false) }

  let(:aaa) { double(GithubCollaborators::Repository, name: "aaa", url: "aaa_url") }
  let(:bbb) { double(GithubCollaborators::Repository, name: "bbb", url: "bbb_url") }
  let(:repositories) { double(GithubCollaborators::Repositories, current: [aaa, bbb]) }

  let(:alice) { double(GithubCollaborators::Collaborator, login: "alice", url: "alice_url", permission: "admin") }

  let(:alice_hash) { {login: "alice", login_url: "alice_url", permission: "admin"} }
  let(:alice_collab) { double(GithubCollaborators::TerraformCollaborator, to_hash: alice_hash, status: "fail") }

  let(:repo_collabs) { double(GithubCollaborators::RepositoryCollaborators, list: [alice]) }

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
    allow(GithubCollaborators::Repositories).to receive(:new).and_return(repositories)
    allow(GithubCollaborators::RepositoryCollaborators).to receive(:new).and_return(repo_collabs)
    allow(GithubCollaborators::Organization).to receive(:new).and_return(org)
    allow(GithubCollaborators::TerraformCollaborator).to receive(:new).and_return(alice_collab)
    allow(GithubCollaborators::TerraformCollaborator).to receive(:new).and_return(alice_collab)
  end

  it "lists external collaborators" do
    expect(org_ext_collabs.list).to eq(ext_collabs)
  end

  it "lists external collaborators for a repo" do
    expect(org_ext_collabs.for_repository("aaa")).to eq([alice_hash])
  end
end
