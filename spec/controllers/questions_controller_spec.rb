require 'spec_helper'

describe QuestionsController do


  describe "POST create_questions" do

    it "creates questions with the submitted content & category id" do
      category = create(:category, id: 1)
      Question.should_receive(:create).with(content: "dummy content", category_id: "1", kind: "text")
      post :create_questions, content: "dummy content", category_id: "1", text_question: "1"
    end

    it "creates a text question if text is selected" do
      category = create(:category, id: 1)
      Question.should_receive(:create).with(content: "dummy content", category_id: "1", kind: "text")
      post :create_questions, content: "dummy content", category_id: "1", text_question: "1"
    end

    it "does not create a text question if text is not selected" do
      category = create(:category, id: 1)
      Question.should_not_receive(:create).with(content: "dummy content", category_id: "1", kind: "text")
      post :create_questions, content: "dummy content", category_id: "1", text_question: "0"
    end

    it "creates a verbal question if verbal is selected" do
      category = create(:category, id: 1)
      Question.should_receive(:create).with(content: "dummy content", category_id: "1", kind: "verbal")
      post :create_questions, content: "dummy content", category_id: "1", text_question: "0", verbal_question: "1"
    end

    it "does not create a text question if text is not selected" do
      category = create(:category, id: 1)
      Question.should_not_receive(:create).with(content: "dummy content", category_id: "1", kind: "verbal")
      post :create_questions, content: "dummy content", category_id: "1", verbal_question: "0"
    end

    it "redirects to Category page" do
      category = create(:category)
      category.stub(:id).and_return("1")
      Question.stub(:create)
      post :create_questions, category_id: category.id
      response.should redirect_to('/categories/1')
    end

  end

end