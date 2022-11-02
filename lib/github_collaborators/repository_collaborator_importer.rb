class GithubCollaborators
  class RepositoryCollaboratorImporter
    include Logging
    attr_reader :terraform_dir, :terraform_executable

    def initialize(params)
      logger.debug "initialize"
      @terraform_dir = params.fetch(:terraform_dir)
      @terraform_executable = params.fetch(:terraform_executable)
      @org_ext_collabs = params.fetch(:org_ext_collabs)
      @executor = params.fetch(:executor) { Executor.new }
    end

    def import(repo_names)
      logger.debug "import"
      repo_names.each do |repository|
        collaborators = outside_collaborators(repository)
        if collaborators.any?
          logger.info "Importing collaborators for #{repository}"
          create_terraform_file(repository, collaborators)
          import_collaborators(repository, collaborators)
        end
      end
    end

    private

    def outside_collaborators(repository)
      logger.debug "outside_collaborators"
      @org_ext_collabs.for_repository(repository)
    end

    def create_terraform_file(repository, collaborators)
      logger.debug "create_terraform_file"
      terraform = render_template(repository, collaborators)
      outfile = output_file(repository)
      File.write(outfile, terraform)
      logger.info "Generated terraform file: #{outfile}"
    end

    def output_file(repository)
      logger.debug "output_file"
      "#{terraform_dir}/#{GithubCollaborators.tf_safe(repository)}.tf"
    end

    def import_collaborators(repository, collaborators)
      logger.debug "import_collaborators"
      repo = GithubCollaborators.tf_safe(repository)
      @executor.run("cd #{terraform_dir}; #{terraform_executable} init")

      collaborators.each do |c|
        login = c.fetch(:login)
        logger.info "  importing collaborator #{login} for repository #{repository}"
        cmd = %(cd #{terraform_dir}; #{terraform_executable} import module.#{repo}.github_repository_collaborator.collaborator[\\"#{login}\\"] #{repository}:#{login})
        logger.info cmd
        @executor.run(cmd)
      end
    end

    def render_template(repository, collaborators)
      logger.debug "render_template"
      repo = GithubCollaborators.tf_safe(repository)

      template = <<~EOF
        module "<%= repo %>" {
          source     = "./modules/repository-collaborators"
          repository = "<%= repository %>"
          collaborators = [
          <% collaborators.each do |collaborator| %>
          {
              github_user  = "<%= collaborator[:login] %>"
              permission   = "<%= collaborator[:permission] %>"
              name         = "" #  The name of the person behind github_user
              email        = "" #  Their email address
              org          = "" #  The organisation/entity they belong to
              reason       = "" #  Why is this person being granted access?
              added_by     = "" #  Who made the decision to grant them access? e.g. "Some Person <some.person@digital.justice.gov.uk>"
              review_after = "" #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
            },
          <% end %>
        ]
        }
      EOF
      renderer = ERB.new(template, trim_mode: ">")
      renderer.result(binding)
    end
  end
end
