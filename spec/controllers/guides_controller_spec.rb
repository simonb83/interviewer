# encoding: UTF-8
require 'spec_helper'

describe GuidesController do
  render_views

  before(:each) do
     sign_in create(:recruiter, new_user: false)
  end

  describe "show" do

    it "render the file for the instance name" do
      Guide.any_instance.stub(:create_template).and_return(true)
      @guide = FactoryGirl.create(:guide, name: "My Néw Name")
      get :show, id: @guide.id
      response.should render_template('show')
      response.body.should have_selector('h3', text: 'My Néw Name')
    end

  end

end
