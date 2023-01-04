class GithubCollaborators
  include TestConstants
  include Constants

  context "test review_dates in TerraformFiles" do
    before do
      @terraform_files = GithubCollaborators::TerraformFiles.new
    end

    it "are valid" do
      the_terraform_files = @terraform_files.get_terraform_files

      the_terraform_files.each do |terraform_file|
        terraform_blocks = terraform_file.get_terraform_blocks
        terraform_blocks.each do |terraform_block|
          d = Date.parse(terraform_block.review_after)
          is_review_date_valid = Date.valid_date?(d.year, d.month, d.day)
          test_equal(is_review_date_valid, true)
        rescue ArgumentError => e
          print("Found a " + e.message + " for " + terraform_block.username + " in the file: " + terraform_file.filename + "\n")
          test_equal(terraform_block.review_after, "a-valid-date")
        end
      end
    end
  end
end
