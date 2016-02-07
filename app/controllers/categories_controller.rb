class CategoriesController < ApplicationController

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params[:category])

    respond_to do |format|
     if @category.save
      format.html { redirect_to @category, notice: "Category successfully created" }
      format.json {}
      else
        format.html { render action: "new" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
     end
    end
  end

  def show
    @category = Category.find(params[:id])
    @text_questions = @category.questions.text
    @verbal_questions = @category.questions.verbal
  end

  def edit
    @category = Category.find(params[:id])
    @edit = true
    render 'new'
  end

  def update
    @category = Category.find(params[:id])
    @category.update_attributes(params[:category])
    redirect_to @category
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to current_admin
  end

end
