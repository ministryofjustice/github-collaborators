class GithubCollaborators
  describe HttpClient do

    subject(:hc) { described_class.new }

    context "when token is missing" do
      it "catch error on get" do
        expect { hc.fetch_json("https://api.github.com/repos/ministryofjustice/github-collaborators/issues") }.to raise_error(KeyError)
      end

      it "catch error on post" do
        expect { hc.post_json("https://api.github.com/repos/ministryofjustice/github-collaborators/issues", nil) }.to raise_error(KeyError)
      end

      it "catch error on patch" do
        expect { hc.patch_json("https://api.github.com/repos/ministryofjustice/github-collaborators/issues", nil) }.to raise_error(KeyError)
      end

      it "catch error on delete" do
        expect { hc.delete("https://api.github.com/repos/ministryofjustice/github-collaborators/issues") }.to raise_error(KeyError)
      end
    end

    context "when correct token is provided" do
      before do
        ENV["ADMIN_GITHUB_TOKEN"] = "foobar"
      end

      it "catch error in response" do
        stub_request(:any, "https://api.github.com/repos/ministryofjustice/github-collaborators/issues").to_return(body: "errors", status: 401)
        expect { hc.fetch_json("https://api.github.com/repos/ministryofjustice/github-collaborators/issues") }.to raise_error(SystemExit)
      end

      # Stub sleep
      before { allow_any_instance_of(HttpClient).to receive(:sleep) }

      it "catch rate limited error in response" do
        stub_request(:any, "https://api.github.com/repos/ministryofjustice/github-collaborators/issues").to_return(body: "errors RATE_LIMITED", status: 401)
        expect { hc.fetch_json("https://api.github.com/repos/ministryofjustice/github-collaborators/issues") }.to raise_error(SystemExit)
      end

      it "good response with empty body" do
        stub_request(:get, "https://api.github.com/repos/ministryofjustice/github-collaborators/issues").to_return(body: '' , status: 200)
        hc.fetch_json("https://api.github.com/repos/ministryofjustice/github-collaborators/issues") 
      end

      it "good response with body" do
        stub_request(:get, "https://api.github.com/repos/ministryofjustice/github-collaborators/issues").to_return(body: "abc", status: 200)
        hc.fetch_json("https://api.github.com/repos/ministryofjustice/github-collaborators/issues") 
      end
    end
  end
end
