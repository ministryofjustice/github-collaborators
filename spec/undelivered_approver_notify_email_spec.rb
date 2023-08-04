class GithubCollaborators
  include TestConstants
  include Constants

  describe UndeliveredApproverNotifyEmail do
    context "test UndeliveredApproverNotifyEmail" do
      subject(:undelivered_notify_email) { described_class.new }

      it "call create_line" do
        terraform_block = create_terraform_block_review_date_today
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
        line = undelivered_notify_email.create_line(collaborator)
        test_equal(line, "- #{TEST_COLLABORATOR_EMAIL}")
      end

      it "singular_message" do
        line = undelivered_notify_email.singular_message
        test_equal(line, "Undelivered Notify email to approver")
      end

      it "multiple_message" do
        line = undelivered_notify_email.multiple_message(4)
        test_equal(line, "Undelivered Notify email to approver")
      end
    end
  end
end
