class GithubCollaborators
  describe TerraformCollaborator do
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
      <<~EOF
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

    let(:params) {
      {
        repository: repository,
        login: login,
        tfsource: tfsource
      }
    }

    subject(:tc) { described_class.new(params) }

    context "when there is no terraform source file" do
      let(:params) {
        {
          repository: "no-such-sourc-code-file-exists",
          login: "whatever"
        }
      }

      it "has fail status" do
        expect(tc.status).to eq("fail")
      end

      it "has an issue" do
        expect(tc.issues).to eq(["Collaborator not defined in terraform"])
      end

      it "links to the terraform directory" do
        expect(tc.href).to eq("https://github.com/ministryofjustice/operations-engineering-github-collaborators/blob/main/terraform/")
      end
    end

    context "when review date is too far ahead" do
      let(:login) { "matthewtansini" }
      let(:review_date) { (Date.today + 500).strftime("%Y-%m-%d") }

      it "has fail status" do
        expect(tc.status).to eq("fail")
      end

      it "has an issue" do
        expect(tc.issues).to eq(["Review after date is more than a year in the future"])
      end
    end

    context "when review date has passed" do
      let(:login) { "matthewtansini" }
      let(:review_date) { (Date.today - 10).strftime("%Y-%m-%d") }

      it "has fail status" do
        expect(tc.status).to eq("fail")
      end

      it "has an issue" do
        expect(tc.issues).to eq(["Review after date has passed"])
      end
    end

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

      it "has pass status" do
        expect(tc.status).to eq("pass")
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

      it "has fail status" do
        expect(tc.status).to eq("fail")
      end

      it "has issues" do
        expected = [
          "Collaborator name is missing",
          "Collaborator email is missing",
          "Collaborator organisation is missing",
          "Collaborator reason is missing",
          "Person who added this collaborator is missing",
          "Collaboration review date is missing"
        ].sort

        expect(tc.issues.sort).to eq(expected)
      end

      it "renders as a hash" do
        expected = {
          "repository" => "acronyms",
          "login" => "DangerDawson",
          "status" => "fail",
          "href" => "https://github.com/ministryofjustice/operations-engineering-github-collaborators/blob/main/terraform/acronyms.tf",
          "issues" => [
            "Collaborator name is missing",
            "Collaborator email is missing",
            "Collaborator organisation is missing",
            "Collaborator reason is missing",
            "Person who added this collaborator is missing",
            "Collaboration review date is missing"
          ]
        }

        expect(tc.to_hash).to eq(expected)
      end
    end

    context "when no such collaborator" do
      let(:login) { "not-a-collaborator" }

      specify { expect(tc.exists?).to be(false) }

      it "has fail status" do
        expect(tc.status).to eq("fail")
      end

      it "has an issue" do
        expect(tc.issues).to eq(["Collaborator not defined in terraform"])
      end
    end

    context "when date is malformed" do
      let(:login) { "malformeddate" }

      it "returns nil" do
        expect(tc.review_after).to be_nil
      end

      it "has fail status" do
        expect(tc.status).to eq("fail")
      end
    end
  end
end
