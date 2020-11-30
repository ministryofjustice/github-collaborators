describe GithubCollaborators::TerraformCollaborator do
  let(:review_date) { (Date.today + 30).strftime("%Y-%m-%d") }

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
      review_after = "#{review_date}"
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
      expect(tc.review_after).to eq(Date.parse(review_date))
    end

    it "has green status" do
      expect(tc.status).to eq("green")
    end

    it "has no issues" do
      expect(tc.issues).to eq([])
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

    it "has red status" do
      expect(tc.status).to eq("red")
    end

    it "has issues" do
      expected = [
        "Collaborator name is missing",
        "Collaborator email is missing",
        "Collaborator organisation is missing",
        "Collaborator reason is missing",
        "Person who added this collaborator is missing",
        "Collaboration review date is missing",
      ].sort

      expect(tc.issues.sort).to eq(expected)
    end
  end

  context "when no such collaborator" do
    let(:login) { "not-a-collaborator" }

    specify { expect(tc.exists?).to be(false) }

    it "has red status" do
      expect(tc.status).to eq("red")
    end
  end

  context "when date is malformed" do
    let(:login) { "malformeddate" }

    it "returns nil" do
      expect(tc.review_after).to be_nil
    end

    it "has red status" do
      expect(tc.status).to eq("red")
    end
  end
end

