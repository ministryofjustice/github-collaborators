class GithubCollaborators
  describe Repository do
    let(:json) { File.read("spec/fixtures/repository.json") }

    subject(:repo) { described_class.new(JSON.parse(json)) }

    specify { expect(repo.id).to eq("MDEwOlJlcG9zaXRvcnk4MjIyMDg3") }
    specify { expect(repo.name).to eq("courtfinder") }
    specify { expect(repo.url).to eq("https://github.com/ministryofjustice/courtfinder") }
    specify { expect(repo).to_not be_locked }
    specify { expect(repo).to be_archived }
    specify { expect(repo).to_not be_disabled }
  end
end
