class TerraformCollaborators
  describe GithubCollaborators::OutsideCollaborators do
    # TODO: Remove after re-write test
    before { skip }

    let(:tf) { String("spec/fixtures/terraform-bindings.tf") }
    let(:collaborators) {
      ["bendashton", "beno"]
    }

    subject {
      described_class.new(
        folder_path: "https://github.com/ministryofjustice/github-collaborators/blob/main/terraform",
        terraform_dir: "spec/fixtures"
      )
    }

    it "returns type of Array<TerraformCollaborator>" do
      expect(subject.return_collaborators_from_file(tf)
        .all? { |x| x.is_a?(GithubCollaborators::TerraformCollaborator) })
        .to be true
    end

    it "returns two collaborators" do
      expect(subject.return_collaborators_from_file(tf).length).to eq(2)
    end

    it "returns the correct collaborators" do
      expect(
        subject.return_collaborators_from_file(tf).map(&:login).sort
      ).to eq(collaborators)
    end
  end
end
