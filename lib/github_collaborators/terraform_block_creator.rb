class GithubCollaborators
  class TerraformBlockCreator
    include Logging
    attr_reader :data

    def initialize
      logger.debug "initialize"
      @username = ""
      @permission = ""
      @email = ""
      @name = ""
      @org = ""
      @reason = ""
      @added_by = ""
      @review_after = ""
      @repositories = []
    end

    # This is called when full org member / collaborator is missing from Terraform file
    def add_data(login)
      logger.debug "add_data"
      @username = "#{login}"
      @permission = ""
      @email = ""
      @name = ""
      @org = ""
      @reason = "Full Org member / collaborator missing from Terraform file"
      @added_by = "opseng-bot@digital.justice.gov.uk"
      review_date = (Date.today + 90).strftime("%Y-%m-%d")
      @review_after = "#{review_date}"
    end

    # This functions takes the body generated from a GitHub ticket created from /.github/ISSUE_TEMPLATE/create-pr-from-issue.yaml
    # It then structures this data to be used in creating Terraform collaborator blocks for the repo github-collaborators
    def import_data(data)
      logger.debug "import_data"
      # Creates a hash of arrays with field: [0] value
      # From a GitHub issues reponse created from an issue template
      # Example:
      # username: Array (1 element)
      #   [0]: 'al-ben
      # repositories: Array (4 elements)
      #   [0]: 'repo1'
      #   [1]: 'repo2'
      the_data = data
        # Fetch the body var and split on field seperator
        .fetch("body").split("###")
        # Remove empty lines
        .map { |line| line.strip }.map { |str| str.gsub(/^$\n/, "") }
        # Split on \n characters to have field name and field value in seperator hash
        .map { |line| line.split("\n") }
        # Drop first hash element as not needed
        .drop(1)
        # Map values into array
        .map { |field| [field[0], field.drop(1)] }.to_h
      
      @username = the_data["username"][0]
      @permission = the_data["permission"][0]
      @email = the_data["email"][0]
      @name = the_data["name"][0]
      @org = the_data["org"][0]
      @reason = the_data["reason"][0]
      @added_by = the_data["added_by"][0]
      @review_after = the_data["review_after"][0]
      @repositories = the_data["repositories"]
    end

    def update_file(repository_name)
      logger.debug "update_file"
      write_to_file(repository_name)
    end

    # This method inserts the Terraform blocks defined by this class into the relevant terraform/*.tf files
    def insert
      logger.debug "insert"
      # Nil check just in case
      if !@repositories.nil?
        # For each repository
        @repositories.each { |repository_name|
          # Add new data to Terraform file
          write_to_file(repository_name)
        }
      end
    end

    private

    def create_new_file(file_name)
      logger.debug "create_new_file"
      repo_name = File.basename(file_name, ".tf")
      File.open(file_name, "w") { |f| f.write create_new_file_template(repo_name)  }
    end

    def add_to_file(file_name)
      logger.debug "add_to_file"
       # Read the relevant file into array
       file_content = File.read(file_name).split("\n")

       # Create insert contents and insert, length - 2 gives the correct location in the file
       file_content.insert(file_content.length - 2, create_insert)

       # Write new content to file
       File.open(file_name, "w") { |f|
         f.puts(file_content)
       }
    end
    
    def write_to_file(repository_name)
      logger.debug "write_to_file"

      file_name = "terraform/#{tf_safe(repository_name)}.tf"
      if File.exist?(file_name)
        add_to_file(file_name)
      else
        create_new_file(file_name)
      end
    end

    # Util function to deal with Terraform . limitations
    def tf_safe(string)
      string.tr(".", "-").strip
    end

    # Returns block needed to insert into a collaborator file
    # Pass it the infomation needed for such, see example at:
    # https://github.com/ministryofjustice/github-collaborators/blob/main/terraform/yjaf-auth.tf
    def create_insert
      logger.debug "create_insert"
      <<~EOF
        \s\s\s\s{
            \s\sgithub_user  = "#{@username}"
            \s\spermission   = "#{@permission}"
            \s\sname         = "#{@name}"         
            \s\semail        = "#{@email}"        
            \s\sorg          = "#{@org}"          
            \s\sreason       = "#{@reason}"       
            \s\sadded_by     = "#{@added_by}"     
            \s\sreview_after = "#{@review_after}" 
        \s\s\s\s},
      EOF
    end

    def create_new_file_template(repository)
      logger.debug "create_new_file_template"
      <<~EOF
      module "#{repository}" {
      \s\ssource     = "./modules/repository-collaborators"
      \s\srepository = "#{repository}"
      \s\scollaborators = [
      \s\s\s\s{
      \s\s\s\s\s\sgithub_user  = "#{@username}"
      \s\s\s\s\s\spermission   = "#{@permission}"
      \s\s\s\s\s\sname         = "#{@name}"         
      \s\s\s\s\s\semail        = "#{@email}"        
      \s\s\s\s\s\sorg          = "#{@org}"          
      \s\s\s\s\s\sreason       = "#{@reason}"       
      \s\s\s\s\s\sadded_by     = "#{@added_by}"     
      \s\s\s\s\s\sreview_after = "#{@review_after}" 
      \s\s\s\s},
      \s\s\]
      }
      EOF
    end
  end
end
