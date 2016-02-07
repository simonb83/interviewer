class AdminsController < ApplicationController

  def show
    @admin = Admin.find(params[:id])
    @organizations = Organization.all
    @categories = Category.all
    @issues = Issue.find(:all, order: "active desc, created_at desc")
    @accounts = Account.all
  end

  def admin_form
  end

  def update_item
    attribute = params[:attribute].to_sym
    value = params[:value]
    if Admin::MODELS.include?(params[:item_type])
      model = params[:item_type].constantize
    end

    begin
      result,message = model.find(params[:item_id].to_i).modify_attribute(attribute,value)
      flash[:notice] = message
      render 'admin_form' and return unless result

    rescue ActiveRecord::RecordNotFound => e
      flash[:notice] = e.message
      render 'admin_form' and return unless result
    end

    redirect_to(@admin)
  end

  def find_item
    begin
      if Admin::MODELS.include?(params[:item_type])
        model = params[:item_type].constantize
      end
      result = model.find(params[:item_id].to_i).attributes.to_json
      respond_to do |format|
        format.js { render json: result, status: :ok }
      end
    rescue ActiveRecord::RecordNotFound => e
      respond_to do |format|
        format.js { render json: e.message, status: :unprocessable_entity }
      end
    end
  end

end
