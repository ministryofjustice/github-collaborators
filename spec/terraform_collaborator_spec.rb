describe GithubCollaborators::TerraformCollaborator do
  let(:tfsource) {
    <<EOF
module "acronyms" {
  source     = "./modules/repository-collaborators"
  repository = "acronyms"
  collaborators = [
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
  ]
}
EOF
  }

  let(:repository) { "acronyms" }
  let(:login) { "matthewtansini" }

  let(:params) { {
    repository: repository,
    login: login,
    tfsource: tfsource,
  } }

  subject(:tc) { described_class.new(params) }

  it "gets details from terraform" do
    expect(tc.name).to eq("Matthew Tansini")
    expect(tc.email).to eq("matt.tans@not.real.email")
    expect(tc.org).to eq("MoJ")
    expect(tc.reason).to eq("A really good reason")
    expect(tc.added_by).to eq("David Salgado <david.salgado@digital.justice.gov.uk>")
    expect(tc.review_after).to eq(Date.parse("2021-03-01"))
  end

  # login is not present
  # name (or whatever) is missing
  # date is malformed
end

