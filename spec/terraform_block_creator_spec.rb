class GithubCollaborators
  describe TerraformBlockCreator do
    let(:params) {
      {
        repository: "somerepo",
        pull_file: "myfile",
        branch: "mybranch"
      }
    }

    let(:json) { File.read("spec/fixtures/issue.json") }

    subject(:tbc) { described_class.new(JSON.parse(json)) }

    # Check object is created correctly
    specify { expect(tbc.username).to eq("ben1") }
    specify { expect(tbc.name).to eq("ben2 ben") }
    specify { expect(tbc.email).to eq("ben3@ben.com") }
    specify { expect(tbc.org).to eq("ben4") }
    specify { expect(tbc.reason).to eq("ben5") }
    specify { expect(tbc.added_by).to eq("ben6 ben") }
    specify { expect(tbc.review_after).to eq("2022-10-10") }
    specify { expect(tbc.repositories).to eq(["ben1", "ben2"]) }
  end
end
