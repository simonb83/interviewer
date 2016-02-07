require 'test_helper'

class IssueTest < ActiveSupport::TestCase

  # test "interview_id is required when category is candidate" do
  #   @issue = Issue.new(category: "candidate", email: "string")
  #   assert_equal false, @issue.valid?
  # end

  # test "interview_id is not required when category is anything else" do
  #   @issue = Issue.new(category: "other", email: "string")
  #   assert_equal true, @issue.valid?
  # end

  # test "issue is not valid if category is not 'candidate', 'recruiter' or 'other'" do
  #   @issue = Issue.new(category: "string", email: "string")
  #   assert_equal false, @issue.valid?
  # end

  # test "gets candidate template if category is candidate" do
  #   @issue = Issue.create(category: "candidate", email:  "string")
  #   assert_equal "candidate_issue_show", @issue.get_template
  # end

  # test "gets recruiter template if category is recruiter" do
  #   @issue = Issue.create(category: "recruiter", email:  "string")
  #   assert_equal "recruiter_issue_show", @issue.get_template
  # end

  # test "gets issue template if category is other" do
  #   @issue = Issue.create(category: "other", email:  "string")
  #   assert_equal "issue_show", @issue.get_template
  # end

end
