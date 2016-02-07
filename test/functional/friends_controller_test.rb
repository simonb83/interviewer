require 'test_helper'

class FriendsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  # test "candidates redirected to interview finalize page if already recommended friends" do
  #   @candidate = campaigns(:three).candidates.create(email: "string-1", recommended_friends: true)
  #   get :recommend_friends, candidate_id: @candidate.id
  #   assert_redirected_to candidate_interview_confirmation_path(@candidate)
  #   end


end
