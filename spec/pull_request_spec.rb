class GithubCollaborators
  describe PullRequest do
    let(:json) { File.read("spec/fixtures/pull-request.json") }

    subject(:pullrequest) { described_class.new(JSON.parse(json)) }

    specify { expect(pullrequest.number).to eq(290) }
    specify { expect(pullrequest.title).to eq("This is a test PR") }
    specify { expect(pullrequest.file).to eq("terraform/myfile.tf") }
  end
end
