class GithubCollaborators
  describe GithubCollaborators::OrganizationMembers do
    let(:graphql_client) { double(GithubCollaborators::GithubGraphQlClient) }

    context "when env var missing" do
      it "catch error" do
        expect { GithubCollaborators::OrganizationMembers.new }.to raise_error(KeyError)
      end
    end

    context "when env var set" do
      before do
        ENV["ADMIN_GITHUB_TOKEN"] = ""
      end

      json_data = %(
        {
          organization(login: "ministryofjustice") {
            membersWithRole(first: 100 ) {
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
        organization_member = GithubCollaborators::OrganizationMembers.new
        expect(organization_member.org_members.length).to eq(2)
        expect(organization_member.org_members[0].login).to eq("someuser1")
        expect(organization_member.org_members[1].login).to eq("someuser2")
      end

      after do
        ENV.delete("ADMIN_GITHUB_TOKEN")
      end
    end
  end
end
