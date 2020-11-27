describe GithubCollaborators::Organization do
  let(:params) { {
    login: "myorg",
    graphql: graphql
  } }

  let(:json) { File.read("spec/fixtures/members.json") }
  let(:logins) { # Defined in spec/fixtures/members.json
    ["Floppy", "SteveMarshall", "digitalronin", "solidgoldpig"]
  }

  let(:graphql) { double(GithubGraphQlClient, run_query: json) }

  let(:org) { described_class.new(params) }

  it "lists members" do
    expect(org.members.map(&:login).sort).to eq(logins)
  end

  it "confirms membership" do
    expect(org.is_member?("SteveMarshall")).to be(true)
  end

  it "confirms non-membership" do
    expect(org.is_member?("l33thax0r")).to be(false)
  end
end
