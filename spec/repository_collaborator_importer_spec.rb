describe GithubCollaborators::RepositoryCollaboratorImporter do
  let(:executor) { double(Executor, run: "") }
  let(:logger) { double(Logger, warn: nil) }
  let(:collabs) {
    [
      {login: "digitalronin", permission: "admin"}
    ]
  }
  let(:oec) { double(GithubCollaborators::OrganizationExternalCollaborators, for_repository: collabs) }

  let(:params) {
    {
      terraform_dir: "spec/tmp",
      terraform_executable: "/bin/terraform",
      org_ext_collabs: oec,
      executor: executor,
      logger: logger
    }
  }

  let(:rci) { described_class.new(params) }

  before do
    allow(Kernel).to receive(:warn).and_return(nil)
    system("rm spec/tmp/* 2>/dev/null")
  end

  after do
    system("rm spec/tmp/* 2>/dev/null")
  end

  it "creates terraform file" do
    expected = File.read("spec/fixtures/myrepo.tf")
    rci.import(["myrepo"])
    actual = File.read("spec/tmp/myrepo.tf")
    expect(actual).to eq(expected)
  end

  it "runs terraform import" do
    init = %(cd spec/tmp; /bin/terraform init)
    import = %(cd spec/tmp; /bin/terraform import module.myrepo.github_repository_collaborator.collaborator[\\"digitalronin\\"] myrepo:digitalronin)
    expect(executor).to receive(:run).with(init)
    expect(executor).to receive(:run).with(import)

    rci.import(["myrepo"])
  end
end
