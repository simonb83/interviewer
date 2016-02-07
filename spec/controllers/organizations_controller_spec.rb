require 'spec_helper'

describe OrganizationsController do

  describe "POST create" do

    it "sends the right params to create method in the model" do
      post :create, organization: {"name"=>"Some Name", "account_id"=>"2"}
      @organization = Organization.last
      Organization.last.name.should == "Some Name"
      OrganizationAccount.last.organization_id.should == @organization.id
      OrganizationAccount.last.account_id.should == 2
    end

  end

end