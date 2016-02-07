require 'test_helper'

class AnswersTest < ActionDispatch::IntegrationTest
  fixtures :all

  # test "if an answer is blank, candidate is redirected back to answers page" do
  #   @candidate = candidates(:one)
  #   visit candidate_start_text_interview_path(@candidate)
  #   fill_in "answers_1", with: "text"
  #   click_on 'Continue'
  #   assert has_content?("Virtual Interview Part 1 - Written Interview")
  #   assert has_content?("Please answer all questions before continuing.")
  # end

  # test "if all answers have been filled in, answers are saved and candidate is re-routed to start voice interview" do
  #   @candidate = candidates(:one)
  #   visit candidate_start_text_interview_path(@candidate)
  #   fill_in "answers_1", with: "text"
  #   fill_in "answers_2", with: "text"
  #   click_on 'Continue'
  #   assert_equal 2, @candidate.answers.count
  #   assert_equal candidate_start_voice_interview_path(@candidate), current_path
  # end

end
