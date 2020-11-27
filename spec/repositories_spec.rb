describe GithubCollaborators::Repositories do
  let(:params) { {
    login: "myorg",
    graphql: graphql
  } }

  let(:json) { File.read("spec/fixtures/repositories.json") }
  let(:repositories) { # Defined in spec/fixtures/repositories.json
    ["government-digital-strategy", "archived-repo", "locked-repo", "disabled-repo", "bba"]
  }
  let(:current_repos) {
    ["government-digital-strategy", "bba"]
  }

  let(:graphql) { double(GithubGraphQlClient, run_query: json) }

  let(:repos) { described_class.new(params) }

  it "lists repositories" do
    expect(repos.list.map(&:name).sort).to eq(repositories.sort)
  end

  it "lists current repositories" do
    expect(repos.current.map(&:name).sort).to eq(current_repos.sort)
  end
end
