require 'spec_helper'

describe OrganizationAccount do

  describe "Callbacks" do

    it "sets anniversary day and month based on date created" do
      OrganizationAccount.create(account_id: 1, organization_id: 1)
      @oa = OrganizationAccount.last
      @oa.anniversary_day.should == Date.today.day
      @oa.anniversary_month.should == Date.today.month
      @oa.anniversary_year.should == Date.today.year
    end
  end
end
