require 'spec_helper'

describe Griddler::EmailsController do

  describe "POST /email_processor" do

    it "should create a new email" do
      email = double("email")
      email.stub(:process)
      Griddler::Email.should_receive(:new).and_return(email)
      post :create, to: "email-token", from: "user@email.com"
    end

    it "should create a new email even when there is no body" do
      email = double("email")
      email.stub(:process)
      Griddler::Email.should_receive(:new).and_return(email)
      post :create, to: "email-token", from: "user@email.com", text: ""
    end

  end

end