# encoding: utf-8
require 'spec_helper'
# include Devise::TestHelpers

  describe IssuesController do

    describe "create issue" do
      it "sends an email to contact@ampleo.mx when an issue is created" do
        issue_attr = {email: "email", category: "other", content: "content"}
        post :create, issue: issue_attr
        @issue = assigns(:issue)
        ActionMailer::Base.deliveries[-2].to.should == ["contact@ampleo.mx"]
        ActionMailer::Base.deliveries[-2].subject.should == "New issue #{@issue.id}"
      end

      it "sends an email to the person who created the issue" do
        issue_attr = {email: "email", category: "other", content: "content"}
        AdminMailer.should_receive(:new_issue).and_return(double("mailer", deliver: false))
        post :create, issue: issue_attr
        @issue = assigns(:issue)
        ActionMailer::Base.deliveries.last.to.should == ["email"]
        ActionMailer::Base.deliveries.last.subject.should == "Ticket ID: #{@issue.id}"
      end

    end

    describe "PUT update status" do
      it "redirects to current admin" do
        admin = create(:admin)
        sign_in admin
        issue = create(:issue, category: "other")
        put :update_status, issue_id: issue.id
        response.should redirect_to(admin)
      end

      it "calls switch_status" do
        admin = create(:admin)
        sign_in admin
        issue = create(:issue, category: "other")
        Issue.any_instance.should_receive(:switch_status)
        put :update_status, issue_id: issue.id
      end

    end

  end