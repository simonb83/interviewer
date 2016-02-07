require 'spec_helper'

describe Organization do

  describe "after create" do

    it "creates an Organization Account with id of organization" do
      organization = create(:organization)
      OrganizationAccount.last.organization_id.should == organization.id
    end

    it "creates an Organization Account with id of account" do
      organization = create(:organization, account_id: 2)
      OrganizationAccount.last.account_id.should == 2
    end

    it "has organization account belonging to organization" do
      organization = create(:organization)
      organization.organization_account.should_not  be_nil
    end

  end

end