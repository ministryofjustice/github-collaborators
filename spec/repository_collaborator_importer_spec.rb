# class GithubCollaborators
#   describe RepositoryCollaborators do
#     # TODO: Remove after re-write test
#     before { skip }

#     let(:executor) { double(Executor, run: "") }
#     let(:logger) { double(Logger, warn: nil) }
#     let(:collabs) {
#       [
#         {login: #{TEST_USER}, permission: "admin"}
#       ]
#     }
#     let(:oec) { double(OrganizationOutsideCollaborators, fetch_repository_collaborators: collabs) }

#     let(:params) {
#       {
#         terraform_dir: "spec/tmp",
#         terraform_executable: "/bin/terraform",
#         org_outside_collabs: oec,
#         executor: executor,
#         logger: logger
#       }
#     }

#     let(:rci) { described_class.new(params) }

#     before do
#       allow(Kernel).to receive(:warn).and_return(nil)
#       system("rm spec/tmp/* 2>/dev/null")
#     end

#     after do
#       system("rm spec/tmp/* 2>/dev/null")
#     end

#     it "creates terraform file" do
#       expected = File.read("spec/fixtures/missing-fields-file.tf")
#       rci.import(["my.repo"])
#       actual = File.read("spec/tmp/my-repo.tf")
#       expect(actual).to eq(expected)
#     end

#     it "runs terraform import" do
#       init = %(cd spec/tmp; /bin/terraform init)
#       import = %(cd spec/tmp; /bin/terraform import module.my-repo.github_repository_collaborator.collaborator[\\"someuser\\"] my.repo:someuser)
#       expect(executor).to receive(:run).with(init)
#       expect(executor).to receive(:run).with(import)

#       rci.import(["my.repo"])
#     end
#   end
# end
