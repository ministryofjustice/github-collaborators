# This class takes the body generated from a GitHub ticket created from /.github/ISSUE_TEMPLATE/create-pr-from-issue.yaml
# It then structures this data to be used in creating Terraform collaborator blocks for the repo github-collaborators


# TODO:
#   Add unit tests
class GithubCollaborators
    class TerraformBlockCreator
        attr_reader :data
  
        def initialize(data)

            # Creates a hash of arrays with field: [0] value
            # From a GitHub issues reponse created from an issue template
            # Example:
            # username: Array (1 element)
            #   [0]: 'al-ben
            # repositories: Array (4 elements)
            #   [0]: 'repo1'
            #   [1]: 'repo2'
            @data = Hash[data
                            # Fetch the body var and split on field seperator
                            .fetch("body").split("###")
                            # Remove empty lines
                            .map { |line| line.strip }.map { |str| str.gsub /^$\n/, '' }
                            # Split on \n characters to have field name and field value in seperator hash
                            .map { |line| line.split("\n") }
                            # Drop first hash element as not needed
                            .drop(1)
                            # Map values into array
                            .map { |field| [field[0], field.drop(1)] }]
        end

        # String
        def username
            @data["username"][0]
        end

        # String
        def permission
            @data["permission"][0]
        end
        
        # String
        def email
            @data["email"][0]
        end

        # String
        def name
            @data["name"][0]
        end

        # String
        def org
            @data["org"][0]
        end

        # String
        def reason
            @data["reason"][0]
        end

        # String
        def added_by
            @data["added_by"][0]
        end

        # String
        def review_after
            @data["review_after"][0]
        end

        # Array
        def repositories
            @data["repositories"]
        end

        # This method inserts the Terraform blocks defined by this class into the relevant terraform/*.tf files
        def insert

            # For each repository 
            repositories.each { |repo|

                # Read the relevant file into array
                file = File.read(repo_file(repo))
                        .split("\n")
                
                # Create insert contents and insert, length - 2 gives the correct location in the file
                file.insert((file.length) - 2, create_insert)

                # Write file
                File.open(repo_file(repo), "w") { 
                    |f| f.puts(file)  
                }
            }
        end

        private 

        # Util function to deal with Terraform . limitations
        def tf_safe(string)
            string.tr(".", "-").strip
        end

        # Util function to return location of repo file from repo name
        def repo_file(repo)
            "terraform/#{tf_safe(repo)}.tf"
        end

        # Returns block needed to insert into a collaborator file
        # Pass it the infomation needed for such, see example at:
        # https://github.com/ministryofjustice/github-collaborators/blob/main/terraform/yjaf-auth.tf
        def create_insert
            <<~EOF
            \s\s\s\s{
                \s\sgithub_user  = "#{username}"
                \s\spermission   = "#{permission}"
                \s\sname         = "#{name}"         
                \s\semail        = "#{email}"        
                \s\sorg          = "#{org}"          
                \s\sreason       = "#{reason}"       
                \s\sadded_by     = "#{added_by}"     
                \s\sreview_after = "#{review_after}" 
            \s\s\s\s},
            EOF
        end
    end
  end