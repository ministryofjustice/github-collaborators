class GithubCollaborators
  describe HttpClient do
    let(:params) { {} }

    subject(:hc) { described_class.new(params) }

    context "when params is empty" do
      it "gets token from env var." do
        expect(ENV).to receive(:fetch).with("ADMIN_GITHUB_TOKEN").and_return("wibble")
        expect(hc.token).to eq("wibble")
      end
    end

    context "when a token is provided" do
      let(:params) { {token: "foobar"} }

      it "gets token from params" do
        expect(hc.token).to eq("foobar")
      end
    end
  end
end

