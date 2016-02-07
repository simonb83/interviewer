# encoding: utf-8
require 'spec_helper'

describe AdminsController do

  before(:each) do
    @admin = create(:admin)
    sign_in @admin
  end

  describe "GET find_item" do
    it "finds correct model type" do
      campaign = create(:campaign)
      Campaign.should_receive(:find).and_return(campaign)
      get :find_item, item_type: "Campaign", item_id: campaign.id
    end

    it "responds with attributes in JSON format" do
      campaign = create(:campaign)
      get :find_item, item_type: "Campaign", item_id: campaign.id, format: 'js'
      expected = campaign.attributes.to_json
      response.body.should == expected
    end
  end

  describe "PUT update_item" do
    it "finds Campaign if type is campaign" do
      campaign = create(:campaign)
      Campaign.should_receive(:find).and_return(campaign)
      put :update_item, item_type: "Campaign", item_id: campaign.id, attribute: "position_name", value: "some new string"
    end

    it "finds Candidate if type is candidate" do
      candidate = create(:candidate)
      Candidate.should_receive(:find).and_return(candidate)
      put :update_item, item_type: "Candidate", item_id: candidate.id, attribute: "email", value: "steven@email.com"
    end

    it "find Answer if type is answer" do
      answer = create(:answer)
      Answer.should_receive(:find).and_return(answer)
      put :update_item, item_type: "Answer", item_id: answer.id, attribute: "content", value: "string"
    end

    it "updates the attribute if it is a valid attribute" do
      candidate = create(:candidate)
      put :update_item, item_type: "Candidate", item_id: candidate.id, attribute: "email", value: "steven@email.com"
      Candidate.find(candidate.id).email.should == "steven@email.com"
    end

    it "gives flash message on success and redirects to the admin page" do
      candidate = create(:candidate)
      put :update_item, item_type: "Candidate", item_id: candidate.id, attribute: "email", value: "steven@email.com"
      flash[:notice].should == "email updated to steven@email.com for Candidate with id #{candidate.id}"
      response.should redirect_to(@admin)
    end

    it "gives flash message if attribute doesn't exist and renders admin_form" do
      candidate = create(:candidate)
      put :update_item, item_type: "Candidate", item_id: candidate.id, attribute: "position", value: "steven@email.com"
      flash[:notice].should == "Attribute position doesn't exist"
      response.should render_template('admin_form')
    end

    it "gives errors if validations fail" do
      campaign = create(:campaign)
      put :update_item, item_type: "Campaign", item_id: campaign.id, attribute: "deadline", value: Date.yesterday
      flash[:notice].should == "Validation failed: Fecha Límite no puede haber pasado"
      response.should render_template('admin_form')
    end

    it "gives suitable error message if object not found" do
      campaign = create(:campaign) do
        put :update_item, item_type: "Campaign", item_id: 205, attribute: "deadline", value: Date.today
        flash[:notice].should == "Couldn't find Campaign with id=205"
        response.should render_template('admin_form')
      end
    end

  end

end