class RepositoryCollaboratorImporter
  attr_reader :terraform_dir, :terraform_executable

  def initialize(params)
    @terraform_dir = params.fetch(:terraform_dir)
    @terraform_executable = params.fetch(:terraform_executable)

    @org_ext_collabs = OrganizationExternalCollaborators.new(
      github_token: params.fetch(:github_token),
      login: "ministryofjustice",
    )
  end

  def import(repo_names)
    repo_names.each do |repository|
      collaborators = external_collaborators(repository)
      if collaborators.any?
        $stderr.puts "Importing collaborators for #{repository}"
        create_terraform_file(repository, collaborators)
        import_collaborators(repository, collaborators)
      end
    end
  end

  private

  def external_collaborators(repository)
    @org_ext_collabs.for_repository(repository)
  end

  def create_terraform_file(repository, collaborators)
    terraform = render_template(repository, collaborators)
    outfile = output_file(repository)
    File.write(outfile, terraform)
    puts "Generated terraform file: #{outfile}"
  end

  def output_file(repository)
    "#{terraform_dir}/#{tf_safe(repository)}.tf"
  end

  def import_collaborators(repository, collaborators)
    repo = tf_safe(repository)
    system("cd #{terraform_dir}; #{terraform_executable} init")

    collaborators.each do |c|
      login = c.fetch(:login)
      $stderr.puts "  importing collaborator #{login} for repository #{repository}"
      cmd = %[cd #{terraform_dir}; #{terraform_executable} import module.#{repo}.github_repository_collaborator.collaborator[\\"#{login}\\"] #{repository}:#{login}]
      $stderr.puts cmd
      system(cmd)
    end
  end

  def render_template(repository, collaborators)
    repo = tf_safe(repository)

    template = <<EOF
module "<%= repo %>" {
  source     = "./modules/repository-collaborators"
  repository = "<%= repository %>"
  collaborators = [
  <% collaborators.each do |collab| %>
  {
      github_user  = "<%= collab[:login] %>"
      permission   = "<%= collab[:permission] %>"
      name         = ""
      email        = ""
      org          = ""
      added_by     = ""
      reason       = ""
      review_after = ""
    },
  <% end %>
]
}
EOF
    renderer = ERB.new(template, 0, ">")
    renderer.result(binding)
  end

  def tf_safe(string)
    string.gsub(".", "-")
  end
end
