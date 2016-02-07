require 'test_helper'

class CandidatesTest < ActionDispatch::IntegrationTest
  # test "candidates correctly directed on start interview" do
  #   candidate1 = candidates(:one)
  #   candidate2 = candidates(:two)
  #   candidate3 = candidates(:three)

  #   visit "/candidate_start_interview?interview_id=#{candidate1.uid}"
  #   assert has_content?("Welcome to your virtual interview for")

  #   visit "/candidate_start_interview?interview_id=#{candidate2.uid}"
  #   assert has_content?("It looks like you have already completed your virtual interview")

  #   visit "/candidate_start_interview?interview_id=#{candidate3.uid}"
  #   assert has_content?("Unfortuntately the deadline of")
  # end

  # test "candidates correctly directed to correct section of interview" do
  #   candidate1 = candidates(:one)
  #   visit "/candidate_start_interview?interview_id=#{candidate1.uid}"
  #   fill_in 'Name', with: "Simon"
  #   fill_in 'Surname', with: "Bedford"
  #   check 'privacy-consent'
  #   click_on 'Start'
  #   assert has_content?('Virtual Interview Part 1 - Written Interview')
  # end

  # test "candidates can add if friends if permitted" do
  #   @candidate = campaigns(:three).candidates.create(email: "string-1")
  #   assert_equal false, @candidate.recommended_friends?
  #   visit candidate_recommend_friends_path(@candidate)
  #   fill_in "Candidate_friend_list", with: "string1, string2, string3"
  #   click_on 'Add Candidates'
  #   assert candidate_interview_confirmation_path(@candidate), current_path
  #   assert_equal 3, @candidate.friends.count
  # end

  # test "candidates can submit technical issue request" do
  #   @candidate = candidates(:one)
  #   visit candidate_technical_support_path(@candidate)
  #   fill_in "issue_content", with: "String"
  #   click_on 'Submit'
  #   @issue = Issue.last
  #   assert_equal issue_path(@issue), current_path
  #   assert has_content?("We will be in touch as soon as possible to help you with your problem")
  #   assert_equal @candidate.email, @issue.email
  #   assert_equal @candidate.uid, @issue.interview_id
  #   assert_equal "candidate", @issue.category
  #   assert_equal "String", @issue.content
  # end

end
