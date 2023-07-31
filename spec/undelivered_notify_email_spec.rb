class GithubCollaborators
  include TestConstants
  include Constants

  describe UndeliveredNotifyEmail do
    context "test UndeliveredNotifyEmail" do
      subject(:undelivered_notify_email) { described_class.new }

      it "call create_line" do
        terraform_block = create_terraform_block_review_date_today
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
        line = undelivered_notify_email.create_line(collaborator)
        test_equal(line, "- #{TEST_USER} in <#{REPO_URL}> see <#{HREF}>")
      end

      it "singular_message" do
        line = undelivered_notify_email.singular_message
        test_equal(line, "Notify failed to email a collaborator whose review date expires next week, see if the collaborator still require access")
      end

      it "multiple_message" do
        line = undelivered_notify_email.multiple_message(4)
        test_equal(line, "Notify failed to email 4 collaborator whose review date expire next week, see if these collaborator still require access")
      end
    end
  end
end
