class GithubCollaborators
  include TestConstants
  include Constants

  describe HelperModule do
    let(:helper_module) { Class.new { extend HelperModule } }
    let(:graphql_client) { double(GithubCollaborators::GithubGraphQlClient) }

    json_data = %(
      {
        organization(login: "#{ORG}") {
          membersWithRole(
            first: 100
            after: null
          ) {
            edges {
              node {
                login
              }
            }
            pageInfo {
              hasNextPage
              endCursor
            }
          }
        }
      }
    )

    before do
      expect(GithubCollaborators::GithubGraphQlClient).to receive(:new).and_return(graphql_client)
    end

    it "call get_all_organisation_members when create collaborators where no pagination" do
      return_data = File.read("spec/fixtures/organisation-members.json")
      expect(graphql_client).to receive(:run_query).with(json_data).and_return(return_data)
      organization_members = helper_module.get_all_organisation_members
      test_equal(organization_members.length, 2)
      test_equal(organization_members, [TEST_USER_1, TEST_USER_2])
    end

    json_data_no_collaborators =
      %(
    {
      "data": {
        "organization": {
          "membersWithRole": {
            "pageInfo": {
              "hasNextPage": false,
              "endCursor": null
            },
            "edges": []
          }
        }
      }
    }
  )

    it "call get_all_organisation_members when no collaborators exist" do
      expect(graphql_client).to receive(:run_query).with(json_data).and_return(json_data_no_collaborators)
      organization_members = helper_module.get_all_organisation_members
      test_equal(organization_members.length, 0)
    end
  end
end
