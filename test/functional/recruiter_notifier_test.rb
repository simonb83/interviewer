#encoding: utf-8
require 'test_helper'

class RecruiterNotifierTest < ActionMailer::TestCase
  test "shared_internal" do
    recruiter_1 = FactoryGirl.create(:recruiter)
    org = recruiter_1.organization
    recruiter_2 = FactoryGirl.create(:recruiter, organization: org, email: "simon@abare.in")
    mail = RecruiterNotifier.shared_internal(recruiter_1, recruiter_2)
    assert_equal "Un colega ha compartido una entrevista contigo.", mail.subject
    assert_equal ["simon@abare.in"], mail.to
    assert_equal ["contact@ampleo.mx"], mail.from
    assert_match "ha compartido una entrevista contigo para tu consideración.", mail.body.encoded
  end

  test "shared_external" do
    recruiter = FactoryGirl.create(:recruiter)
    campaign = FactoryGirl.create(:campaign, recruiter: recruiter)
    candidate = FactoryGirl.create(:candidate, campaign: campaign)
    mail = RecruiterNotifier.shared_external(recruiter, "testemail", candidate)
    assert_equal "Un colega quisiera compartir una entrevista contigo.", mail.subject
    assert_equal ["testemail"], mail.to
    assert_equal ["contact@ampleo.mx"], mail.from
    assert_match "quisiera compartir la siguiente entrevista contigo para tu consideración:", mail.body.encoded
  end

end
