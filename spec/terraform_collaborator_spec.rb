describe GithubCollaborators::TerraformCollaborator do
  let(:matthewtansini) {
    <<EOF
    {
      github_user  = "matthewtansini"
      permission   = "push"
      name         = "Matthew Tansini"
      email        = "matt.tans@not.real.email"
      org          = "MoJ"
      reason       = "A really good reason"
      added_by     = "David Salgado <david.salgado@digital.justice.gov.uk>"
      review_after = "2021-03-01"
    },
EOF
  }

  let(:detailsmissing) {
    <<EOF
    {
      github_user  = "DangerDawson"
      permission   = "push"
      name         = ""
      email        = ""
      org          = ""
      reason       = ""
      added_by     = ""
      review_after = ""
    },
EOF
  }

  let(:malformed_date) {
    <<EOF
    {
      github_user  = "malformeddate"
      review_after = "Not specified"
    },
EOF
  }

  let(:tfsource) {
    <<EOF
module "acronyms" {
  source     = "./modules/repository-collaborators"
  repository = "acronyms"
  collaborators = [
#{matthewtansini}
#{detailsmissing}
#{malformed_date}
  ]
}
EOF
  }

  let(:repository) { "acronyms" }

  let(:params) { {
    repository: repository,
    login: login,
    tfsource: tfsource,
  } }

  subject(:tc) { described_class.new(params) }

  context "when all details are present" do
    let(:login) { "matthewtansini" }

    specify { expect(tc.exists?).to be(true) }

    it "gets details from terraform" do
      expect(tc.name).to eq("Matthew Tansini")
      expect(tc.email).to eq("matt.tans@not.real.email")
      expect(tc.org).to eq("MoJ")
      expect(tc.reason).to eq("A really good reason")
      expect(tc.added_by).to eq("David Salgado <david.salgado@digital.justice.gov.uk>")
      expect(tc.review_after).to eq(Date.parse("2021-03-01"))
    end
  end

  context "when details are missing" do
    let(:login) { "DangerDawson" }

    specify { expect(tc.exists?).to be(true) }

    it "returns nil" do
      expect(tc.name).to be_nil
      expect(tc.email).to be_nil
      expect(tc.org).to be_nil
      expect(tc.reason).to be_nil
      expect(tc.added_by).to be_nil
      expect(tc.review_after).to be_nil
    end
  end

  context "when no such collaborator" do
    let(:login) { "not-a-collaborator" }

    specify { expect(tc.exists?).to be(false) }
  end

  context "when date is malformed" do
    let(:login) { "malformeddate" }

    it "returns nil" do
      expect(tc.review_after).to be_nil
    end
  end

  # TODO: collaborator is valid or not.....
end

