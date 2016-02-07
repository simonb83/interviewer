# encoding: UTF-8

require 'spec_helper'

describe RecruitersController do

  describe "GET show" do

    it "sets first time as true if params[first_time] exists" do
      recruiter = create(:recruiter, password: "mypassword", new_user: false)
      sign_in recruiter
      get :show, id: recruiter.id, first_time: true
      assigns(:first_time).should be_true
    end

    it "does not set first time if params[first_time] does not exist" do
      recruiter = create(:recruiter, password: "mypassword", new_user: false)
      sign_in recruiter
      get :show, id: recruiter.id
      assigns(:first_time).should be_nil
    end

  end

  describe "PUT update_password" do

    it "renders change password if current password is not correct" do
      recruiter = create(:recruiter, password: "mypassword")
      sign_in recruiter
      put :update_password, "recruiter"=>{"current_password"=>"mypassword1", "password"=>"[mynewpassword", "password_confirmation"=>"mynewpassword"}, recruiter_id: recruiter.id
      response.should render_template("change_password")
    end

    it "renders change password if new passwords do not match" do
      recruiter = create(:recruiter, password: "mypassword")
      sign_in recruiter
      put :update_password, "recruiter"=>{"current_password"=>"mypassword", "password"=>"[mynewpassword", "password_confirmation"=>"mynewpassword1"}, recruiter_id: recruiter.id
      response.should render_template("change_password")
    end

    it "does not change new user status upon failure" do
      recruiter = create(:recruiter, password: "mypassword")
      sign_in recruiter
      put :update_password, "recruiter"=>{"current_password"=>"mypassword", "password"=>"[mynewpassword", "password_confirmation"=>"mynewpassword1"}, recruiter_id: recruiter.id
      Recruiter.find(recruiter.id).new_user.should be_true
    end

    # it "should change status of recruiter new_user" do
    #   recruiter = create(:recruiter, password: "mypassword")
    #   sign_in recruiter
    #   # Recruiter.any_instance.should_receive(:update_attribute).with(:new_user, false)
    #   put :update_password, "recruiter"=>{"current_password"=>"mypassword", "password"=>"[mynewpassword", "password_confirmation"=>"mynewpassword"}, recruiter_id: recruiter.id
    #   response.should render_template('change_password')
    #   # @recruiter = Recruiter.find(recruiter.id)
    #   # @recruiter.new_user.should_not be_true
    # end

  end

  describe "GET show" do

    it "displays account suspended message if the recruiter is not active" do
      organization = create(:organization, active: false)
      recruiter = create(:recruiter, organization: organization, new_user: false)
      sign_in recruiter
      get :show, id: recruiter.id
      flash[:alert].should == "Tu cuenta ha sido suspendida. Por favor habla con el administrador de tu empresa o contáctanos <a href=#{recruiter_technical_support_path(recruiter)}>aquí</a> para reactivarla.".html_safe
    end

    it "does not display account suspended message if the recruiter is active" do
      recruiter = create(:recruiter, new_user: false)
      sign_in recruiter
      get :show, id: recruiter.id
      flash[:alert].should be_nil
    end

  end

  describe "GET edit" do

    it "displays account suspended message if the recruiter is not active" do
      organization = create(:organization, active: false)
      recruiter = create(:recruiter, organization: organization, new_user: false)
      sign_in recruiter
      get :edit, id: recruiter.id
      flash[:alert].should == "Tu cuenta ha sido suspendida. Por favor habla con el administrador de tu empresa o contáctanos <a href=#{recruiter_technical_support_path(recruiter)}>aquí</a> para reactivarla.".html_safe
    end

    it "does not display account suspended message if the recruiter is active" do
      recruiter = create(:recruiter, new_user: false)
      sign_in recruiter
      get :edit, id: recruiter.id
      flash[:alert].should be_nil
    end

  end

end