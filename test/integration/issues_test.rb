require 'test_helper'

class RecruitersTest < ActionDispatch::IntegrationTest
  fixtures :all

# test "users can submit technical issue request" do
#     visit technical_support_path
#     fill_in "Email", with: "email"
#     fill_in "Name", with: "name"
#     fill_in "Interview", with: "interview"
#     fill_in "issue_content", with: "String"
#     click_on 'Submit'
#     @issue = Issue.last
#     assert_equal issue_path(@issue), current_path
#     assert has_content?("We will be in touch as soon as possible to help you with your problem")
#     assert_equal "email", @issue.email
#     assert_equal "name", @issue.name
#     assert_equal "interview", @issue.interview_id
#     assert_equal "String", @issue.content
#   end

end