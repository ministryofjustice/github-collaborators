class GithubCollaborators
  class RepositoryCollaboratorImporter
    attr_reader :terraform_dir, :terraform_executable

    def initialize(params)
      @terraform_dir = params.fetch(:terraform_dir)
      @terraform_executable = params.fetch(:terraform_executable)
      @org_ext_collabs = params.fetch(:org_ext_collabs) { OrganizationExternalCollaborators.new(login: "ministryofjustice") }
      @executor = params.fetch(:executor) { Executor.new }
      @logger = params.fetch(:logger) { Logger.new }
    end

    def import(repo_names)
      repo_names.each do |repository|
        collaborators = external_collaborators(repository)
        if collaborators.any?
          @logger.warn "Importing collaborators for #{repository}"
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
      @logger.warn "Generated terraform file: #{outfile}"
    end

    def output_file(repository)
      "#{terraform_dir}/#{tf_safe(repository)}.tf"
    end

    def import_collaborators(repository, collaborators)
      repo = tf_safe(repository)
      @executor.run("cd #{terraform_dir}; #{terraform_executable} init")

      collaborators.each do |c|
        login = c.fetch(:login)
        @logger.warn "  importing collaborator #{login} for repository #{repository}"
        cmd = %(cd #{terraform_dir}; #{terraform_executable} import module.#{repo}.github_repository_collaborator.collaborator[\\"#{login}\\"] #{repository}:#{login})
        @logger.warn cmd
        @executor.run(cmd)
      end
    end

    def render_template(repository, collaborators)
      repo = tf_safe(repository)

      template = <<~EOF
        module "<%= repo %>" {
          source     = "./modules/repository-collaborators"
          repository = "<%= repository %>"
          collaborators = [
          <% collaborators.each do |collab| %>
          {
              github_user  = "<%= collab[:login] %>"
              permission   = "<%= collab[:permission] %>"
              name         = ""  #  The name of the person behind github_user
              email        = ""  #  Their email address
              org          = ""  #  The organisation/entity they belong to
              reason       = ""  #  Why is this person being granted access?
              added_by     = ""  #  Who made the decision to grant them access? e.g. "Some Person <some.person@digital.justice.gov.uk>"
              review_after = ""  #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
            },
          <% end %>
        ]
        }
      EOF
      renderer = ERB.new(template, trim_mode: ">")
      renderer.result(binding)
    end

    def tf_safe(string)
      string.tr(".", "-")
    end
  end
end
