class AnswersController < ApplicationController

  load_and_authorize_resource

  def add_answers
    @candidate = Candidate.find(params[:candidate_id])
    answer_hash = params[:answers]
      #Re-render text interview page if candidate has not answered all questions
      if answer_hash.has_value?('')
        flash[:notice] = t(:answer_all_questions)
        render 'candidates/start_text_interview'
      else
        #Otherwise, save answers and link them to candidate
        answer_hash.each_pair do |k,v|
        begin
          @answer = @candidate.answers.create!(content: v, question_id: k.to_i)
          @answer.question_answers.create(question_id: k.to_i)
        rescue
          next
        end
      end
        #Change candidate interview status to: completed text interview
        @candidate.update_attribute(:completed_text_interview, true)
        #Redirect based on what is pending for the candidate
        flash[:notice] = t(:text_answers_saved)
        redirect_to candidate_next_stage_path(@candidate)
    end
  end

end
