require 'test_helper'

class RecruitersTest < ActionDispatch::IntegrationTest
  fixtures :all

  # test "cannot login if email is not valid" do
  #   visit new_recruiter_session_path
  #   fill_in "email-input", with: "simon.bedford@gmail.com"
  #   fill_in "password-input", with: "abcdefgh"
  #   click_on "Sign in"
  #   assert has_content?('Invalid email or password.')
  # end

  # test "registered user can log in" do
  #   @recruiter = recruiters(:user1)
  #   visit new_recruiter_session_path
  #   fill_in "email-input", with: @recruiter.email
  #   fill_in "password-input", with: "abcdefgh"
  #   click_on "Sign in"
  #   assert has_content?('Signed in successfully.')
  #   assert_equal recruiter_path(@recruiter), current_path
  #   within("div#header-col-right") do
  #     assert has_content?(@recruiter.name)
  #   end
  #   within("div#header-col-left") do
  #     assert has_content?('Scotiabank')
  #   end
  # end

  # test "registered user sees no campaigns text in table" do
  #   # @recruiter = recruiters(:user1)
  #   # visit new_recruiter_session_path
  #   # fill_in "email-input", with: @recruiter.email
  #   # fill_in "password-input", with: "abcdefgh"
  #   # click_on "Sign in"
  #   if @recruiter.campaigns.count == 0
  #     within("#campaigns span.empty") do
  #       assert has_content?("You currently have no campaigns")
  #     end
  #   else
  #     @recruiter.campaigns.each do |campaign|
  #       within("#campaigns table") do
  #         assert has_content?(campaign.position_name)
  #       end
  #     end
  #   end
  # end

  #  test "registered user sees no messages text in table" do
  #   @recruiter = recruiters(:user2)
  #   visit new_recruiter_session_path
  #   fill_in "email-input", with: @recruiter.email
  #   fill_in "password-input", with: "VoS7jopT"
  #   click_on "Sign in"
  #   if @recruiter.messages.count == 0
  #     within("#inbox span.empty") do
  #       assert has_content?("You currently have no messages")
  #     end
  #   else
  #     @recruiter.messages.each do |message|
  #       within("#inbox table") do
  #         assert has_content?(message.interview_id)
  #       end
  #     end
  #   end
  # end

  # test "recruiters can submit technical issue request" do
  #   @recruiter = recruiters(:user1)
  #   visit recruiter_technical_support_path(@recruiter)
  #   fill_in "issue_content", with: "String"
  #   click_on 'Submit'
  #   @issue = Issue.last
  #   assert_equal issue_path(@issue), current_path
  #   assert has_content?("We will be in touch as soon as possible to help you with your problem")
  #   assert_equal @recruiter.email, @issue.email
  #   assert_equal "recruiter", @issue.category
  #   assert_equal "String", @issue.content
  # end

  # test "recruiters can share candidates with others" do
  #   @recruiter = recruiters(:user1)
  #   @campaign = campaigns(:one)
  #   @candidate = @campaign.candidates.create(email: "string", completed_text_interview: true, completed_verbal_interview: true)
  #   visit campaign_candidate_path(@campaign, @candidate)
  #   click_on 'Share Interview'
  #   fill_in "message_freeform", with: "string"
  #   select "Simon Bedford", from: "message_array"
  #   click_on 'Share Interview'
  #   assert_equal campaign_candidate_path(@campaign, @candidate), current_path
  #   assert has_content?("Interview successfully shared with 2 recipients")
  #   @message = Message.last
  #   assert_equal @candidate.uid, @message.interview_id
  #   assert_equal 2, @message.message_recipients.count
  # end

end
