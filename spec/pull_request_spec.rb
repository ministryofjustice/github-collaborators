describe HelperModule do
  # extended class
  let(:helper_module) { Class.new { extend HelperModule } }
  let(:pull_request_json) { File.read("spec/fixtures/pull-request.json") }
  let(:pull_requests_json) { File.read("spec/fixtures/pull-requests.json") }
  let(:http_client) { double(HttpClient) }

  # Stub sleep
  before { allow_any_instance_of(helper_module).to receive(:sleep) }
  before { allow_any_instance_of(GithubCollaborators::HttpClient).to receive(:sleep) }

  # let(:params) {
  #   {
  #     repository: "somerepo",
  #     hash_body: {title: "Remove myfile as repository being deleted", head: "mybranch", base: "main", body: "Hi there\n\nThe repository that is maintained by the file myfile has been deleted/archived\n\nPlease merge this pull request to delete the file.\n\nIf you have any questions, please post in #ask-operations-engineering on Slack.\n"}
  #   }
  # }

  # let(:params) {
  #   {
  #     graphql: graphql
  #   }
  # }

  # let(:json) {
  #   %({"title":"Remove myfile as repository being deleted","head":"mybranch","base":"main","body":"Hi there\\n\\nThe repository that is maintained by the file myfile has been deleted/archived\\n\\nPlease merge this pull request to delete the file.\\n\\nIf you have any questions, please post in #ask-operations-engineering on Slack.\\n"})
  # }

  # subject(:pullrequest) { described_class.new(JSON.parse(json)) }
  # subject(:pullrequests) { described_class.new(params) }
  # subject(:helper_module) { described_class.new(params) }

  # context "when env var enabled" do
  #   before do
  #     allow(graphql).to receive(:run_query).and_return(json)
  #   end

  #   it "calls github api" do
  #     url = "https://api.github.com/repos/ministryofjustice/somerepo/pulls"
  #     expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
  #     expect(http_client).to receive(:post_json).with(url, json)
  #     helper_module.create_pull_request

  #     specify { expect(pullrequest.number).to eq(290) }
  #     specify { expect(pullrequest.title).to eq("This is a test PR") }
  #     specify { expect(pullrequest.file).to eq("terraform/myfile.tf") }
  #     specify { expect(pullrequests.get_pull_requests.size).to eq(10) }
  #   end
  # end
end
