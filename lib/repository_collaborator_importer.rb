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
    output_file = "#{terraform_dir}/#{repository}.tf"
    File.write(output_file, terraform)
    puts "Generated terraform file: #{output_file}"
  end

  def import_collaborators(repository, collaborators)
    system("cd #{terraform_dir}; #{terraform_executable} init")

    collaborators.each do |c|
      login = c.fetch(:login)
      cmd = %[cd #{terraform_dir}; #{terraform_executable} import module.#{repository}.github_repository_collaborator.collaborator[\\"#{login}\\"] #{repository}:#{login}]
      puts cmd
      system(cmd)
    end
  end

  def render_template(repository, collaborators)
    template = <<EOF
module "<%= repository %>" {
  source     = "./modules/repository-collaborators"
  repository = "<%= repository %>"
  collaborators = {
  <% collaborators.each do |collab| %>
  <%= collab[:login] %> = "<%= collab[:permission] %>"
  <% end %>
}
}
EOF
    renderer = ERB.new(template, 0, ">")
    renderer.result(binding)
  end
end
