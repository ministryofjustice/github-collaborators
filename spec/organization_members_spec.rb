describe HelperModule do
  # extended class
  let(:helper_module) { Class.new { extend HelperModule } }
  let(:graphql_client) { double(GithubCollaborators::GithubGraphQlClient) }

  json_data = %(
      {
        organization(login: "ministryofjustice") {
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

  it "create collaborators where no pagination" do
    return_data = File.read("spec/fixtures/organisation-members.json")
    expect(GithubCollaborators::GithubGraphQlClient).to receive(:new).and_return(graphql_client)
    expect(graphql_client).to receive(:run_query).with(json_data).and_return(return_data)
    organization_members = helper_module.get_all_organisation_members
    expect(organization_members.length).to eq(2)
    expect(organization_members).to eq([TEST_USER_1, TEST_USER_2])
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

  it "when no collaborators exist" do
    expect(GithubCollaborators::GithubGraphQlClient).to receive(:new).and_return(graphql_client)
    expect(graphql_client).to receive(:run_query).with(json_data).and_return(json_data_no_collaborators)
    organization_members = helper_module.get_all_organisation_members
    expect(organization_members.length).to eq(0)
  end
end
