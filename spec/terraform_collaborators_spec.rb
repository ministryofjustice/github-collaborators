class TerraformCollaborators
  describe GithubCollaborators::TerraformCollaborators do
    let(:tf) { String("spec/fixtures/terraform-bindings.tf") }
    let(:collaborators) {
      ["bendashton", "beno"]
    }

    subject {
      described_class.new(
        base_url: "https://github.com/ministryofjustice/github-collaborators/blob/main/terraform",
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
