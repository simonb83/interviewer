require 'spec_helper'
require "cancan/matchers"

describe "Admin" do

  it "should be able to manage recruiters" do
    admin = create(:admin)
    ability = Ability.new(admin)
    recruiter = create(:recruiter)
    ability.should be_able_to(:manage, recruiter)
  end

  it "should be able to manage campaigns" do
    admin = create(:admin)
    ability = Ability.new(admin)
    campaign = create(:campaign)
    ability.should be_able_to(:manage, campaign)
  end

end