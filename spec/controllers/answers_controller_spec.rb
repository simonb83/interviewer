require 'spec_helper'

describe AnswersController do

  describe "POST add answers" do

    it "makes sure the answer hash is not incomplete" do
      candidate = create(:candidate)
      answers = {"a" => ""}
      post :add_answers, candidate_id: candidate.id, answers: answers
      flash[:notice].should == "Por favor, responde a todas las preguntas antes de continuar."
      response.should render_template("candidates/start_text_interview")
    end

    it "creates answers for valid answers" do
      candidate = create(:candidate)
      answers = {"1" => "Some string"}
      a = double("answer")
      Candidate.any_instance.stub(:answers).and_return(a)
      a.should_receive(:create!).with(content: "Some string", question_id: 1).once
      post :add_answers, candidate_id: candidate.id, answers: answers
    end

    it "creates question answers for valid answers" do
      candidate = create(:candidate)
      answers = {"1" => "Some string"}
      a = double("question_answer")
      Answer.any_instance.stub(:question_answers).and_return(a)
      a.should_receive(:create).with(question_id: 1).once
      post :add_answers, candidate_id: candidate.id, answers: answers
    end

    it "increases answers by 1" do
      candidate = create(:candidate)
      answers = {"1" => "Some string"}
      expect {post :add_answers, candidate_id: candidate.id, answers: answers}.to change(Answer, :count).by(1)
    end

    it "associates answer with candidate" do
      candidate = create(:candidate)
      answers = {"1" => "Some string"}
      post :add_answers, candidate_id: candidate.id, answers: answers
      candidate.answers.count.should == 1
      candidate.answers.last.content.should == "Some string"
    end

    it "sets completed text interview to true" do
      candidate = create(:candidate)
      answers = {"1" => "Some string"}
      post :add_answers, candidate_id: candidate.id, answers: answers
      Candidate.find(candidate.id).completed_text_interview.should be_true
    end

    it "redirects to next stage path with success message" do
      candidate = create(:candidate)
      answers = {"1" => "Some string"}
      post :add_answers, candidate_id: candidate.id, answers: answers
      flash[:notice].should == "Tus respuestas fueron guardadas."
      response.should redirect_to(candidate_next_stage_path(assigns(:candidate)))
    end

  end
end