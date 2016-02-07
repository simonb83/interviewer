require 'spec_helper'

describe Account do
  describe "validations" do
    it "permits payg, monthly and annual for period" do
      Account.new(period: "payg").should be_valid
      Account.new(period: "monthly").should be_valid
      Account.new(period: "annual").should be_valid
    end

    it "does not permit arbitrary string for period" do
      Account.new(period: "string").should_not be_valid
    end
  end
end
