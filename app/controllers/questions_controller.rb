class QuestionsController < ApplicationController

  def new
    # @question = Question.new(category_id: params[:category_id])
    @category_id = params[:category_id]
    @options = ["Text","Verbal"]
  end

  def create_questions
    content = params[:content]
    category_id = params[:category_id]
    text = params[:text_question]
    verbal = params[:verbal_question]
    Question.create(content: content, category_id: category_id, kind: "text") if text == "1"
    Question.create(content: content, category_id: category_id, kind: "verbal") if verbal == "1"

    redirect_to category_path(Category.find(category_id))
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    redirect_to category_path(@question.category)
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])

    @question.update_attributes(params[:question])
    redirect_to category_path(@question.category), notice: "Question successfully updated."
  end

end

